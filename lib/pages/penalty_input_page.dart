import 'package:estime/modules/estimator.dart';
import 'package:estime/widgets/input_page_builder.dart';
import 'package:flutter/material.dart';

class PenaltyInputPage extends StatefulWidget {
  final Estimator estimator;
  final VoidCallback onNext;

  const PenaltyInputPage({
    super.key,
    required this.estimator,
    required this.onNext,
  });

  @override
  State<PenaltyInputPage> createState() => _PenaltyInputPageState();
}

class _PenaltyInputPageState extends State<PenaltyInputPage> {
  @override
  Widget build(BuildContext context) {
    return InputPageBuilder(
      title: 'Penalty',
      onChanged: (value) {
        setState(() {
          widget.estimator.penalty = double.tryParse(value) ?? 0;
        });
      },
      onNext: widget.estimator.penalty > 0 ? widget.onNext : null,
      initialValue: widget.estimator.penalty,
      onSkip: () {
        setState(() {
          widget.estimator.penalty = 0;
        });
        widget.onNext();
      },
    );
  }
}
