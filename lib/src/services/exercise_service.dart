import 'package:get/get.dart';
import 'package:yourfit/src/models/day_data.dart';
import 'package:yourfit/src/models/exercise_data.dart';
import 'package:yourfit/src/models/user_data.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:yourfit/src/utils/constants/env/env.dart';
import 'package:yourfit/src/utils/supabase_vectorstore.dart';

class ExerciseService extends GetxService {
  late final Runnable llmChain;

  @override
  void onInit() async {
    super.onInit();
    final model =
        ChatPromptTemplate.fromTemplates([
          (
            ChatMessageType.system,
            """
---- Instructions ----
You are a thoughtful, detailed, accurate, and considerate fitness trainer who always provides the user with the appropriate exercise(s) to perform at their age, height, weight, physicalFitness, and any other additional parameters. You are also excellent at math which enables you to give out mathematically correct solutions when necessary. Your response should only be related to the given information provided to you by the user and relevant information found in the dataset. Your response should also contain no introduction or explanation, only the information necessary in valid JSON format.

---- Context ----
{context}
""",
          ),

          (
            ChatMessageType.human,
            """

Below is the information you will take into consideration when formulating your response.
---- User Information ----
age: {age}
height: {height}
weight: {weight}
physicalFitness: {physicalFitness}
gender: {gender}
equipment: {equipment}
disabilities: {disabilities}
{additionalParameters}
""",
          ),

          (ChatMessageType.human, "User Input: {prompt}"),
        ]) |
        ChatGoogleGenerativeAI(
          apiKey: Env.geminiKey,
          defaultOptions: ChatGoogleGenerativeAIOptions(
            model: "gemini-2.5-pro",
            tools: [
              ToolSpec(
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
                          'intensity': {
                            'type': 'string',
                            'enum': ['low', 'medium', 'high'],
                            'description': 'Intensity level of the exercise',
                          },
                          'type': {
                            'type': 'string',
                            'enum': [
                              'strength',
                              'cardio',
                              'flexibility',
                              'balance',
                            ], 
                            'description':
                                'The exercise type of exercise. Must be one of: cardio (Improves heart and lung function, builds endurance for sustained physical activity), strength (Develops muscle power and force production for lifting, throwing, and resistance movements), flexibility (Increases range of motion and mobility for better movement quality and injury prevention), balance (Enhances stability, coordination, and body control during static and dynamic activities)',
                          },
                          'caloriesBurned': {
                            'type': 'number',
                            'description': 'Calories burned per exercise',
                          },
                          'name': {
                            'type': 'string',
                            'description': 'Exercise name',
                          },
                          'instructions': {
                            'type': 'string',
                            'description': 'Instructions for the exercise',
                          },
                          'targetMuscles': {
                            'type': 'array',
                            'items': {'type': 'string'},
                            'description': 'List of target muscles',
                          },
                          'sets': {
                            'type': 'integer',
                            'description': 'Number of sets',
                          },
                          'reps': {
                            'type': 'integer',
                            'description': 'Number of reps',
                          },
                        },
                        'required': [
                          'difficulty',
                          'intensity', // Added to required fields
                          'type', // Added to required fields
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
              ),
            ],
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

    llmChain =
        Runnable.fromMap({
          "context":
              Runnable.getItemFromMap("prompt") |
              (vectorStore.asRetriever(
                    defaultOptions: VectorStoreRetrieverOptions(
                      searchType: VectorStoreMMRSearch(k: 15),
                    ),
                  ) |
                  Runnable.mapInput((docs) => docs.join("\n"))),
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
  }

  Future<Map<String, dynamic>> invoke(Map<String, dynamic> params) async {
    print("Invoking LLM with parameters: $params");
    try {
      List<ParsedToolCall> results =
          await llmChain.invoke(params) as List<ParsedToolCall>;
      return results.isEmpty ? {} : results[0].arguments;
    } on Error catch (e) {
      print("ERROR:$e, ${e.stackTrace.toString()}");
      return {};
    }
  }

  Future<Map<String, dynamic>> invokeWithUser(
    UserData user,
    String prompt, {
    Map<String, dynamic> additionalParameters = const {},
  }) async {
    try {
      return await invoke({
        "equipment": user.equipment,
        "disabilities": user.disabilities,
        "weight": user.weight,
        "height": user.height,
        "age": user.age,
        "gender": user.gender,
        "physicalFitness": user.physicalFitness,
        "prompt": prompt,
        "additionalParameters": additionalParameters,
      });
    } catch (e) {
      print(e);
      return {};
    }
  }

  Future<DayData?> getExercises(
    UserData user, {
    ExerciseType? type,
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    Map<String, dynamic> additionalParameters = const {},
    int count = 3,
  }) async {
    additionalParameters = {
      ...additionalParameters,
      "exercise_type": type?.name,
      "exercise_difficulty": difficulty?.name,
      "exercise_intensity": intensity?.name,
    };

    final result = await invokeWithUser(
      user,
      "Please provide the user with $count exercises",
      additionalParameters: additionalParameters,
    );
    print(result);
    return DayDataMapper.fromMap(result);
  }
}
