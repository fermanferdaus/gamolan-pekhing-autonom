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
    _service.connectWebSocket();
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

  List<SongModel> _songsForCategory(SongCategory cat) {
    return _service.songs.where((s) => s.category == cat).toList();
  }

  void _showWifiConnectModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: LampungTheme.bgMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        bool isConnecting = false;
        String? errorMessage;

        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: LampungTheme.bgBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/siger_crown.svg',
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sambungkan ke Gamolan',
                        style: TextStyle(
                          color: LampungTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: LampungTheme.bgCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: LampungTheme.bgBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Petunjuk Koneksi:',
                          style: TextStyle(
                            color: LampungTheme.gold,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '1. Buka Pengaturan WiFi di HP Anda.\n'
                          '2. Pilih dan sambungkan ke WiFi "GamolanPekhing" (tanpa password).\n'
                          '3. Setelah tersambung, ketuk tombol "Hubungkan Sekarang".',
                          style: TextStyle(
                            color: LampungTheme.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: LampungTheme.tapisDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: LampungTheme.tapisRed.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: LampungTheme.tapisRed, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.settings, size: 16),
                          label: const Text('Buka WiFi HP'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: LampungTheme.textSecondary,
                            side: const BorderSide(color: LampungTheme.bgBorder),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _service.openWifiManager(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: isConnecting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        LampungTheme.bgDark),
                                  ),
                                )
                              : const Icon(Icons.link, size: 18),
                          label: Text(
                              isConnecting ? 'Mencoba...' : 'Hubungkan Sekarang'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LampungTheme.gold,
                            foregroundColor: LampungTheme.bgDark,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          onPressed: isConnecting
                              ? null
                              : () async {
                                  setModalState(() {
                                    isConnecting = true;
                                    errorMessage = null;
                                  });
                                  final ok = await _service.connectWithResult();
                                  if (!mounted) return;
                                  if (ok) {
                                    if (ctx.mounted) Navigator.pop(ctx);
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        backgroundColor: Color(0xFF1B4D24),
                                        content: Text(
                                            'Berhasil terhubung ke Gamolan Pekhing!'),
                                      ),
                                    );
                                  } else {
                                    setModalState(() {
                                      isConnecting = false;
                                      errorMessage =
                                          'Gagal terhubung. Pastikan HP sudah terhubung ke WiFi "GamolanPekhing".';
                                    });
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 8,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: LampungTheme.bgMedium,
        border: const Border(
          bottom: BorderSide(
            color: LampungTheme.bgBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: LampungTheme.bgSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LampungTheme.gold.withValues(alpha: 0.3),
              ),
            ),
            child: SvgPicture.asset(
              'assets/images/siger_crown.svg',
              height: 24,
            ),
          ),
          const SizedBox(width: 12),
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
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Musik Tradisional Lampung',
                  style: TextStyle(
                    fontSize: 11,
                    color: LampungTheme.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: LampungTheme.gold, size: 22),
            tooltip: 'Refresh Daftar Lagu',
            onPressed: () {
              if (_service.isConnected) {
                _service.fetchSongList();
              } else {
                _service.connectWebSocket();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStrip() {
    final status = _service.status;
    final isConnected = status == ConnectionStatus.connected;
    final isConnecting = status == ConnectionStatus.connecting;

    final color = isConnected
        ? const Color(0xFF4CAF50)
        : (isConnecting
            ? const Color(0xFFFFB300)
            : const Color(0xFFEF5350));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: const BoxDecoration(
        color: LampungTheme.bgMedium,
        border: Border(
          bottom: BorderSide(color: LampungTheme.bgBorder, width: 0.6),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isConnected
                  ? 'Terhubung ke Gamolan Pekhing'
                  : (isConnecting
                      ? 'Menghubungkan ke Gamolan...'
                      : 'Belum terhubung ke alat'),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isConnected)
            GestureDetector(
              onTap: () => _service.disconnect(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: LampungTheme.tapisRed.withValues(alpha: 0.6)),
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
          else
            GestureDetector(
              onTap: _showWifiConnectModal,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [LampungTheme.goldLight, LampungTheme.gold],
                  ),
                  borderRadius: BorderRadius.circular(8),
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
    IconData getIcon(SongCategory cat) {
      switch (cat) {
        case SongCategory.nasional:
          return Icons.flag_rounded;
        case SongCategory.daerah:
          return Icons.landscape_rounded;
        case SongCategory.lampung:
          return Icons.auto_awesome_rounded;
        case SongCategory.lainnya:
          return Icons.queue_music_rounded;
      }
    }

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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: _categories.map((c) {
          final count = _songsForCategory(c).length;
          return Tab(
            height: 40,
            child: Row(
              children: [
                Icon(getIcon(c), size: 14),
                const SizedBox(width: 6),
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
                  'assets/images/gamolan_instrument.svg',
                  height: 90,
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
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
          itemCount: songs.length,
          itemBuilder: (context, index) =>
              _buildSongCard(songs[index], index + 1),
        );
      }).toList(),
    );
  }

  Widget _buildSongCard(SongModel song, int indexNumber) {
    final isPlaying =
        _service.isPlaying && _service.playingSongId == song.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isPlaying ? LampungTheme.tapisDark : LampungTheme.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isPlaying
              ? LampungTheme.gold
              : LampungTheme.bgBorder,
          width: isPlaying ? 1.6 : 1.0,
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
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            if (isPlaying) {
              _service.stopPlayback();
            } else {
              _service.playSong(song.id);
            }
          },
          onLongPress: song.id >= 20 ? () => _showDeleteDialog(song) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isPlaying
                        ? LampungTheme.gold
                        : LampungTheme.bgSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPlaying
                          ? LampungTheme.goldLight
                          : LampungTheme.bgBorder,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$indexNumber',
                      style: TextStyle(
                        color: isPlaying
                            ? LampungTheme.bgDark
                            : LampungTheme.textGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
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
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: LampungTheme.bgSurface,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: LampungTheme.bgBorder,
                                width: 0.6,
                              ),
                            ),
                            child: Text(
                              '${song.tempo} BPM',
                              style: const TextStyle(
                                color: LampungTheme.gold,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
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
                                color: LampungTheme.goldBronze,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
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
                    size: 38,
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
        border: const Border(
          top: BorderSide(
            color: LampungTheme.gold,
            width: 1,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 8,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: LampungTheme.bgSurface,
            valueColor: const AlwaysStoppedAnimation<Color>(LampungTheme.gold),
            minHeight: 3.5,
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
