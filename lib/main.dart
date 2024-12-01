import 'package:estime/modules/estimator.dart';
import 'package:estime/modules/persistence_manager.dart';
import 'package:estime/pages/home_page.dart';
import 'package:estime/pages/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Estime());
}

class Estime extends StatelessWidget {
  const Estime({super.key});

  @override
  Widget build(BuildContext context) {
    late PersistenceManager persistenceManager;

    return FutureBuilder(
      future: Future(() async {
        persistenceManager = PersistenceManager();
        await persistenceManager.loadPersistentDataWrapper();
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
