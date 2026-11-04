import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../services/gamolan_service.dart';
import '../theme/lampung_theme.dart';

class NotAngkaScreen extends StatefulWidget {
  const NotAngkaScreen({super.key});

  @override
  State<NotAngkaScreen> createState() => _NotAngkaScreenState();
}

class _NotAngkaScreenState extends State<NotAngkaScreen> {
  final GamolanService _service = GamolanService();
  int _pressedNada = 0;

  final List<Map<String, dynamic>> _bars = [
    {'num': 1, 'solfege': 'DO', 'freq': '523 Hz'},
    {'num': 2, 'solfege': 'RE', 'freq': '587 Hz'},
    {'num': 3, 'solfege': 'MI', 'freq': '659 Hz'},
    {'num': 4, 'solfege': 'FA', 'freq': '698 Hz'},
    {'num': 5, 'solfege': 'SOL', 'freq': '783 Hz'},
    {'num': 6, 'solfege': 'LA', 'freq': '880 Hz'},
    {'num': 7, 'solfege': 'SI', 'freq': '987 Hz'},
    {'num': 8, 'solfege': "DO'", 'freq': '1046 Hz'},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _hitBar(int num) {
    HapticFeedback.lightImpact();
    setState(() {
      _pressedNada = num;
    });
    _service.hitNada(num);

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted && _pressedNada == num) {
        setState(() {
          _pressedNada = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LampungTheme.slate50,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: LampungTheme.primaryBlue,
                border: Border(
                  bottom: BorderSide(
                    color: LampungTheme.darkBlue,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: LampungTheme.darkBlue,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: LampungTheme.accentBlueLight.withValues(alpha: 0.3),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/gamolan_logo.svg',
                      height: 22,
                      width: 22,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '[ VIRTUAL GAMOLAN ]',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: LampungTheme.accentBlueLight,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'GAMOLAN PEKHING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: _service.isConnected
                            ? LampungTheme.accentBlueLight
                            : LampungTheme.statusDanger,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: LampungTheme.deepBlue,
                          offset: Offset(1, 1),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Text(
                      _service.isConnected ? '[ ONLINE ]' : '[ OFFLINE ]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: _service.isConnected
                            ? LampungTheme.primaryBlue
                            : LampungTheme.statusDanger,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.fullscreen_exit,
                        color: Colors.white),
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: LampungTheme.secondaryBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: LampungTheme.darkBlue,
                    width: 2.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: LampungTheme.deepBlue,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _bars.map((item) {
                    final int num = item['num'] as int;
                    final bool isHit = _pressedNada == num;
                    final double heightScale = 1.0 - (num - 1) * 0.035;

                    return Expanded(
                      child: GestureDetector(
                        onTapDown: (_) => _hitBar(num),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 60),
                          margin:
                              const EdgeInsets.symmetric(horizontal: 4),
                          transform: Matrix4.translationValues(
                            isHit ? 2.0 : 0.0,
                            isHit ? 3.0 : 0.0,
                            0.0,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: FractionallySizedBox(
                              heightFactor: heightScale,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: isHit
                                      ? LampungTheme.primaryBlue
                                      : Colors.white,
                                  boxShadow: isHit
                                      ? []
                                      : const [
                                          BoxShadow(
                                            color: LampungTheme.deepBlue,
                                            offset: Offset(3, 4),
                                            blurRadius: 0,
                                          ),
                                        ],
                                  border: Border.all(
                                    color: isHit
                                        ? Colors.white
                                        : LampungTheme.accentBlueHighlight,
                                    width: isHit ? 2.0 : 1.5,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          _buildNailHole(isHit),
                                          _buildNailHole(isHit),
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$num',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w900,
                                              color: isHit
                                                  ? Colors.white
                                                  : LampungTheme.primaryBlue,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['solfege'] as String,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: isHit
                                                  ? LampungTheme.accentBlueLight
                                                  : LampungTheme.secondaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Text(
                                            '[ ${item['freq']} ]',
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 9,
                                              color: isHit
                                                  ? Colors.white70
                                                  : LampungTheme.slate500,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              _buildNailHole(isHit),
                                              _buildNailHole(isHit),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNailHole(bool isHit) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHit ? LampungTheme.darkBlue : LampungTheme.accentBlueLight,
      ),
    );
  }
}
