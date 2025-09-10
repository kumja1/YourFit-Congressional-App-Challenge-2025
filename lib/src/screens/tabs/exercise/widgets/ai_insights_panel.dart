import 'package:flutter/material.dart';

class AiInsightsPanel extends StatefulWidget {
  const AiInsightsPanel({
    super.key,
    required this.explanation,
    required this.onTweak,
    required this.loading,
  });

  final String explanation;
  final Future<void> Function(String instruction) onTweak;
  final bool loading;

  @override
  State<AiInsightsPanel> createState() => _AiInsightsPanelState();
}

class _AiInsightsPanelState extends State<AiInsightsPanel> {
  final _controller = TextEditingController();
  bool _expanded = true;
  bool _submitting = false;

  Future<void> _send(String text) async {
    if (text.trim().isEmpty || _submitting || widget.loading) return;
    setState(() => _submitting = true);
    try {
      await widget.onTweak(text.trim());
      _controller.clear();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _chip(String label, String instruction) {
    final disabled = widget.loading || _submitting;
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: disabled ? null : () => _send(instruction),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.loading || _submitting;
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
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: _expanded ? 'Collapse' : 'Expand',
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _expanded = !_expanded),
                ),
              ],
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              // Explanation
              if (widget.explanation.trim().isNotEmpty)
                Text(
                  widget.explanation,
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
                    child: TextField(
                      controller: _controller,
                      enabled: !disabled,
                      decoration: const InputDecoration(
                        hintText:
                            'Custom tweak (e.g., “swap push-ups for dumbbell press”)',
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (v) => _send(v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: disabled ? null : () => _send(_controller.text),
                    icon: (widget.loading || _submitting)
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high),
                    label: const Text('Tweak'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
