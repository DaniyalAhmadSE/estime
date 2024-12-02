import 'dart:io';

import 'package:estime/modules/estimator.dart';
import 'package:estime/modules/persistence_manager.dart';
import 'package:estime/pages/home_page.dart';
import 'package:estime/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';

void main() {
  runApp(const Estime());
}

class Estime extends StatelessWidget {
  const Estime({super.key});
  Future<void> _setDesktopWindowSize() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
        await DesktopWindow.setWindowSize(const Size(414, 815));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    late PersistenceManager persistenceManager;

    return FutureBuilder(
      future: Future(() async {
        persistenceManager = PersistenceManager();
        await persistenceManager.loadPersistentDataWrapper();
        await _setDesktopWindowSize();
      }),
      builder: (context, AsyncSnapshot snapshot) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Estime',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          useMaterial3: true,
        ),
        home: (snapshot.connectionState == ConnectionState.done)
            ? HomePage(
                estimator: Estimator(
                  multiplier: persistenceManager.getMultiplier(),
                  penalty: persistenceManager.getPenalty(),
                  confidence: persistenceManager.getConfidence(),
                ),
                persistenceManager: persistenceManager,
              )
            : const SplashPage(),
      ),
    );
  }
}
