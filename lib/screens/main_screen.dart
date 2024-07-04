import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/icon_header_screen.dart';
import '../screens/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int radB = 0;
  Color currentColor = mainColor;
  int _counter = 0;
  int _goal = 0;
  int _repeat = 0;
  int _total = 0;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('Counter') ?? 0;
      _goal = prefs.getInt('Goal') ?? 0;
      _repeat = prefs.getInt('Repeat') ?? 0;
      _total = prefs.getInt('Total') ?? 0;
      radB = prefs.getInt('ColorIndex') ?? 0;
      currentColor = _getColorFromIndex(radB);
    });
  }

  Future<void> _setData(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  Future<void> _setColor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('ColorIndex', index);
  }

  Color _getColorFromIndex(int index) {
    switch (index) {
      case 0:
        return mainColor;
      case 1:
        return secondMainColor;
      case 2:
        return thredMainColor;
      default:
        return mainColor;
    }
  }

  void _resetData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      _counter = 0;
      _goal = 0;
      _repeat = 0;
      _total = 0;
      radB = 0;
      currentColor = mainColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: currentColor,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _resetData,
            backgroundColor: currentColor,
            child: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            backgroundColor: currentColor,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isActive = !isActive;
                  });
                },
                icon: const Icon(
                  Icons.color_lens_sharp,
                  color: mainIconPar,
                ),
              ),
            ],
            elevation: 0,
          ),
          body: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: currentColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Center(
                      child: Text(
                        'الهدف',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_goal > 0) _goal--;
                              _setData('Goal', _goal);
                            });
                          },
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$_goal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _goal++;
                              _setData('Goal', _goal);
                            });
                          },
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconHeaderScreen(
                          numText: '0',
                          onTap: () {
                            setState(() {
                              _goal = 0;
                              _setData('Goal', _goal);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconHeaderScreen(
                          numText: '33',
                          onTap: () {
                            setState(() {
                              _goal = 33;
                              _setData('Goal', _goal);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconHeaderScreen(
                          numText: '100',
                          onTap: () {
                            setState(() {
                              _goal = 100;
                              _setData('Goal', _goal);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconHeaderScreen(
                          numText: '+100',
                          onTap: () {
                            setState(() {
                              _goal += 100;
                              _setData('Goal', _goal);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        IconHeaderScreen(
                          numText: '+1000',
                          onTap: () {
                            setState(() {
                              _goal += 1000;
                              _setData('Goal', _goal);
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  Text(
                    'الإستـغفــار',
                    style: TextStyle(
                      color: currentColor,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      color: currentColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 5.0,
                    percent: (_goal > 0) ? _counter / _goal : 0,
                    center: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_counter == _goal) {
                            _repeat++;
                            _total += _counter;
                            _counter = 0;
                            _setData('Repeat', _repeat);
                            _setData('Total', _total);
                          } else {
                            _counter++;
                            _setData('Counter', _counter);
                          }
                        });
                      },
                      child: Icon(
                        Icons.touch_app,
                        size: 70.0,
                        color: currentColor,
                      ),
                    ),
                    backgroundColor: currentColor.withOpacity(0.2),
                    progressColor: currentColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'مجموع التكرار : $_repeat',
                    style: TextStyle(
                      color: currentColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'المجموع : $_total',
                    style: TextStyle(
                      color: currentColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (isActive)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                      activeColor: currentColor,
                      fillColor:
                          MaterialStateColor.resolveWith((states) => mainColor),
                      value: 0,
                      groupValue: radB,
                      onChanged: (val) {
                        setState(() {
                          radB = val!;
                          currentColor = mainColor;
                          _setColor(radB);
                        });
                      },
                    ),
                    Radio(
                      activeColor: secondMainColor,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => secondMainColor),
                      value: 1,
                      groupValue: radB,
                      onChanged: (val) {
                        setState(() {
                          radB = val!;
                          currentColor = secondMainColor;
                          _setColor(radB);
                        });
                      },
                    ),
                    Radio(
                      activeColor: thredMainColor,
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => thredMainColor),
                      value: 2,
                      groupValue: radB,
                      onChanged: (val) {
                        setState(() {
                          radB = val!;
                          currentColor = thredMainColor;
                          _setColor(radB);
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
