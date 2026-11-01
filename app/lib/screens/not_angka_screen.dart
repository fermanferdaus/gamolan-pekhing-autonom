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
      backgroundColor: LampungTheme.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: LampungTheme.bgMedium,
                border: Border(
                  bottom: BorderSide(
                    color: LampungTheme.gold.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/siger.svg',
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      LampungTheme.gold.withValues(alpha: 0.7),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Gamolan Pekhing',
                    style: TextStyle(
                      color: LampungTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _service.isConnected
                          ? Colors.green.withValues(alpha: 0.15)
                          : LampungTheme.tapisRed.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _service.isConnected
                            ? Colors.green
                            : LampungTheme.tapisRed,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: _service.isConnected
                              ? Colors.green
                              : LampungTheme.tapisRed,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _service.isConnected ? 'Terhubung' : 'Terputus',
                          style: TextStyle(
                            color: _service.isConnected
                                ? Colors.green
                                : LampungTheme.tapisRed,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.fullscreen_exit,
                        color: LampungTheme.textSecondary),
                    tooltip: 'Kembali ke Potret',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.06,
                      child: SvgPicture.asset(
                        'assets/images/pucuk_rebung.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      color: LampungTheme.bgDark.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: LampungTheme.goldDark.withValues(alpha: 0.3),
                      ),
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
                              duration: const Duration(milliseconds: 90),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              transform: Matrix4.diagonal3Values(
                                  isHit ? 0.96 : 1.0,
                                  isHit ? 0.98 : 1.0,
                                  1.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: FractionallySizedBox(
                                  heightFactor: heightScale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: isHit
                                            ? [
                                                LampungTheme.goldLight,
                                                const Color(0xFFFFD700),
                                                const Color(0xFFFFA000),
                                              ]
                                            : [
                                                const Color(0xFFE2C465),
                                                LampungTheme.goldBronze,
                                                const Color(0xFF9E782F),
                                              ],
                                      ),
                                      boxShadow: [
                                        if (isHit)
                                          BoxShadow(
                                            color: const Color(0xFFFFD700)
                                                .withValues(alpha: 0.6),
                                            blurRadius: 18,
                                            spreadRadius: 3,
                                          )
                                        else
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 4),
                                          ),
                                      ],
                                      border: Border.all(
                                        color: isHit
                                            ? Colors.white
                                            : LampungTheme.goldDark,
                                        width: isHit ? 2.5 : 1.5,
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
                                              _buildNailHole(),
                                              _buildNailHole(),
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
                                                      ? Colors.black
                                                      : const Color(
                                                          0xFF221804),
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item['solfege'] as String,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: isHit
                                                      ? Colors.black87
                                                      : const Color(
                                                          0xFF3E2D07),
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
                                                item['freq'] as String,
                                                style: const TextStyle(
                                                  fontSize: 9,
                                                  color: Color(0xFF4A3810),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  _buildNailHole(),
                                                  _buildNailHole(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNailHole() {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: const Color(0xFF2B1F08),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF533F17), width: 1),
      ),
    );
  }
}
