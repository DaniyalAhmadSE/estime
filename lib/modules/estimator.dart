class Estimator {
  double multiplier;
  double estimate = 0;
  double penalty;
  double confidence;
  double peerConfidence = 0;

  Estimator({
    required this.multiplier,
    required this.penalty,
    required this.confidence,
  });

  double getEstimate() {
    return estimate * multiplier - confidence - peerConfidence + penalty;
  }
}
