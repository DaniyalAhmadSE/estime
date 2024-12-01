import 'package:estime/modules/interfaces/persistence_management_provider.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final PersistenceManagementProvider _persistenceManager;
  final VoidCallback _onSave;

  const SettingsPage(
      {super.key,
      required PersistenceManagementProvider persistenceManager,
      required void Function() onSave})
      : _onSave = onSave,
        _persistenceManager = persistenceManager;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _multiplierController = TextEditingController();
  String _unitOfTime = 'seconds';
  final List<String> _unitOptions = ['seconds', 'minutes', 'hours'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final obtainedUnitOfTime = widget._persistenceManager.getUnitOfTime();

    final multiplierText =
        (widget._persistenceManager.getMultiplier()).toString();

    setState(() {
      _multiplierController.text = multiplierText;
      _unitOfTime = obtainedUnitOfTime;
    });
  }

  Future<void> _saveSettings() async {
    final value = _multiplierController.text;
    final multiplierValue = (double.tryParse(value) ?? 1) > 1 ? value : "1";

    setState(() {
      _multiplierController.text = multiplierValue;
    });

    await widget._persistenceManager.saveMultiplier(
      double.tryParse(multiplierValue) ?? 1,
    );
    await widget._persistenceManager.saveUnitOfTime(
      _unitOfTime,
    );

    widget._onSave();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _multiplierController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Multiplier'),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _unitOfTime,
              items: _unitOptions.map((unit) {
                return DropdownMenuItem(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _unitOfTime = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Unit of Time'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: (double.tryParse(_multiplierController.text) ?? 0) < 1
                  ? null
                  : () {
                      _saveSettings();
                      Navigator.pop(context);
                    },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
