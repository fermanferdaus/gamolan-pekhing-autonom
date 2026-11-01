import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/song_model.dart';
import '../services/gamolan_service.dart';
import '../theme/lampung_theme.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen>
    with SingleTickerProviderStateMixin {
  final GamolanService _service = GamolanService();
  late TabController _tabController;

  final _categories = SongCategory.values;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _service.addListener(_onServiceUpdate);
    _tryAutoConnect();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _tryAutoConnect() async {
    final alreadyConnected = await _service.isWifiConnectedToGamolan();
    if (alreadyConnected) {
      _service.connectWebSocket();
    }
  }

  List<SongModel> _songsForCategory(SongCategory cat) {
    return _service.songs.where((s) => s.category == cat).toList();
  }

  void _showDeleteDialog(SongModel song) {
    if (song.id < 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lagu bawaan sistem tidak dapat dihapus!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: LampungTheme.bgCard,
        title: Text('Hapus "${song.name}"?',
            style: const TextStyle(color: LampungTheme.textPrimary)),
        content: const Text(
          'Lagu ini akan dihapus dari memori Gamolan.',
          style: TextStyle(color: LampungTheme.textSecondary),
        ),
        actions: [
          TextButton(
            child: const Text('Batal',
                style: TextStyle(color: LampungTheme.textMuted)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: LampungTheme.tapisRed),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              _service.deleteSong(song.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LampungTheme.bgDark,
      body: Column(
        children: [
          _buildHeader(),
          _buildConnectionStrip(),
          _buildCategoryTabs(),
          Expanded(child: _buildTabContent()),
          if (_service.isPlaying) _buildNowPlayingBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 16,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [LampungTheme.tapisDark, LampungTheme.bgDark],
        ),
        border: Border(
          bottom: BorderSide(
            color: LampungTheme.gold.withValues(alpha: 0.15),
          ),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/siger.svg',
            height: 26,
            colorFilter: ColorFilter.mode(
              LampungTheme.gold.withValues(alpha: 0.8),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GAMOLAN PEKHING',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: LampungTheme.gold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  'Musik Tradisional Lampung',
                  style: TextStyle(
                    fontSize: 10,
                    color: LampungTheme.textSecondary,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: LampungTheme.gold, size: 22),
            tooltip: 'Refresh Daftar Lagu',
            onPressed:
                _service.isConnected ? () => _service.fetchSongList() : null,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStrip() {
    final status = _service.status;
    final color = status == ConnectionStatus.connected
        ? const Color(0xFF4CAF50)
        : (status == ConnectionStatus.connecting
            ? const Color(0xFFFF9800)
            : const Color(0xFFE57373));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: LampungTheme.bgMedium,
        border: Border(
          bottom: BorderSide(
            color: LampungTheme.goldDark.withValues(alpha: 0.2),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              status == ConnectionStatus.connected
                  ? 'Terhubung ke Gamolan Pekhing'
                  : (status == ConnectionStatus.connecting
                      ? 'Menghubungkan ke Gamolan...'
                      : 'Belum terhubung ke alat'),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (status == ConnectionStatus.connected)
            GestureDetector(
              onTap: () => _service.disconnect(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: LampungTheme.tapisRed.withValues(alpha: 0.5),
                  ),
                ),
                child: const Text(
                  'Putus',
                  style: TextStyle(
                    color: LampungTheme.tapisRed,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else if (status == ConnectionStatus.disconnected)
            GestureDetector(
              onTap: () => _service.openWifiManager(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [LampungTheme.goldLight, LampungTheme.gold],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: LampungTheme.gold.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi, size: 12, color: LampungTheme.bgDark),
                    SizedBox(width: 4),
                    Text(
                      'Sambungkan',
                      style: TextStyle(
                        color: LampungTheme.bgDark,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: LampungTheme.bgMedium,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: LampungTheme.gold,
        indicatorWeight: 2.5,
        labelColor: LampungTheme.gold,
        unselectedLabelColor: LampungTheme.textMuted,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        tabs: _categories.map((c) {
          final count = _songsForCategory(c).length;
          return Tab(
            height: 38,
            child: Row(
              children: [
                Text(c.icon, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(c.label),
                if (count > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: LampungTheme.bgSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: LampungTheme.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: _categories.map((cat) {
        final songs = _songsForCategory(cat);
        if (songs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/pucuk_rebung.svg',
                  height: 48,
                  colorFilter: ColorFilter.mode(
                    LampungTheme.gold.withValues(alpha: 0.15),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada lagu kategori ${cat.label}',
                  style: const TextStyle(
                    color: LampungTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
          itemCount: songs.length,
          itemBuilder: (context, index) => _buildSongCard(songs[index]),
        );
      }).toList(),
    );
  }

  Widget _buildSongCard(SongModel song) {
    final isPlaying =
        _service.isPlaying && _service.playingSongId == song.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isPlaying ? LampungTheme.tapisDark : LampungTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPlaying
              ? LampungTheme.gold.withValues(alpha: 0.7)
              : LampungTheme.goldDark.withValues(alpha: 0.15),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: [
          if (isPlaying)
            BoxShadow(
              color: LampungTheme.gold.withValues(alpha: 0.15),
              blurRadius: 10,
              spreadRadius: 1,
            )
          else
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (isPlaying) {
              _service.stopPlayback();
            } else {
              _service.playSong(song.id);
            }
          },
          onLongPress: song.id >= 20 ? () => _showDeleteDialog(song) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isPlaying
                          ? [LampungTheme.goldLight, LampungTheme.gold]
                          : [LampungTheme.bgSurface, LampungTheme.bgMedium],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPlaying
                          ? LampungTheme.goldLight
                          : LampungTheme.goldDark.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.volume_up_rounded
                        : (song.category == SongCategory.lampung
                            ? Icons.stars_rounded
                            : Icons.music_note_rounded),
                    color: isPlaying
                        ? LampungTheme.bgDark
                        : (song.category == SongCategory.lampung
                            ? LampungTheme.gold
                            : LampungTheme.textSecondary),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.name,
                        style: TextStyle(
                          color: isPlaying
                              ? LampungTheme.goldLight
                              : LampungTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: LampungTheme.bgSurface,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${song.tempo} BPM',
                              style: const TextStyle(
                                color: LampungTheme.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${song.len} nada',
                            style: const TextStyle(
                              color: LampungTheme.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          if (song.category == SongCategory.lampung) ...[
                            const SizedBox(width: 6),
                            const Text(
                              '• Gamolan Asli',
                              style: TextStyle(
                                color: Color(0xFFC5A059),
                                fontSize: 10,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.stop_circle_rounded
                        : Icons.play_circle_fill_rounded,
                    color: isPlaying
                        ? LampungTheme.tapisRed
                        : LampungTheme.gold,
                    size: 36,
                  ),
                  onPressed: () {
                    if (isPlaying) {
                      _service.stopPlayback();
                    } else {
                      _service.playSong(song.id);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNowPlayingBar() {
    final progress = _service.totalNotes > 0
        ? (_service.currentNote / _service.totalNotes).clamp(0.0, 1.0)
        : 0.0;

    const solfeges = ['-', 'DO', 'RE', 'MI', 'FA', 'SOL', 'LA', 'SI', "DO'"];
    final nadaText =
        (_service.activeNada >= 0 && _service.activeNada < solfeges.length)
            ? solfeges[_service.activeNada]
            : '-';

    return Container(
      decoration: BoxDecoration(
        color: LampungTheme.bgMedium,
        border: Border(
          top: BorderSide(
            color: LampungTheme.gold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar at the VERY TOP of the bar - always visible, never blocked!
          LinearProgressIndicator(
            value: progress,
            backgroundColor: LampungTheme.bgSurface,
            valueColor: const AlwaysStoppedAnimation<Color>(LampungTheme.gold),
            minHeight: 3,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [LampungTheme.goldLight, LampungTheme.gold],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: LampungTheme.gold.withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      nadaText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: LampungTheme.bgDark,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _service.playingSongName.isNotEmpty
                            ? _service.playingSongName
                            : 'Memainkan Lagu...',
                        style: const TextStyle(
                          color: LampungTheme.goldLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Nada ${_service.currentNote + 1} dari ${_service.totalNotes}',
                        style: const TextStyle(
                          color: LampungTheme.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_rounded,
                      color: LampungTheme.tapisRed, size: 32),
                  onPressed: () => _service.stopPlayback(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
