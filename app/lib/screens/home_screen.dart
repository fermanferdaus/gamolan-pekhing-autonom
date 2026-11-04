import 'package:flutter/material.dart';
import 'playlist_screen.dart';
import 'composer_screen.dart';
import 'not_angka_screen.dart';
import '../theme/lampung_theme.dart';

class LoweredCenterDockedFabLocation extends FloatingActionButtonLocation {
  final double offsetY;
  const LoweredCenterDockedFabLocation({this.offsetY = 16.0});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset standard =
        FloatingActionButtonLocation.centerDocked.getOffset(scaffoldGeometry);
    return Offset(standard.dx, standard.dy + offsetY);
  }
}

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
      floatingActionButton: SizedBox(
        width: 58,
        height: 58,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: LampungTheme.primaryBlue,
            border: Border.all(
              color: Colors.white,
              width: 2.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: LampungTheme.deepBlue,
                offset: Offset(2, 3),
                blurRadius: 0,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _openNotAngka,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  Text(
                    'NOT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation:
          const LoweredCenterDockedFabLocation(offsetY: 18.0),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: LampungTheme.slate200,
              width: 1,
            ),
          ),
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 0,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.queue_music_rounded,
                  label: 'Daftar Lagu',
                ),
                const SizedBox(width: 56),
                _buildNavItem(
                  index: 1,
                  icon: Icons.music_note_outlined,
                  label: 'Buat Lagu',
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
      borderRadius: BorderRadius.circular(999),
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? LampungTheme.primaryBlue
                  : LampungTheme.slate400,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? LampungTheme.primaryBlue
                    : LampungTheme.slate500,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
