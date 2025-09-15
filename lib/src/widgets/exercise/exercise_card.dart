// lib/src/screens/tabs/exercise/widgets/exercise_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yourfit/src/models/exercise/exercise_data.dart';
import '../../models/exercise/exercise_models.dart';

class ExerciseCard extends StatefulWidget {
  final ExerciseData exercise;
  final ExecProgress progress;
  final bool isDone;
  final VoidCallback onStart;
  final VoidCallback onYoutube;

  // NEW: summary props/callbacks
  final String? summaryText;
  final bool summaryLoading;
  final String? summaryError;
  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.progress,
    required this.isDone,
    required this.onStart,
    required this.onYoutube,
    this.summaryText,
    this.summaryLoading = false,
    this.summaryError,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        onExpansionChanged: (v) async {
          setState(() => _expanded = v);
        },
        title: Text(ex.name),
        subtitle: Text(
          '${ex.sets} x ${ex.reps}  •  ${widget.progress.done}/${widget.progress.total} sets',
        ),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon: const Icon(Icons.ondemand_video),
              tooltip: 'YouTube tutorial',
              onPressed: widget.onYoutube,
            ),
            FilledButton(
              onPressed: widget.onStart,
              child: Text(widget.isDone ? 'Done' : 'Start'),
            ),
          ],
        ),
        children: [
          if (_expanded)
            _SummaryArea(
              loading: widget.summaryLoading,
              text: widget.summaryText,
              error: widget.summaryError,
            ),
        ],
      ),
    );
  }
}

class _SummaryArea extends StatelessWidget {
  final bool loading;
  final String? text;
  final String? error;

  const _SummaryArea({
    required this.loading,
    required this.text,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (loading) {
      body = const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Generating how-to…'),
          ],
        ),
      );
    } else if (error != null && error!.isNotEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error: $error'),
      );
    } else if (text != null && text!.isNotEmpty) {
      body = Padding(
        padding: const EdgeInsets.all(16),
        child: SelectableText(text!),
      );
    } else {
      body = const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Expand to generate a short AI guide for this exercise.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        body,
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.refresh),
                label: const Text('Regenerate'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: (text == null || text!.isEmpty)
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: text!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Summary copied')),
                        );
                      },
                icon: const Icon(Icons.copy),
                label: const Text('Copy'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
