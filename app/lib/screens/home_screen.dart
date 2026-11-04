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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: LampungTheme.primaryBlue,
          border: Border(
            top: BorderSide(
              color: LampungTheme.darkBlue,
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: LampungTheme.deepBlue,
              offset: Offset(0, -2),
              blurRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    index: 0,
                    icon: Icons.queue_music_rounded,
                    label: 'Daftar Lagu',
                  ),
                ),
                GestureDetector(
                  onTap: _openNotAngka,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
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
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.piano_rounded,
                          color: LampungTheme.primaryBlue,
                          size: 16,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'BILAH',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: LampungTheme.primaryBlue,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    index: 1,
                    icon: Icons.tune_rounded,
                    label: 'Komposer',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : LampungTheme.accentBlueLight.withValues(alpha: 0.7),
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : LampungTheme.accentBlueLight.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
