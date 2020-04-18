import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    _flareController = AnimationControls();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _resetDay() {
    setState(() {
      currentWaterCount = 0;
      _flareController.resetWater();
    });
  }

  void _incrementWater() {
    setState(() {
      if (currentWaterCount < selectedGlasses) {
        currentWaterCount = currentWaterCount + 1;
        double diff = currentWaterCount / selectedGlasses;
        plusWaterControls.play("plus press");
        _flareController.playAnimation("ripple");
        _flareController.updateWaterPercent(diff);
      }

      if (currentWaterCount == selectedGlasses) {
        _flareController.playAnimation("iceboy_win");
      }
    });
  }

  void _decrementWater() {
    setState(() {
      if (currentWaterCount > 0) {
        currentWaterCount = currentWaterCount - 1;
        double diff = currentWaterCount / selectedGlasses;

        _flareController.updateWaterPercent(diff);

        _flareController.playAnimation("ripple");
      } else {
        currentWaterCount = 0;
      }
      minusWaterControls.play("minus press");
    });
  }

  void calculateMaxOunces() {
    maxWaterCount = selectedGlasses * ouncePerGlass;
  }

  void _incSelectedGlasses(StateSetter updateModal, int value) {
    updateModal(() {
      selectedGlasses = (selectedGlasses + value).clamp(0, 26).toInt();
      calculateMaxOunces();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(93, 93, 93, 1),
      body: Container(
        color: const Color.fromRGBO(93, 93, 93, 1),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FlareActor(
              "assets/WaterArtboards.flr",
              fit: BoxFit.contain,
              animation: "iceboy",
              artboard: "Artboard",
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                addWaterBtn(),
                subWaterBtn(),
                settingsButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showMenu() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter updateModal) {
            return Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(93, 93, 93, 1),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Text(
                    "Set Target",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      FlareWaterTrackButton(
                        artboard: "UI arrow right",
                        pressAnimation: "arrow right press",
                        onPressed: () => _incSelectedGlasses(updateModal, 1),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "/glasses",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 20.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FlareWaterTrackButton(
                    artboard: "UI refresh",
                    onPressed: () {
                      _resetDay();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget settingsButton() {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(Size(95, 30)),
      onPressed: _showMenu,
      shape: Border(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      elevation: 0.0,
      child: FlareActor(
        "assets/WaterArtboards.flr",
        fit: BoxFit.contain,
        sizeFromArtboard: true,
        artboard: "UI Ellipse",
      ),
    );
  }

  Widget addWaterBtn() {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(150, 150)),
      onPressed: _incrementWater,
      shape: Border(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      elevation: 0.0,
      child: FlareActor(
        "assets/WaterArtboards.flr",
        controller: plusWaterControls,
        fit: BoxFit.contain,
        animation: "plus press",
        sizeFromArtboard: false,
        artboard: "UI plus",
      ),
    );
  }

  Widget subWaterBtn() {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(150, 150)),
      onPressed: _decrementWater,
      shape: Border(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      elevation: 0.0,
      child: FlareActor(
        "assets/WaterArtboards.flr",
        controller: minusWaterControls,
        fit: BoxFit.contain,
        animation: "minus press",
        sizeFromArtboard: true,
        artboard: "UI minus",
      ),
    );
  }
}

class FlareWaterTrackButton extends StatefulWidget {
  final String pressAnimation;
  final String artboard;
  final VoidCallback onPressed;
  const FlareWaterTrackButton(
      {this.artboard, this.pressAnimation, this.onPressed});

  @override
  _FlareWaterTrackButtonState createState() => _FlareWaterTrackButtonState();
}

class _FlareWaterTrackButtonState extends State<FlareWaterTrackButton> {
  final _controller = FlareControls();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(95, 85)),
      onPressed: () {
        _controller.play(widget.pressAnimation);
        widget.onPressed?.call();
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: FlareActor(
        "assets/WaterArtboard.flr",
        controller: _controller,
        fit: BoxFit.contain,
        artboard: widget.artboard,
      ),
    );
  }
}
