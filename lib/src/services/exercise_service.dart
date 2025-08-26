import 'package:get/get.dart';
import 'package:yourfit/src/models/day_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:zard/zard.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain_supabase/langchain_supabase.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';

class ExerciseService extends GetxService {
  late final Runnable llmChain;

  @override
  void onInit() async {
    super.onInit();

    final vectorStore = Supabase(
      tableName: "documents",
      supabaseUrl: Env.supabaseUrl,
      supabaseKey: Env.supabaseKey,
      embeddings: GoogleGenerativeAIEmbeddings(
        apiKey: Env.geminiKey,
        dimensions: 384,
      ),
    );

    final outputSchema = ToolSpec(
      name: 'dayData',
      description:
          'Validate a DayData object (list of exercises and total calories burned) using the Zard schema.',
      inputJsonSchema: {
        'type': 'object',
        'properties': {
          'exercises': {
            'type': 'array',
            'items': {
              'type': 'object',
              'properties': {
                'difficulty': {
                  'type': 'string',
                  'enum': ['easy', 'medium', 'hard'],
                  'description': 'Difficulty level of the exercise',
                },
                'caloriesBurned': {
                  'type': 'number',
                  'description': 'Calories burned per exercise',
                },
                'name': {'type': 'string', 'description': 'Exercise name'},
                'instructions': {
                  'type': 'string',
                  'description': 'Instructions for the exercise',
                },
                'targetMuscles': {
                  'type': 'array',
                  'items': {'type': 'string'},
                  'description': 'List of target muscles',
                },
                'sets': {'type': 'integer', 'description': 'Number of sets'},
                'reps': {'type': 'integer', 'description': 'Number of reps'},
              },
              'required': [
                'difficulty',
                'caloriesBurned',
                'name',
                'instructions',
                'targetMuscles',
                'sets',
                'reps',
              ],
            },
            'description': 'List of exercises with full details.',
          },
          'caloriesBurned': {
            'type': 'number',
            'description': 'Total calories burned for the day',
          },
        },
        'required': ['exercises', 'caloriesBurned'],
      },
      strict: true,
    );
    final model =
        ChatPromptTemplate.fromTemplates([
          (
            ChatMessageType.system,
            """
---- Instructions ----
You are a thoughtful, detailed, accurate, and considerate fitness trainer who always provides the user with the appropriate exercise(s) to perform at their age, height, weight, and physicalActivity. You are also a excellent at math which enables you to give out mathematically correct numbers and calculations when necessary. Your response should only be related to the given information provided to you by the user and relevant informative information found in the knowledgebase. Your response should also only contain the information necesssary and should contain no introduction or explanation, only valid JSON that can be parsed.

---- Context ----
{context}

Below is the information you will take into consideration when formualating your response.

----User Information----
age:{age}
height:{height}
weight:{weight}
physicalActivity:{physicalActivity}
""",
          ),

          (ChatMessageType.human, "{input}"),
        ]) |
        ChatGoogleGenerativeAI(
          apiKey: Env.geminiKey,
          defaultOptions: ChatGoogleGenerativeAIOptions(
            model: "gemini-2.5-pro",
            safetySettings: const [
              ChatGoogleGenerativeAISafetySetting(
                category: ChatGoogleGenerativeAISafetySettingCategory
                    .sexuallyExplicit,
                threshold: ChatGoogleGenerativeAISafetySettingThreshold
                    .blockLowAndAbove,
              ),
              ChatGoogleGenerativeAISafetySetting(
                category:
                    ChatGoogleGenerativeAISafetySettingCategory.hateSpeech,
                threshold: ChatGoogleGenerativeAISafetySettingThreshold
                    .blockLowAndAbove,
              ),
              ChatGoogleGenerativeAISafetySetting(
                category: ChatGoogleGenerativeAISafetySettingCategory
                    .dangerousContent,
                threshold: ChatGoogleGenerativeAISafetySettingThreshold
                    .blockLowAndAbove,
              ),
            ],
            tools: [outputSchema],
            toolChoice: ChatToolChoice.forced(name: "dayData"),
          ),
        );

    llmChain =
        Runnable.fromMap({
          "context":
              Runnable.getItemFromMap("input") |
              (vectorStore.asRetriever() |
                  Runnable.mapInput((docs) => docs.join("\n"))),
          "physicalActivity": Runnable.getItemFromMap("physicalActivity"),
          "age": Runnable.getItemFromMap("age"),
          "height": Runnable.getItemFromMap("height"),
          "weight": Runnable.getItemFromMap("weight"),
          "input": Runnable.getItemFromMap("input"),
        }) |
        model |
        StringOutputParser();
  }

  Future<String?> invoke(Map<String, dynamic> params) async {
    print("Invoking LLM with parameters: $params");
    try {
      var result = await llmChain.invoke(params);
      print("LLM returned: $result");
      return result as String?;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> invokeWithUser(UserData user, String input) async {
    try {
      return await invoke({
        "weight": user.weight,
        "height": user.height,
        "age": user.age,
        "physicalActivity": user.physicalActivity,
        "input": input,
      });
    } catch (e) {
      print(e);
      return "";
    }
  }

  Future<DayData?> getExercises(UserData user) async {
    final result = await invokeWithUser(
      user,
      "Provide a list of 3 exercises for the user",
    );

    print(result);
    if (result == null) return null;

    return DayDataMapper.fromJson(result);
  }
}
