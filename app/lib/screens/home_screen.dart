import 'package:flutter/material.dart';
import 'playlist_screen.dart';
import 'composer_screen.dart';
import 'not_angka_screen.dart';
import '../theme/lampung_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PlaylistScreen(),
    const ComposerScreen(),
  ];

  void _openNotAngka() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NotAngkaScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: LampungTheme.slate200,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F1D4ED8),
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPillNav(
                  index: 0,
                  icon: Icons.queue_music_rounded,
                  label: 'Daftar Lagu',
                ),
              ),
              const SizedBox(width: 4),
              _buildCenterBilahAction(),
              const SizedBox(width: 4),
              Expanded(
                child: _buildPillNav(
                  index: 1,
                  icon: Icons.tune_rounded,
                  label: 'Komposer',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillNav({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => setState(() => _currentIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? LampungTheme.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: LampungTheme.deepBlue,
                      offset: Offset(1, 2),
                      blurRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: isSelected ? Colors.white : LampungTheme.slate400,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: isSelected ? Colors.white : LampungTheme.slate600,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterBilahAction() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: _openNotAngka,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: LampungTheme.darkBlue,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: LampungTheme.accentBlueLight.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: LampungTheme.deepBlue,
                offset: Offset(1, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.piano_rounded,
                size: 17,
                color: Colors.white,
              ),
              SizedBox(width: 5),
              Text(
                'BILAH',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
