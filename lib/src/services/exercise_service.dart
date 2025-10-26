import 'dart:async';
import 'package:get/get.dart';
import 'package:yourfit/src/models/index.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:yourfit/src/services/device_service.dart';
import 'package:yourfit/src/utils/objects/constants/env/env.dart';
import 'package:yourfit/src/utils/objects/constants/exercise/response_schema.dart';
import 'package:yourfit/src/utils/objects/other/exercise/parameter.dart';
import 'package:yourfit/src/utils/objects/other/supabase/supabase_vectorstore.dart';

class ExerciseService extends GetxService {
  final DeviceService deviceService = Get.find();
  late final Runnable llmChain;

  @override
  void onInit() {
    super.onInit();
    final model =
        ChatPromptTemplate.fromPromptMessages([
          ChatMessagePromptTemplate.system("""
---- Instructions ----
You are a extremly considerate, medically accurate fitness trainer.
Your task: Provide the user with an appropriate response to the prompt, taking into consideration their age, height, weight, gender, physicalFitness, and any other additional parameters provided.
Follow these rules:
1. Response should be based on the given information as well as any additional information found in the dataset.
2. Response should not contain anything redundant but remain relatively consistent with the historical data provided, upscaling if necessary.
3. Response should be in a JSON format and follow the schema provided.

---- Context ----
{context}
"""),
          ChatMessagePromptTemplate.human("""
Below is the information you will take into consideration when formulating your response.

---- Information ----
  {params}
"""),

          ChatMessagePromptTemplate.human("User Prompt: {prompt}"),
        ]) |
        ChatGoogleGenerativeAI(
          apiKey: Env.geminiKey,
          defaultOptions: ChatGoogleGenerativeAIOptions(
            model: "gemini-2.5-flash",
            responseMimeType: "application/json",
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
                      searchType: VectorStoreMMRSearch(k: 20),
                    ),
                  ) |
                  Runnable.mapInput((docs) => docs.join("\n"))),
          "prompt": Runnable.getItemFromMap("prompt"),
          "params":
              Runnable.getItemFromMap("params") |
              Runnable.mapInput((params) {
                int i = 0;
                StringBuffer buffer = StringBuffer();
                for (MapEntry<String, Parameter> entry
                    in (params as Map<String, Parameter>).entries) {
                  i++;
                  buffer.writeln(
                    "${entry.key}: ${entry.value.value} (priority: ${entry.value.priority ?? i}) (description: ${entry.value.description})",
                  );
                }
                buffer.printInfo();
                return buffer.toString();
              }),
        }) |
        model |
        JsonOutputParser();
  }

  Future<Map<String, dynamic>> invoke(
    String prompt,
    Map<String, Parameter> params, {
    Map<String, dynamic>? responseSchema,
  }) async {
    Get.log("Invoking LLM with parameters: $params");
    try {
      Map<String, dynamic> results =
          await llmChain.invoke(
                {"params": params, "prompt": prompt},
                options: responseSchema == null
                    ? null
                    : ChatGoogleGenerativeAIOptions(
                        responseSchema: responseSchema,
                      ),
              )
              as Map<String, dynamic>;

      Get.log("Results: $results");
      return results;
    } on Error catch (e) {
      e.printError();
      return {};
    }
  }

  Future<Map<String, dynamic>> invokeWithUser(
    UserData? user,
    String prompt, {
    Map<String, dynamic>? responseSchema,
    Map<String, Parameter> additionalParams = const {},
  }) async {
    try {
      if (user == null) return {};

      return await invoke(prompt, {
        "age": Parameter(
          priority: 1,
          value: user.age,
          description: "User's age in years",
        ),
        "goal": Parameter(
          priority: 1,
          value: user.goal,
          description: "User's fitness goal",
        ),
        "bmi": Parameter(
          priority: 1,
          value: user.bmi,
          description: "User's body mass index",
        ),
        "physicalFitness": Parameter(
          priority: 2,
          value: user.physicalFitness,
          description: "User's current physical fitness level",
        ),
        "height": Parameter(
          priority: 2,
          value: user.height,
          description: "User's height in centimeters (cm)",
        ),
        "weight": Parameter(
          priority: 2,
          value: user.weight,
          description: "User's weight in pounds (lbs)",
        ),
        "gender": Parameter(
          priority: 3,
          value: user.gender,
          description: "User's gender",
        ),
        "equipment": Parameter(
          priority: 3,
          value: user.equipment,
          description: "Available equipment for workout",
        ),
        "disabilities": Parameter(
          priority: 3,
          value: user.disabilities,
          description: "User's physical limitations or disabilities",
        ),
        "workoutData": Parameter(
          priority: 4,
          value: user.workoutData,
          description: "User's historical workout data",
        ),
        ...additionalParams,
      }, responseSchema: responseSchema);
    } on Error catch (e) {
      e.printError();
      return {};
    }
  }

  Future<WorkoutData?> getExercises(
    UserData? user, {
    String? prompt,
    ExerciseType? type,
    WorkoutFocus? focus,
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    int count = 0,
    Map<String, Parameter> additionalParams = const {},
  }) async {
    try {
      final result = await invokeWithUser(
        user,
        "Provide the user with a workout. Ensure that each exercise follows the SRP (Single Responsibility Principle). ${prompt ?? ''}",
        additionalParams: {
          ...additionalParams,
          "workout_exercise_count": Parameter(
            priority: 5,
            value: count,
            description: "Number of exercises in the workout. Provide a value if not provided",
          ),
          "workout_exercise_difficulty": Parameter(
            priority: 5,
            value: difficulty?.name,
            description: "Desired difficulty level for workout exercises",
          ),
          "workout_exercise_intensity": Parameter(
            priority: 5,
            value: intensity?.name,
            description: "Desired intensity level for workout exercises",
          ),
          "workout_exercise_type": Parameter(
            priority: 5,
            value: type?.name,
            description: "Type of exercise (strength, cardio, etc.)",
          ),
          "workout_focus": Parameter(
            priority: 6,
            value: focus?.name,
            description:
                "Desired focus for the overall workout.",
          ),
        },
        responseSchema: ResponseSchema.workout,
      );
      Get.log("[getExercises] Result $result");
      return result.isEmpty ? null : WorkoutData.fromMap(result);
    } on Error catch (e) {
      e.printError();
      return null;
    }
  }
}
