import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiInsightsPanel extends StatelessWidget {
  const AiInsightsPanel({
    super.key,
    required this.explanation,
    required this.onTweak,
  });

  final String explanation;
  final Future<void> Function(String instruction) onTweak;

  Widget _chip(String label, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: GetBuilder<_AiInsightsPanelController>(id:"submitting", builder: (controller)=> ActionChip(
        label: Text(label),
        onPressed: controller.loading ? null : () => controller.send(instruction, onTweak),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.psychology, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'AI Insights',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                GetBuilder<_AiInsightsPanelController>(
                  id: "expanded",
                  init: _AiInsightsPanelController(),
                  builder: (controller) => IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: controller.expanded ? 'Collapse' : 'Expand',
                    icon: Icon(
                      controller.expanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                    ),
                    onPressed: controller.toggleExpanded,
                  ),
                ),
              ],
            ),
            GetBuilder<_AiInsightsPanelController>(id:"expanded",builder: (controller) => !controller.expanded ? const SizedBox.shrink() :  Column(children: [
              const SizedBox(height: 8),
              // Explanation
              if (explanation.trim().isNotEmpty)
                Text(
                  explanation,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    height: 1.35,
                  ),
                )
              else
                Text(
                  'No AI notes yet. Generate a plan to see analysis.',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              const SizedBox(height: 12),

              // Quick tweaks
              Wrap(
                children: [
                  _chip(
                    'Make easier',
                    'Make the overall workout easier. Reduce sets/reps and sub hard moves.',
                  ),
                  _chip(
                    'Make harder',
                    'Increase difficulty. Add progressive overload, more sets or harder variations.',
                  ),
                  _chip(
                    'Add more cardio',
                    'Add more cardio focus. Include HIIT or steady-state blocks.',
                  ),
                  _chip(
                    'Focus core',
                    'Shift the workout to emphasize core/abs.',
                  ),
                  _chip(
                    'Upper body bias',
                    'Bias the workout towards upper body.',
                  ),
                  _chip(
                    'Lower body bias',
                    'Bias the workout towards lower body.',
                  ),
                  _chip(
                    '20-min version',
                    'Shorten to a compact 20-minute routine.',
                  ),
                  _chip(
                    'Equipment-free',
                    'Replace exercises with bodyweight/no-equipment variants.',
                  ),
                  _chip('Low-impact', 'Make it low-impact and joint-friendly.'),
                ],
              ),
              const SizedBox(height: 8),

              // Custom tweak
              Row(
                children: [
                  Expanded(
                    child: GetBuilder<_AiInsightsPanelController>(id: "submitting",builder: (controller) => TextField(
                      enabled:!controller.loading,
                      controller: controller.textController,
                      decoration: const InputDecoration(
                        hintText:
                            'Custom tweak (e.g., “swap push-ups for dumbbell press”)',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (v) => controller.send(v, onTweak),
                    ),
                  )),
                  const SizedBox(width: 8),
                  GetBuilder<_AiInsightsPanelController>(id: "submitting",builder: (controller) => FilledButton.icon(
                    onPressed: controller.loading ? null : () => controller.send(controller.textController.text, onTweak),
                    icon:  controller.loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high),
                    label: const Text('Tweak'),
                  ),
              )],
              ),
            ],
        ))],
        ),
      ),
    );
  }
}

class _AiInsightsPanelController extends GetxController {
  bool expanded = true;
  bool loading = false;
  late TextEditingController textController;

  @override
  void onInit() {
    textController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  Future<void> send(String text, onSend) async {
    if (text.trim().isEmpty || loading) return;
    loading = true;
    update(["submitting"]);
    try {
      await onSend(text.trim());
      textController.clear();
    } finally {
      loading = false;
      update(["submitting"]);
    }
  }

  void toggleExpanded() {
    expanded = !expanded;
    update(["expanded"]);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
