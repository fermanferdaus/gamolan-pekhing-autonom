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
      backgroundColor: Colors.white,
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
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: LampungTheme.slate300,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: LampungTheme.slate100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: LampungTheme.slate200),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/siger_crown.svg',
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sambungkan ke Gamolan',
                        style: TextStyle(
                          color: LampungTheme.slate900,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: LampungTheme.slate50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: LampungTheme.slate200),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F1D4ED8),
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '[ PETUNJUK KONEKSI ]',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: LampungTheme.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. Buka Pengaturan WiFi di HP Anda.\n'
                          '2. Pilih dan sambungkan ke WiFi "GamolanPekhing" (tanpa password).\n'
                          '3. Setelah tersambung, ketuk tombol "Hubungkan Sekarang".',
                          style: TextStyle(
                            color: LampungTheme.slate600,
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: LampungTheme.statusDanger),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline,
                              color: LampungTheme.statusDanger, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(
                                color: LampungTheme.statusDanger,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
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
                            foregroundColor: LampungTheme.slate700,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: LampungTheme.slate300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          onPressed: () => _service.openWifiManager(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: LampungTheme.deepBlue,
                                offset: Offset(2, 3),
                                blurRadius: 0,
                              ),
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(999)),
                          ),
                          child: ElevatedButton.icon(
                            icon: isConnecting
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.link, size: 18),
                            label: Text(
                                isConnecting ? 'Mencoba...' : 'Hubungkan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: LampungTheme.primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
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
                                          backgroundColor: LampungTheme.statusSuccess,
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LampungTheme.slate200),
        ),
        title: Text('Hapus "${song.name}"?',
            style: const TextStyle(
                color: LampungTheme.slate900, fontWeight: FontWeight.bold)),
        content: const Text(
          'Lagu ini akan dihapus dari memori Gamolan.',
          style: TextStyle(color: LampungTheme.slate600),
        ),
        actions: [
          TextButton(
            child: const Text('Batal',
                style: TextStyle(color: LampungTheme.slate500)),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: LampungTheme.statusDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('Hapus'),
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
      backgroundColor: LampungTheme.slate50,
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
        bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: LampungTheme.slate950,
        border: Border(
          bottom: BorderSide(
            color: LampungTheme.slate800,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: LampungTheme.slate900,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LampungTheme.slate800,
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
                  '[ SISTEM AUTONOMOUS ]',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                    color: LampungTheme.primaryBlue,
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'GAMOLAN PEKHING',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: LampungTheme.accentBlueHighlight, size: 22),
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

    final statusText = isConnected
        ? '[ ONLINE ] Terhubung ke Gamolan'
        : (isConnecting
            ? '[ CONNECTING ] Mencoba koneksi...'
            : '[ OFFLINE ] Belum terhubung');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: const BoxDecoration(
        color: LampungTheme.secondaryBlue,
        border: Border(
          bottom: BorderSide(color: LampungTheme.darkBlue, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConnected
                  ? const Color(0xFF86EFAC)
                  : (isConnecting ? const Color(0xFFFDE047) : const Color(0xFFFCA5A5)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              statusText,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
          if (isConnected)
            GestureDetector(
              onTap: () => _service.disconnect(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: LampungTheme.deepBlue,
                      offset: Offset(1, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'Putus',
                  style: TextStyle(
                    color: LampungTheme.statusDanger,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          else
            GestureDetector(
              onTap: _showWifiConnectModal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
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
                    Icon(Icons.wifi, size: 12, color: LampungTheme.secondaryBlue),
                    SizedBox(width: 4),
                    Text(
                      'Sambungkan',
                      style: TextStyle(
                        color: LampungTheme.secondaryBlue,
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
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: LampungTheme.slate200, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: LampungTheme.primaryBlue,
        indicatorWeight: 3,
        labelColor: LampungTheme.primaryBlue,
        unselectedLabelColor: LampungTheme.slate500,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: _categories.map((c) {
          final count = _songsForCategory(c).length;
          return Tab(
            height: 42,
            child: Row(
              children: [
                Icon(getIcon(c), size: 14),
                const SizedBox(width: 6),
                Text(c.label),
                if (count > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    '[$count]',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
                  height: 80,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada lagu kategori ${cat.label}',
                  style: const TextStyle(
                    color: LampungTheme.slate500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
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
        color: isPlaying ? LampungTheme.blue50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPlaying ? LampungTheme.primaryBlue : LampungTheme.slate200,
          width: isPlaying ? 1.8 : 1.0,
        ),
        boxShadow: isPlaying
            ? LampungTheme.hardShadowCardHover
            : LampungTheme.hardShadowCard,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
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
                        ? LampungTheme.primaryBlue
                        : LampungTheme.slate100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPlaying
                          ? LampungTheme.darkBlue
                          : LampungTheme.slate200,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      indexNumber.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isPlaying
                            ? Colors.white
                            : LampungTheme.slate700,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
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
                              ? LampungTheme.primaryBlue
                              : LampungTheme.slate900,
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '[ ${song.tempo} BPM ]',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: LampungTheme.primaryBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '[ ${song.len} NADA ]',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: LampungTheme.slate500,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (song.category == SongCategory.lampung) ...[
                            const SizedBox(width: 6),
                            const Text(
                              '[ ASLI ]',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                color: LampungTheme.secondaryBlue,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlaying
                          ? LampungTheme.statusDanger
                          : LampungTheme.primaryBlue,
                      boxShadow: const [
                        BoxShadow(
                          color: LampungTheme.deepBlue,
                          offset: Offset(2, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
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
      decoration: const BoxDecoration(
        color: LampungTheme.slate950,
        border: Border(
          top: BorderSide(
            color: LampungTheme.primaryBlue,
            width: 2,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: LampungTheme.slate800,
            valueColor: const AlwaysStoppedAnimation<Color>(LampungTheme.primaryBlue),
            minHeight: 3.5,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: LampungTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: LampungTheme.accentBlueHighlight,
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
                  child: Center(
                    child: Text(
                      nadaText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '[ NADA ${_service.currentNote + 1} / ${_service.totalNotes} ]',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: LampungTheme.slate400,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_rounded,
                      color: LampungTheme.statusDanger, size: 32),
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
