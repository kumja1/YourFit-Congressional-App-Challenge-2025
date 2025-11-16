class ResponseSchema {
  static final workout = const {
    'type': 'object',
    'name': 'workout',
    'description':
        'A JSON object containing a list of exercises, a summary of the exercises, total calories burned from the exercises, and the total duration of the exercises.',
    'properties': {
      'exercises': {
        'type': 'array',
        'description': 'An array of exercise objects.',
        'items': {
          'type': 'object',
          'description': 'An exercise object.',
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
            'model_type': {
              'type': 'string',
              'enum': ['running', 'basic'],
              'description': 'The model type this object should be parsed into',
            },
            'caloriesBurned': {
              'type': 'number',
              'description': 'Calories burned per exercise',
            },
            'name': {
              'type': 'string',
              'description': 'A short, informative name for the exercise.',
            },
            'instructions': {
              'type': 'string',
              'description':
                  'Short, informative instructions on performing the exercise.',
            },
            'summary': {
              'type': 'string',
              'description': 'A quick summary of the exercise.',
            },
            'targetMuscles': {
              'type': 'array',
              'items': {'type': 'string'},
              'description': 'List of target muscles',
            },
            'sets': {
              'type': 'integer',
              'description': 'Number of sets to perform',
              'minimum': 1,
            },
            'equipment': {
              'type': 'array',
              'items': {'type': 'string'},
              'description': 'List of equipment',
            },
            'setDuration': {
              'type': 'object',
              'description': 'Duration of an exercise set.',
              'properties': {
                'inSeconds': {
                  "type": "integer",
                  "description": "The duration length (in seconds)",
                },
              },
              'required': ['inSeconds'],
            },
            'duration': {
              'type': 'object',
              'description': 'Total duration of the exercise (in seconds)',
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
            'distance': {
              'type': 'number',
              'description': 'Distance in miles for a running exercise',
            },
            'speed': {
              'type': 'integer',
              'description': 'Speed to be maintained for a running exercise',
            },
            'destination': {
              'type': 'string',
              'description': 'The destination address of a running exercise',
            },
          },
          'required': [
            'difficulty',
            'intensity',
            "restIntervals",
            'type',
            'model_type',
            'equipment',
            'duration',
            'setDuration',
            'caloriesBurned',
            'name',
            'summary',
            'instructions',
            'targetMuscles',
            'sets',
            'reps',
          ],
        },
      },
      'caloriesBurned': {
        'type': 'number',
        'description': 'Total calories burned in workout ',
      },
      'summary': {
        'type': 'string',
        'description': 'A quick summary of the workout.',
      },
      'duration': {
        'type': 'object',
        'description': 'Total duration of the workout',
        'properties': {
          'inSeconds': {
            "type": "integer",
            "description": "The duration length (in seconds)",
          },
        },
      },
      'focus': {
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
        'description':
            'The focus of the workout. Influences a majority of the workout exercises',
      },
      'reasoning': {
        'type': 'string',
        'description':
            'An indepth reasoning about the workout given and things taken into consideration',
      },
    },
    'required': ['exercises', 'caloriesBurned', 'summary', 'focus', 'duration'],
  };

  static final answer = const {
    'type': "object",
    'name': "answer",
    'description': "The answer to a question",
    'properties': {
      "answer": {"type": "string", "description": "The answer to a question"},
    },
    'required': ['answer'],
  };
}
