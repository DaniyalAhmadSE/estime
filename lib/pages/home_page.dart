import 'package:estime/modules/estimator.dart';
import 'package:estime/modules/interfaces/persistence_management_provider.dart';
import 'package:estime/pages/confidence_input_page.dart';
import 'package:estime/pages/estimate_input_page.dart';
import 'package:estime/pages/peer_confidence_input_page.dart';
import 'package:estime/pages/penalty_input_page.dart';
import 'package:estime/pages/countdown_page.dart';
import 'package:estime/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Estimator _estimator;
  final PersistenceManagementProvider _persistenceManager;
  final PageController _pageController = PageController();

  HomePage({
    super.key,
    required Estimator estimator,
    required PersistenceManagementProvider persistenceManager,
  })  : _persistenceManager = persistenceManager,
        _estimator = estimator;

  @override
  State<HomePage> createState() => _HomePageState();

  void _updateEstimator() {
    _estimator.multiplier = _persistenceManager.getMultiplier();
  }

  void _resetEstimator() {
    _updateEstimator();
    _estimator.penalty = _persistenceManager.getPenalty();
    _estimator.confidence = _persistenceManager.getConfidence();
    _estimator.estimate = 0;
    _estimator.peerConfidence = 0;
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _HomePageState extends State<HomePage> {
  bool _isAtLastPage = false;

  void _startOver() {
    setState(() {
      widget._resetEstimator();
      _isAtLastPage = false;
    });
    widget._pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!_isAtLastPage)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      persistenceManager: widget._persistenceManager,
                      onSave: widget._updateEstimator,
                    ),
                  ),
                );
                setState(() {});
              },
            ),
        ],
      ),
      body: PageView(
        controller: widget._pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EstimateInputPage(
            estimator: widget._estimator,
            onNext: widget._goToNextPage,
          ),
          PenaltyInputPage(
            estimator: widget._estimator,
            onNext: widget._goToNextPage,
          ),
          ConfidenceInputPage(
            estimator: widget._estimator,
            onNext: widget._goToNextPage,
          ),
          PeerConfidenceInputPage(
            estimator: widget._estimator,
            onNext: () {
              widget._goToNextPage();
              setState(() {
                _isAtLastPage = true;
              });
            },
          ),
          CountdownPage(
            getResult: widget._estimator.getEstimate,
            getUnit: widget._persistenceManager.getUnitOfTime,
            resetData: _startOver,
            saveConfidence: widget._persistenceManager.saveConfidence,
            savePenalty: widget._persistenceManager.savePenalty,
          ),
        ],
      ),
    );
  }
}
