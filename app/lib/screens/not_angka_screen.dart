import 'dart:async';
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
  Timer? _hitTimer;

  final List<Map<String, dynamic>> _bars = [
    {'num': 1, 'solfege': 'DO', 'scale': 0.98},
    {'num': 2, 'solfege': 'RE', 'scale': 0.94},
    {'num': 3, 'solfege': 'MI', 'scale': 0.90},
    {'num': 4, 'solfege': 'FA', 'scale': 0.86},
    {'num': 5, 'solfege': 'SOL', 'scale': 0.82},
    {'num': 6, 'solfege': 'LA', 'scale': 0.78},
    {'num': 7, 'solfege': 'SI', 'scale': 0.74},
    {'num': 8, 'solfege': "DO'", 'scale': 0.70},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _hitTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _hitBar(int num) {
    HapticFeedback.mediumImpact();
    setState(() {
      _pressedNada = num;
    });
    _service.hitNada(num);

    _hitTimer?.cancel();
    _hitTimer = Timer(const Duration(milliseconds: 160), () {
      if (mounted && _pressedNada == num) {
        setState(() {
          _pressedNada = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.7,
                  child: SvgPicture.asset(
                    'assets/images/lampung_bg_pattern.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                _buildTopBar(context),
                Expanded(child: _buildGamolanRancak(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final media = MediaQuery.paddingOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        media.left > 0 ? media.left + 8 : 16,
        media.top > 0 ? media.top + 4 : 8,
        media.right > 0 ? media.right + 8 : 16,
        8,
      ),
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
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: LampungTheme.darkBlue,
              borderRadius: BorderRadius.circular(8),
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
                '[ INSTRUMEN VIRTUAL 8 BILAH ]',
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
          if (_pressedNada > 0 && _pressedNada <= _bars.length)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: LampungTheme.accentBlueLight,
                  width: 1.5,
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
                'HIT: ${_bars[_pressedNada - 1]['num']} · ${_bars[_pressedNada - 1]['solfege']}',
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: LampungTheme.primaryBlue,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _service.isConnected
                    ? LampungTheme.statusSuccess
                    : LampungTheme.statusDanger,
                width: 1.2,
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
                    ? LampungTheme.statusSuccess
                    : LampungTheme.statusDanger,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.fullscreen_exit_rounded,
                color: Colors.white, size: 24),
            tooltip: 'Tutup Mode Bilah',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildGamolanRancak(BuildContext context) {
    final media = MediaQuery.paddingOf(context);
    return Container(
      margin: EdgeInsets.fromLTRB(
        media.left > 0 ? media.left + 8 : 14,
        8,
        media.right > 0 ? media.right + 8 : 14,
        media.bottom > 0 ? media.bottom + 6 : 10,
      ),
      decoration: BoxDecoration(
        color: LampungTheme.darkBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: LampungTheme.primaryBlue,
          width: 2.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: LampungTheme.deepBlue,
            offset: Offset(4, 5),
            blurRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 1. Rel Penyangga Tali Atas (Top Rail & Cushion Cord)
            Positioned(
              top: 26,
              left: 10,
              right: 10,
              height: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: LampungTheme.secondaryBlue,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: LampungTheme.accentBlueLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 2,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),

            // 2. Rel Penyangga Tali Bawah (Bottom Rail & Cushion Cord)
            Positioned(
              bottom: 26,
              left: 10,
              right: 10,
              height: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: LampungTheme.secondaryBlue,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: LampungTheme.accentBlueLight.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(
                  child: Container(
                    height: 2,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),

            // 3. Susunan 8 Bilah Bambu Gamolan Pekhing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _bars.map((item) {
                  final int num = item['num'] as int;
                  final bool isHit = _pressedNada == num;
                  final double scale = item['scale'] as double;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapDown: (_) => _hitBar(num),
                        child: Align(
                          alignment: Alignment.center,
                          child: FractionallySizedBox(
                            heightFactor: scale,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 70),
                              transform: Matrix4.translationValues(
                                0.0,
                                isHit ? 4.0 : 0.0,
                                0.0,
                              ),
                              decoration: BoxDecoration(
                                color: isHit
                                    ? LampungTheme.primaryBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isHit
                                      ? Colors.white
                                      : LampungTheme.accentBlueLight,
                                  width: isHit ? 2.5 : 1.5,
                                ),
                                boxShadow: isHit
                                    ? []
                                    : const [
                                        BoxShadow(
                                          color: LampungTheme.deepBlue,
                                          offset: Offset(2, 4),
                                          blurRadius: 0,
                                        ),
                                      ],
                              ),
                              child: _buildBilahContent(item, isHit),
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
    );
  }

  Widget _buildBilahContent(Map<String, dynamic> item, bool isHit) {
    final int num = item['num'] as int;
    final String solfege = item['solfege'] as String;

    return Column(
      children: [
        // Lubang Pasak Tali Atas
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: _buildMountingCordHoles(isHit),
        ),

        const Spacer(),

        // Piringan Titik Ketuk (Strike Bullseye Zone)
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHit ? Colors.white : LampungTheme.blue50,
            border: Border.all(
              color: isHit
                  ? LampungTheme.accentBlueLight
                  : LampungTheme.accentBlueLight.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isHit
                    ? LampungTheme.darkBlue
                    : const Color(0x1F1D4ED8),
                offset: const Offset(1, 1),
                blurRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$num',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: LampungTheme.primaryBlue,
              ),
            ),
          ),
        ),

        const SizedBox(height: 4),

        // Label Solfege (DO, RE, MI...)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isHit ? LampungTheme.darkBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            solfege,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: isHit ? Colors.white : LampungTheme.secondaryBlue,
            ),
          ),
        ),

        const Spacer(),

        // Garis Ruas Akustik Bambu
        Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: isHit
              ? Colors.white.withValues(alpha: 0.4)
              : LampungTheme.slate200,
        ),

        // Lubang Pasak Tali Bawah
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 8),
          child: _buildMountingCordHoles(isHit),
        ),
      ],
    );
  }

  Widget _buildMountingCordHoles(bool isHit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPinHole(isHit),
        Container(
          width: 14,
          height: 1.5,
          color: isHit
              ? Colors.white.withValues(alpha: 0.6)
              : LampungTheme.slate300,
        ),
        _buildPinHole(isHit),
      ],
    );
  }

  Widget _buildPinHole(bool isHit) {
    return Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHit ? Colors.white : LampungTheme.slate400,
        border: Border.all(
          color: isHit ? LampungTheme.darkBlue : LampungTheme.slate300,
          width: 1,
        ),
      ),
    );
  }
}
