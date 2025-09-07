import 'dart:convert';
import 'dart:math' as Math;

import 'package:extensions_plus/extensions_plus.dart';
import 'package:http/http.dart' as http;
import 'package:langchain/langchain.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// {@template supabase}
/// Vector store for [Supabase Vector](https://supabase.com/vector)
/// embedding database.
///
/// It assumes a database with the `pg_vector` extension,
/// containing a [tableName] (default: `documents`) and
/// a [postgresFunctionName] (default: `match_documents`)
/// defined as follows:
///
/// ```sql
///  -- Enable the "vector" extension
/// create extension vector
/// with
///   schema extensions;
///
/// -- Create table to store the documents
/// create table documents (
///   id bigserial primary key,
///   content text,
///   metadata jsonb,
///   embedding vector(1536)
/// );
///
/// -- Create PostgreSQL function to query documents
/// create or replace function match_documents (
///   query_embedding vector(1536),
///   match_count int,
///   match_threshold float,
///   filter jsonb
/// ) returns table (
///   id bigint,
///   content text,
///   metadata jsonb,
///   similarity float
/// )
/// language sql stable
/// as $$
///   select
///     documents.id,
///     documents.content,
///     documents.metadata,
///     1 - (documents.embedding <=> query_embedding) as similarity
/// from documents
/// where metadata @> filter
///   and 1 - (documents.embedding <=> query_embedding) > match_threshold
/// order by (documents.embedding <=> query_embedding) asc
///     limit match_count;
/// $$;
/// ```
///
/// See documentation for more details:
/// - [LangChain.dart Supabase docs](https://langchaindart.dev/#/modules/retrieval/vector_stores/integrations/supabase)
/// - [Supabase Vector docs](https://supabase.com/docs/guides/ai)
/// {@endtemplate}
class Supabase extends VectorStore {
  /// Creates a new [Supabase] instance.
  ///
  /// Main configuration options:
  /// - [tableName] (default: `documents`): the Supabase table name.
  /// - `supabaseUrl`: the Supabase URL. You can find it in your project's
  ///   [API settings](https://supabase.com/dashboard/project/_/settings/api).
  ///   E.g. `https://xyzcompany.supabase.co`.
  /// - `supabaseKey`: the Supabase API key. You can find it in your project's
  ///   [API settings](https://supabase.com/dashboard/project/_/settings/api).
  ///
  /// Advance configuration options:
  /// - `headers`: overrides the default Supabase client headers.
  /// - `client`: the HTTP client to use. You can set your own HTTP client if
  ///   you need further customization (e.g. to use a Socks5 proxy).
  Supabase({
    this.tableName = 'documents',
    required final String supabaseUrl,
    required final String supabaseKey,
    final Map<String, String> headers = const {},
    final http.Client? client,
    required super.embeddings,
  }) : _client = SupabaseClient(
         supabaseUrl,
         supabaseKey,
         headers: headers,
         httpClient: client,
       );

  /// The Supabase client.
  final SupabaseClient _client;

  /// The Supabase table name.
  final String tableName;

  /// The name of the PostgreSQL function that executes the query.
  final postgresFunctionName = 'match_documents';

  /// Returns docs most similar to query using specified search type.
  ///
  /// - [query] is the query to search for.
  /// - [searchType] is the type of search to perform, either
  ///   [VectorStoreSearchType.similarity] (default) or
  ///   [VectorStoreSearchType.mmr].
  @override
  Future<List<Document>> search({
    required final String query,
    required final VectorStoreSearchType searchType,
  }) async {
    try {
      final queryEmbedding = await embeddings.embedQuery(query);

      final docs = await switch (searchType) {
        VectorStoreSimilaritySearch config =>
          similaritySearchByVectorWithScores(
            embedding: queryEmbedding,
            config: config,
          ),
        VectorStoreMMRSearch config => maxMarginalRelevanceSearchByVectorAsync(
          embedding: queryEmbedding,
          config: config,
        ),
      };
      return docs as List<Document>;
    } catch (e) {
      print("Error during search: $e");
      return [];
    }
  }

  @override
  Future<List<String>> addVectors({
    required final List<List<double>> vectors,
    required final List<Document> documents,
  }) async {
    try {
      assert(vectors.length == documents.length);

      final List<Map<String, dynamic>> records = [];
      for (var i = 0; i < documents.length; i++) {
        final doc = documents[i];
        records.add({
          if (doc.id != null) 'id': doc.id,
          'metadata': doc.metadata,
          'content': doc.pageContent,
          'embedding': vectors[i],
        });
      }

      final ids = await _client.from(tableName).upsert(records).select('id');
      return ids
          .map((final row) => row['id'])
          .map((final id) => id.toString())
          .toList(growable: false);
    } catch (e) {
      print("Error adding vectors: $e");
      return [];
    }
  }

  @override
  Future<void> delete({required final List<String> ids}) {
    return _client.from(tableName).delete().filter('id', 'in', ids);
  }

  @override
  Future<List<(Document, double similarity)>>
  similaritySearchByVectorWithScores({
    required final List<double> embedding,
    final VectorStoreSimilaritySearch config =
        const VectorStoreSimilaritySearch(),
  }) async {
    try {
      final result = await similaritySearchByVectorWithScoresAndEmbeddings(
        embedding: embedding,
        config: config,
      );
      return result
          .map((doc) => (doc.document, doc.similarity))
          .toList(growable: false);
    } catch (e) {
      print("Error performing similarity search with scores: $e");
      return [];
    }
  }

  Future<
    List<({Document document, List<double> embeddings, double similarity})>
  >
  similaritySearchByVectorWithScoresAndEmbeddings({
    required final List<double> embedding,
    final VectorStoreSimilaritySearch config =
        const VectorStoreSimilaritySearch(),
  }) async {
    try {
      final params = {
        'query_embedding': embedding,
        'match_count': config.k,
        'match_threshold': config.scoreThreshold ?? 0.0,
        'filter': config.filter ?? {},
      };

      final List<dynamic> result = await _client.rpc(
        postgresFunctionName,
        params: params,
      );

      return result
          .map((final row) => row as Map<String, dynamic>)
          .map(
            (final row) => (
              document: Document(
                id: row['id'].toString(),
                pageContent: row['content'] as String,
                metadata: row['metadata'] as Map<String, dynamic>,
              ),
              embeddings: List.from(
                row["embedding"],
                growable: false,
              ).cast<double>(),
              similarity: row['similarity'] as double,
            ),
          )
          .toList(growable: false);
    } catch (e) {
      print(
        "Error performing similarity search with scores and embeddings: $e, ${e is Error ? e.stackTrace : "No Stack Trace"}",
      );
      return [];
    }
  }
Future<List<Document>> maxMarginalRelevanceSearchByVectorAsync({
  required final List<double> embedding,
  final VectorStoreMMRSearch config = const VectorStoreMMRSearch(),
}) async {
  try {
    print("MMR search: fetching ${config.fetchK} candidates, target: ${config.k}, λ: ${config.lambdaMult}");
    
    List<({Document document, List<double> embeddings, double similarity})> docs = 
        await similaritySearchByVectorWithScoresAndEmbeddings(
      embedding: embedding,
      config: VectorStoreSimilaritySearch(k: config.fetchK),
    );

    if (docs.isEmpty) {
      print("MMR: no documents retrieved");
      return [];
    }

    final List<List<double>> embeddings = [
      ...docs.map((doc) => doc.embeddings),
    ];

    print("MMR: ${embeddings.length} embeddings retrieved");
    print("MMR: initial similarities: ${docs.map((d) => d.similarity.toStringAsFixed(3)).join(', ')}");

    final mostSimilarEmbeddingIndex = getIndexesMostSimilarEmbeddings(
      embedding,
      embeddings,
    ).first;
    
    print("MMR: starting with most similar index $mostSimilarEmbeddingIndex");

    final selectedEmbeddings = [embeddings[mostSimilarEmbeddingIndex]];
    final selectedEmbeddingsIndexes = [mostSimilarEmbeddingIndex];
    final similaritiesAndIndexes = docs.toIndexMap().map(
      (index, doc) => MapEntry(index, doc.similarity),
    );

    print("MMR: similarity map keys: ${similaritiesAndIndexes.keys.toList()}");

    int iteration = 0;
    while (selectedEmbeddingsIndexes.length < Math.min(config.k, embeddings.length)) {
      iteration++;
      print("\n--- MMR Iteration $iteration ---");
      print("Current selection: ${selectedEmbeddingsIndexes.join(', ')}");
      
      double bestScore = -1;
      int bestIndex = -1;

      try {
        final similarityToSelected = [
          ...embeddings.map(
            (e) => calculateSimilarity(e, selectedEmbeddings),
          ),
        ];

        print("Similarity matrix: ${similarityToSelected.length} rows × ${similarityToSelected.first.length} cols");

        int candidatesChecked = 0;
        similaritiesAndIndexes.forEach((index, similarityScore) {
          if (selectedEmbeddingsIndexes.contains(index)) {
            return;
          }
          
          candidatesChecked++;
          
          final maxSimilarityToSelected = similarityToSelected[index].maxBy(
            (value) => value,
          );

          final score = config.lambdaMult * similarityScore -
              (1 - config.lambdaMult) * maxSimilarityToSelected!;


          if (score > bestScore) {
            bestScore = score;
            bestIndex = index;
            print("  ^ NEW BEST");
          }
        });
        
        print("Checked $candidatesChecked candidates");
        
        if (bestIndex == -1) {
          print("No valid candidate found, breaking");
          break;
        }
        
        selectedEmbeddings.add(embeddings[bestIndex]);
        selectedEmbeddingsIndexes.add(bestIndex);
        print("Selected index $bestIndex with MMR score ${bestScore.toStringAsFixed(3)}");
        
      } catch (e) {
        print("MMR iteration $iteration error: $e");
        break;
      }
    }
    return docs.indexed
        .where((item) => selectedEmbeddingsIndexes.contains(item.$1))
        .map((item) => item.$2.document)
        .toList();
        
  } catch (e) {
    print("MMR search failed: $e");
    return [];
  }
}

  Future<List<Document>> hybridSearch({required String query}) async {
    try {
      return await hybridSearchByVector(
        query: query,
        embedding: await embeddings.embedQuery(query),
      );
    } catch (e) {
      print("Error performing hybrid search: $e");
      return [];
    }
  }

  Future<List<Document>> hybridSearchByVector({
    required String query,
    required List<double> embedding,
  }) async {
    final params = {
      'query_text': query,
      'query_embedding': embedding,
      'match_count': 15,
      "full_text_weight": 1,
      "semantic_weight": 3,
      "rrf_k": 50,
    };

    try {
      final List<dynamic> result = await _client.rpc(
        postgresFunctionName,
        params: params,
      );

      return result
          .map((final row) => row as Map<String, dynamic>)
          .map(
            (final row) => Document(
              id: row['id'].toString(),
              pageContent: row['content'] as String,
              metadata: row['metadata'] as Map<String, dynamic>,
            ),
          )
          .toList(growable: false);
    } catch (e) {
      print("Error performing hybrid search by vector: $e");
      return [];
    }
  }
}
