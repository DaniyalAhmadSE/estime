import 'package:estime/modules/estimator.dart';
import 'package:estime/widgets/input_page_builder.dart';
import 'package:flutter/material.dart';

class ConfidenceInputPage extends StatefulWidget {
  final Estimator estimator;
  final VoidCallback onNext;

  const ConfidenceInputPage({
    super.key,
    required this.estimator,
    required this.onNext,
  });

  @override
  State<ConfidenceInputPage> createState() => _ConfidenceInputPageState();
}

class _ConfidenceInputPageState extends State<ConfidenceInputPage> {
  @override
  Widget build(BuildContext context) {
    return InputPageBuilder(
      title: 'Confidence',
      onChanged: (value) {
        setState(() {
          widget.estimator.confidence = double.tryParse(value) ?? 0;
        });
      },
      onNext: widget.estimator.confidence > 0 ? widget.onNext : null,
      initialValue: widget.estimator.confidence,
      onSkip: () {
        setState(() {
          widget.estimator.confidence = 0;
        });
        widget.onNext();
      },
    );
  }
}
