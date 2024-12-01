import 'package:estime/modules/estimator.dart';
import 'package:estime/widgets/input_page_builder.dart';
import 'package:flutter/material.dart';

class EstimateInputPage extends StatefulWidget {
  final Estimator _estimator;
  final VoidCallback _onNext;

  const EstimateInputPage({
    super.key,
    required Estimator estimator,
    required void Function() onNext,
  })  : _estimator = estimator,
        _onNext = onNext;

  @override
  State<EstimateInputPage> createState() => _EstimateInputPageState();
}

class _EstimateInputPageState extends State<EstimateInputPage> {
  @override
  Widget build(BuildContext context) {
    return InputPageBuilder(
      title: 'Estimate',
      onChanged: (value) {
        setState(() {
          widget._estimator.estimate = double.tryParse(value) ?? 0;
        });
      },
      onNext: widget._estimator.estimate > 0 ? widget._onNext : null,
    );
  }
}
