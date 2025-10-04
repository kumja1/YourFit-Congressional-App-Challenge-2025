import 'package:get/get.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:yourfit/src/services/auth_service.dart';
import 'package:yourfit/src/utils/objects/env/env.dart';
import 'package:yourfit/src/utils/objects/vectorstore/supabase_vectorstore.dart';

class ExerciseService extends GetxService {
  late final Runnable llmChain;
  final Rx<UserData?> currentUser = Get.find<AuthService>().currentUser;

  @override
  void onInit() {
    try {
      super.onInit();
      final model =
          ChatPromptTemplate.fromPromptMessages([
            ChatMessagePromptTemplate.system("""
---- Context ----
{context}

---- Instructions ----
You are a thoughtful, detailed, medically accurate fitness trainer that provides the user with appropriate exercise(s) to perform at their age, height, weight, gender, physicalFitness, and any other additional parameters provided. 
You are also excellent at math which enables you to give out mathematically correct, evidence based solutions when necessary. 
Your response should only be related to the given information provided to you by the user and relevant information found in the dataset. 
Your response should not repeat any of the information provided to and should contain no introduction or explanation, only the information necessary in a valid JSON format. 
"""),

            ChatMessagePromptTemplate.human("""
Below is the information you will take into consideration when formulating your response.

---- User Information ----
  age: {age}
  height: {height} cm
  weight: {weight} lbs
  physicalFitness: {physicalFitness}
  gender: {gender}
  equipment: {equipment}
  disabilities: {disabilities}
  exercisesData: {exerciseData}

---- Additional Information ----
  {additionalParameters}
"""),

            ChatMessagePromptTemplate.human("User Input: {prompt}"),
          ]) |
          ChatGoogleGenerativeAI(
            apiKey: Env.geminiKey,
            defaultOptions: ChatGoogleGenerativeAIOptions(
              model: "gemini-2.5-pro",
              tools: const [],
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
                      .blockMediumAndAbove,
                ),
              ],
            ),
          );

      final vectorStore = Supabase(
        tableName: "documents",
        supabaseUrl: Env.supabaseUrl,
        supabaseKey: Env.supabaseKey,
        embeddings: GoogleGenerativeAIEmbeddings(
          model: "gemini-embedding-001",
          apiKey: Env.geminiKey,
          dimensions: 1024,
        ),
      );
      try {
        llmChain =
            Runnable.fromMap({
              "context":
                  Runnable.getItemFromMap("prompt") |
                  (vectorStore.asRetriever(
                        defaultOptions: VectorStoreRetrieverOptions(
                          searchType: VectorStoreMMRSearch(k: 20),
                        ),
                      ) |
                      Runnable.mapInput((docs) => docs.join("\n"))),
              "exerciseData":
                  Runnable.getItemFromMap("exerciseData") |
                  Runnable.mapInput((data) {
                    final str = (data as Map<String, MonthData>).entries
                        .map(
                          (entry) =>
                              "{'${entry.key}':${entry.value.toJson()})}",
                        )
                        .join(" | ");
                    print(str);
                    return str;
                  }),
              "equipment":
                  Runnable.getItemFromMap("equipment") |
                  Runnable.mapInput(
                    (equipment) => (equipment as List<String>).join(", "),
                  ),
              "disabilities":
                  Runnable.getItemFromMap("disabilities") |
                  Runnable.mapInput(
                    (disabilties) => (disabilties as List<String>).join(", "),
                  ),
              "gender": Runnable.getItemFromMap("gender"),
              "physicalFitness": Runnable.getItemFromMap("physicalFitness"),
              "age": Runnable.getItemFromMap("age"),
              "height": Runnable.getItemFromMap("height"),
              "weight": Runnable.getItemFromMap("weight"),
              "prompt": Runnable.getItemFromMap("prompt"),
              "additionalParameters":
                  Runnable.getItemFromMap("additionalParameters") |
                  Runnable.mapInput(
                    (input) => (input as Map<String, dynamic>).entries
                        .map((entry) => "${entry.key}: ${entry.value}")
                        .join("\n"),
                  ),
            }) |
            model |
            ToolsOutputParser();
      } on Error catch (e) {
        print("$e, ${e.stackTrace}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> invoke(
    Map<String, dynamic> params, {
    ToolSpec? responseType,
  }) async {
    print("Invoking LLM with parameters: $params");
    try {
      final chain = llmChain.bind(
        ChatGoogleGenerativeAIOptions(
          tools: [responseType ?? ResponseType.workout],
        ),
      );
      List<ParsedToolCall> results =
          await chain.invoke(params) as List<ParsedToolCall>;
      return results.isEmpty ? {} : results[0].arguments;
    } on Error catch (e) {
      print("ERROR:$e, ${e.stackTrace.toString()}");
      return {};
    }
  }

  Future<Map<String, dynamic>?> invokeWithUser(
    UserData? user,
    String prompt, {
    ToolSpec? responseType,
    Map<String, dynamic> additionalParameters = const {},
  }) async {
    try {
      if (user == null) return null;

      return await invoke({
        "equipment": user.equipment,
        "disabilities": user.disabilities,
        "weight": user.weight,
        "height": user.height,
        "age": user.age,
        "gender": user.gender,
        "exerciseData": user.exerciseData,
        "physicalFitness": user.physicalFitness,
        "prompt": prompt,
        "additionalParameters": additionalParameters,
      }, responseType: responseType);
    } catch (e) {
      print("Error: $e");
      return {};
    }
  }

  Future<WorkoutData?> getExercises(
    UserData? user, {
    ExerciseType? type,
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    ToolSpec? responseType,
    Map<String, dynamic> additionalParameters = const {},
    int count = 3,
  }) async {
    final result = await invokeWithUser(
      user,
      "Please provide the user with $count exercises",
      additionalParameters: {
        ...additionalParameters,
        "exercise_type": type?.name,
        "exercise_difficulty": difficulty?.name,
        "exercise_intensity": intensity?.name,
      },
      responseType: responseType,
    );
    print(result);
    return result == null ? null : WorkoutData.fromMap(result);
  }
}

class ResponseType {
  static final workout = const ToolSpec(
    name: 'workout_data',
    description:
        'Validate a WorkoutData object (list of exercises and total calories burned) using the JSON schema.',
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
              'intensity': {
                'type': 'string',
                'enum': ['low', 'medium', 'high'],
                'description': 'Intensity level of the exercise',
              },
              'type': {
                'type': 'string',
                'enum': ['strength', 'cardio', 'flexibility', 'balance'],
                'description':
                    'The exercise type of the exercise. Must be one of: cardio (Improves heart and lung function, builds endurance for sustained physical activity), strength (Develops muscle power and force production for lifting, throwing, and resistance movements), flexibility (Increases range of motion and mobility for better movement quality and injury prevention), balance (Enhances stability, coordination, and body control during static and dynamic activities)',
              },
              'caloriesBurned': {
                'type': 'number',
                'description': 'Calories burned per exercise',
              },
              'name': {'type': 'string', 'description': 'Exercise name'},
              'instructions': {
                'type': 'string',
                'description': 'Instructions for the exercise.',
              },
              'summary': {
                'type': 'string',
                'description': 'A quick summary of the exercise. ',
              },
              'targetMuscles': {
                'type': 'array',
                'items': {'type': 'string'},
                'description': 'List of target muscles',
              },
              'sets': {'type': 'integer', 'description': 'Number of sets'},
              'equipment': {
                'type': 'array',
                'items': {'type': 'string'},
                'description': 'List of equipment',
              },
              'durationPerSet': {
                'type': 'object',
                'description': 'Duration of each set (in seconds)',
                'properties': {
                  'inSeconds': {
                    "type": "integer",
                    "description": "The duration length (in seconds)",
                  },
                },
                'required': ['inSeconds'],
              },
              'restIntervals': {
                'type': 'array',
                'description': 'Rest intervals for the exercise.',
                'minItems': 1,
                'items': {
                  'type': 'object',
                  'properties': {
                    'restAt': {
                      'type': 'integer',
                      'description': 'Second the rest starts',
                    },
                    'duration': {
                      'type': 'object',
                      'description': 'Duration of the rest interval',
                      'properties': {
                        'inSeconds': {
                          "type": "integer",
                          "description": "The duration length (in seconds)",
                        },
                      },
                    },
                  },
                  'required': ['restAt', 'duration'],
                },
              },
              'reps': {'type': 'integer', 'description': 'Number of reps'},
            },
            'required': [
              'difficulty',
              'intensity',
              "restIntervals",
              'type',
              'equipment',
              'durationPerSet',
              'caloriesBurned',
              'name',
              'summary',
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
        'summary': {
          'type': 'string',
          'description': 'A summary of the exercises for the day',
        },
        'type': {
          'type': 'string',
          'enum': [
            'leg',
            'upperBody',
            'cardio',
            'core',
            'fullBody',
            'rest',
            'yoga',
          ],
          'description': 'The type of exercises for the day',
        },
      },
      'required': ['exercises', 'caloriesBurned', 'summary', 'type'],
    },
  );

  static final answer = const ToolSpec(
    name: "answer",
    description: "The answer to a question",
    inputJsonSchema: {
      "type": "object",
      "properties": {
        "answer": {"type": "string", "description": "The answer to a question"},
        'required': ['answer'],
      },
    },
  );
}
