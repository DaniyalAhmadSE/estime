abstract interface class PersistenceManagementProvider {
  double getMultiplier();
  Future<void> saveMultiplier(double penalty);

  double getPenalty();
  Future<void> savePenalty(double penalty);

  double getConfidence();
  Future<void> saveConfidence(double confidence);

  String getUnitOfTime();
  Future<void> saveUnitOfTime(String unitOfTime);
}
