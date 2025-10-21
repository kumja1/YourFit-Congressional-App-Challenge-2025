import 'dart:async';
import 'package:flutter/material.dart';
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
  late final Runnable llmChain;
  final DeviceService deviceService = Get.find();

  @override
  void onInit() {
    super.onInit();
    final model = ChatGoogleGenerativeAI(
      apiKey: Env.geminiKey,
      defaultOptions: ChatGoogleGenerativeAIOptions(
        model: "gemini-2.5-pro",
        responseMimeType: "application/json",
        safetySettings: const [
          ChatGoogleGenerativeAISafetySetting(
            category:
                ChatGoogleGenerativeAISafetySettingCategory.sexuallyExplicit,
            threshold:
                ChatGoogleGenerativeAISafetySettingThreshold.blockLowAndAbove,
          ),
          ChatGoogleGenerativeAISafetySetting(
            category: ChatGoogleGenerativeAISafetySettingCategory.hateSpeech,
            threshold:
                ChatGoogleGenerativeAISafetySettingThreshold.blockLowAndAbove,
          ),
          ChatGoogleGenerativeAISafetySetting(
            category:
                ChatGoogleGenerativeAISafetySettingCategory.dangerousContent,
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

    final nearestLocationsTool = Tool.fromFunction(
      name: "nearest_locations",
      description:
          "Returns the nearest locations to the user. Used for choosing destinations for running exercises",
      inputJsonSchema: {"type": "object", "properties": {
        "nothing": {"type": "string", "description": "Nothing"}
      }},
      func: (_) async {
        Get.log("Getting nearest locations");
        final locations = await deviceService.getPositionsNearDevice();
        Get.log("Locations: $locations");
        return {"locations": locations.map((e) => e.toJson()).toList()};
      },
      handleToolError: (e) {
        e.printError();
        return {};
      },
    );

    final agent = ToolsAgent.fromLLMAndTools(
      llm: model,
      tools: [nearestLocationsTool],
      systemChatMessage: SystemChatMessagePromptTemplate(
        prompt: PromptTemplate.fromTemplate("""
---- Instructions ----
You are a extremly considerate, medically accurate fitness trainer.
Your task: Provide the user with an appropriate response to the prompt, taking into consideration their age, height, weight, gender, physicalFitness, and any other additional parameters provided.
Follow these rules:
1. Response should be based on the given information as well as any additional information found in the dataset.
2. Response should not contain anything redundant.
3. Response should be in a JSON format and follow the schema provided.

---- Context ----
{context}
"""),
      ),
      extraPromptMessages: [
        ChatMessagePromptTemplate.human("""
Below is the information you will take into consideration when formulating your response.

---- Information ----
  {params}
"""),

        ChatMessagePromptTemplate.human("User Prompt: {input}"),
      ],
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
          "input": Runnable.getItemFromMap("prompt"),
          "params":
              Runnable.getItemFromMap("params") |
              Runnable.mapInput((params) {
                int i = 0;
                StringBuffer buffer = StringBuffer();
                for (MapEntry<String, Parameter> entry
                    in (params as Map<String, Parameter>).entries) {
                  i++;
                  buffer.writeln(
                    "${entry.key}: ${entry.value.value.toString()} (priority: ${entry.value.priority ?? i}) (description: ${entry.value.description})",
                  );
                }

                return buffer.toString();
              }),
        }) |
        AgentExecutor(agent: agent, maxExecutionTime: Duration(seconds: 15)) |
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
      print(e.stackTrace);
      return {};
    }
  }

  Future<Map<String, dynamic>?> invokeWithUser(
    UserData? user,
    String prompt, {
    Map<String, dynamic>? responseSchema,
    Map<String, Parameter> additionalParams = const {},
  }) async {
    try {
      if (user == null) return null;
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
          description: "User's height in centimeters",
        ),
        "weight": Parameter(
          priority: 2,
          value: user.weight,
          description: "User's weight in pounds",
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
      debugPrintStack(stackTrace: e.stackTrace);
      e.printError();
      return null;
    }
  }

  Future<WorkoutData?> getExercises(
    UserData? user, {
    String? prompt,
    ExerciseType? type,
    WorkoutFocus? focus,
    ExerciseDifficulty? difficulty,
    ExerciseIntensity? intensity,
    int count = 3,
    Map<String, Parameter> additionalParams = const {},
  }) async {
    try {
      final result = await invokeWithUser(
        user,
        "Provide the user with a workout with $count exercises. ${prompt ?? ''}",
        additionalParams: {
          ...additionalParams,
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
            priority: 5,
            value: focus?.name,
            description:
                "Indicates the main (but not only) focus area for the workout. Shouldn't completely overshadow similar parameters. ",
          ),
        },
        responseSchema: ResponseSchema.workout,
      );
      Get.log("[getExercises] Result $result");
      return result == null || result.isEmpty
          ? null
          : WorkoutData.fromMap(result);
    } on Error catch (e) {
      e.printError();
      return null;
    }
  }
}
