import 'package:estime/models/persistent_data_wrapper.dart';
import 'package:estime/modules/interfaces/persistence_management_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceManager implements PersistenceManagementProvider {
  late PersistentDataWrapper persistentDataWrapper;

  Future<SharedPreferences> _getPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> loadPersistentDataWrapper() async {
    final prefs = await _getPreferences();

    persistentDataWrapper = PersistentDataWrapper(
      multiplier: prefs.getDouble('multiplier') ?? 3,
      unitOfTime: prefs.getString('unit_of_time') ?? 'seconds',
      penalty: prefs.getDouble('penalty') ?? 0,
      confidence: prefs.getDouble('confidence') ?? 0,
    );
  }

  @override
  double getMultiplier() => persistentDataWrapper.multiplier;

  @override
  Future<void> saveMultiplier(double multiplier) async {
    final prefs = await _getPreferences();
    persistentDataWrapper.multiplier = multiplier;
    await prefs.setDouble('multiplier', multiplier);
  }

  @override
  double getPenalty() => persistentDataWrapper.penalty;

  @override
  Future<void> savePenalty(double penalty) async {
    final prefs = await _getPreferences();
    persistentDataWrapper.penalty = penalty;
    await prefs.setDouble('penalty', penalty);
  }

  @override
  double getConfidence() => persistentDataWrapper.confidence;

  @override
  Future<void> saveConfidence(double confidence) async {
    final prefs = await _getPreferences();
    persistentDataWrapper.confidence = confidence;
    await prefs.setDouble('confidence', confidence);
  }

  @override
  String getUnitOfTime() => persistentDataWrapper.unitOfTime;

  @override
  Future<void> saveUnitOfTime(String unitOfTime) async {
    final prefs = await _getPreferences();
    persistentDataWrapper.unitOfTime = unitOfTime;
    prefs.setString('unit_of_time', unitOfTime);
  }
}
