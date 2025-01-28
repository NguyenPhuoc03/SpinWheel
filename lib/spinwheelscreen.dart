import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';

class SpinWheel extends StatefulWidget {
  const SpinWheel({Key? key}) : super(key: key);

  @override
  State<SpinWheel> createState() => _SpinWheelState();
}

class _SpinWheelState extends State<SpinWheel> {
  final selected = BehaviorSubject<int>();
  String rewards = "";
  int key = 0;
  bool isSpinning = false;

  List<String> items = ["Cả 3", "Lì xì 1", "Lì xì 2", "Lì xì 3"];
  final List<Color> colors = [Colors.blue, Colors.red];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              child: FortuneWheel(
                selected: selected.stream,
                animateFirst: false,
                items: [
                  for (int i = 0; i < items.length; i++) ...<FortuneItem>{
                    FortuneItem(
                      child: Text(items[i].toString()),
                      style: FortuneItemStyle(
                          color: colors[i % 2],
                          borderColor: Colors.white,
                          borderWidth: 2.0),
                    ),
                  },
                ],
                onAnimationStart: () {
                  setState(() {
                    isSpinning = true;
                  });
                },
                onAnimationEnd: () {
                  setState(() {
                    rewards = items[selected.value];
                    isSpinning = false;
                  });
                  print(rewards);
                  print(key);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Phần quà là " + rewards),
                    ),
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: isSpinning
                  ? null
                  : () {
                      setState(() {
                        if (key == 0) {
                          selected.add(0);
                        } else {
                          selected.add(Fortune.randomInt(0, items.length));
                        }
                        key++;
                      });
                    },
              onLongPress: () {
                setState(() {
                  selected.add(0);
                  key++;
                  print("Key");
                });
              },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.redAccent,
                child: Center(
                  child: Text("QUAY"),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: isSpinning
                  ? null
                  : () {
                      setState(() {
                        key = 0;
                      });
                      print(key);
                    },
              child: Container(
                height: 40,
                width: 120,
                color: Colors.blue,
                child: Center(
                  child: Text("Reset"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
