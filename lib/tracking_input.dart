import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:waterapp/flare_controller.dart';

class TrackingInput extends StatefulWidget {
  @override
  _TrackingInputState createState() => _TrackingInputState();
}

class _TrackingInputState extends State<TrackingInput> {
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  AnimationControls _flareController;

  final FlareControls plusWaterControls = FlareControls();
  final FlareControls minusWaterControls = FlareControls();

  int currentWaterCount = 0;

  int maxWaterCount = 0;

  int selectedGlasses = 8;

  static const int ouncePerGlass = 8;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
