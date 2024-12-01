import 'package:estime/modules/estimator.dart';
import 'package:estime/widgets/input_page_builder.dart';
import 'package:flutter/material.dart';

class PeerConfidenceInputPage extends StatefulWidget {
  final Estimator estimator;
  final VoidCallback onNext;

  const PeerConfidenceInputPage({
    super.key,
    required this.estimator,
    required this.onNext,
  });

  @override
  State<PeerConfidenceInputPage> createState() =>
      _PeerConfidenceInputPageState();
}

class _PeerConfidenceInputPageState extends State<PeerConfidenceInputPage> {
  @override
  Widget build(BuildContext context) {
    return InputPageBuilder(
      title: 'Peer Confidence',
      onChanged: (value) {
        setState(() {
          widget.estimator.peerConfidence = double.tryParse(value) ?? 0;
        });
      },
      onNext: widget.estimator.peerConfidence > 0 ? widget.onNext : null,
      onSkip: () {
        setState(() {
          widget.estimator.peerConfidence = 0;
        });
        widget.onNext();
      },
    );
  }
}
