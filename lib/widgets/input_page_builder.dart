import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputPageBuilder extends StatelessWidget {
  final String _title;
  final ValueChanged<String> _onChanged;
  final VoidCallback? _onNext;
  final double? _initialValue;
  final VoidCallback? _onSkip;

  const InputPageBuilder({
    super.key,
    required String title,
    required void Function(String) onChanged,
    void Function()? onNext,
    double? initialValue,
    void Function()? onSkip,
  })  : _title = title,
        _onChanged = onChanged,
        _onNext = onNext,
        _initialValue = initialValue,
        _onSkip = onSkip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _title,
              textAlign: TextAlign.center,
              style: GoogleFonts.acme(
                textStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText:
                    'Enter $_title${_onSkip != null ? ' (Optional)' : '*'}',
              ),
              initialValue:
                  ((_initialValue ?? 0) > 0) ? _initialValue!.toString() : null,
              onChanged: _onChanged,
              onFieldSubmitted: (_) {
                _onNext?.call();
              },
            ),
            const SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_onSkip != null)
                  ElevatedButton(
                    onPressed: _onSkip,
                    child: const Text('Skip'),
                  ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _onNext,
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
