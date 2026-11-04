import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/song_model.dart';
import '../services/gamolan_service.dart';
import '../theme/lampung_theme.dart';
import 'composer_screen.dart';

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
                          color: LampungTheme.blue50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: LampungTheme.accentBlueLight),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/gamolan_logo.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Sambungkan ke Gamolan',
                        style: TextStyle(
                          color: LampungTheme.primaryBlue,
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
                      color: LampungTheme.blue50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: LampungTheme.accentBlueLight),
                      boxShadow: LampungTheme.hardShadowCard,
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
                            foregroundColor: LampungTheme.primaryBlue,
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: LampungTheme.accentBlueLight),
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
                            boxShadow: LampungTheme.hardShadowPill,
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

  Future<void> _editSong(SongModel song, {bool isDuplicate = false}) async {
    if (!_service.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text(
              'Hubungkan Wi-Fi Gamolan terlebih dahulu untuk memuat notasi lagu!'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: LampungTheme.primaryBlue),
                SizedBox(width: 16),
                Text(
                  'Mengambil notasi...',
                  style: TextStyle(
                    color: LampungTheme.slate900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final notes = await _service.getSongNotes(song.id);
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();

    if (notes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text('Gagal mengambil notasi lagu dari Gamolan!'),
        ),
      );
      return;
    }

    final targetSong = isDuplicate
        ? SongModel(
            id: -1,
            name: '${song.name} (Salinan)',
            tempo: song.tempo,
            len: notes.length,
            category: song.category,
          )
        : song;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ComposerScreen(
          editingSong: targetSong,
          initialNotes: notes,
        ),
      ),
    );
  }

  void _showRestoreDefaultsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LampungTheme.slate200),
        ),
        title: const Text(
          'Pulihkan Lagu Bawaan?',
          style: TextStyle(
            color: LampungTheme.slate900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Semua lagu bawaan sistem yang pernah dihapus/disembunyikan akan dikembalikan seperti semula.',
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
              backgroundColor: LampungTheme.primaryBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            child: const Text('Pulihkan'),
            onPressed: () {
              Navigator.pop(ctx);
              _service.resetDefaultSongs();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: LampungTheme.statusSuccess,
                  content: Text('Lagu bawaan sistem berhasil dipulihkan!'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(SongModel song) {
    final isBawaan = song.isDefault;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LampungTheme.slate200),
        ),
        title: Text(
          isBawaan ? 'Hapus Lagu Bawaan?' : 'Hapus "${song.name}"?',
          style: const TextStyle(
            color: LampungTheme.slate900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          isBawaan
              ? 'Lagu bawaan "${song.name}" akan disembunyikan dari daftar. Anda bisa memulihkannya kembali lewat menu titik tiga di atas.'
              : 'Lagu "${song.name}" akan dihapus permanen dari memori Gamolan.',
          style: const TextStyle(color: LampungTheme.slate600),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: LampungTheme.statusDanger,
                  content: Text(isBawaan
                      ? 'Lagu bawaan disembunyikan'
                      : 'Lagu "${song.name}" dihapus'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.6,
                child: SvgPicture.asset(
                  'assets/images/lampung_bg_pattern.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              _buildHeader(),
              _buildConnectionStrip(),
              _buildCategoryTabs(),
              Expanded(child: _buildTabContent()),
              if (_service.isPlaying) _buildNowPlayingBar(),
            ],
          ),
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
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: LampungTheme.accentBlueLight.withValues(alpha: 0.3),
              ),
            ),
            child: SvgPicture.asset(
              'assets/images/gamolan_logo.svg',
              height: 28,
              width: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'GAMOLAN PEKHING',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: Colors.white, size: 22),
            tooltip: 'Refresh Daftar Lagu',
            onPressed: () {
              if (_service.isConnected) {
                _service.fetchSongList();
              } else {
                _service.connectWebSocket();
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                color: Colors.white, size: 22),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: LampungTheme.slate200),
            ),
            tooltip: 'Opsi Menu',
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'restore',
                child: Row(
                  children: [
                    Icon(Icons.restore_rounded,
                        size: 18, color: LampungTheme.primaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Pulihkan Lagu Bawaan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: LampungTheme.slate900,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'new_song',
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline_rounded,
                        size: 18, color: LampungTheme.secondaryBlue),
                    SizedBox(width: 8),
                    Text(
                      'Komposer Lagu Baru',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: LampungTheme.slate900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (val) {
              if (val == 'restore') {
                _showRestoreDefaultsDialog();
              } else if (val == 'new_song') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ComposerScreen(),
                  ),
                );
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isConnected
            ? const Color(0xFFF0FDF4)
            : (isConnecting
                ? const Color(0xFFFEFCE8)
                : const Color(0xFFF8FAFC)),
        border: Border(
          bottom: BorderSide(
            color: isConnected
                ? const Color(0xFF86EFAC)
                : (isConnecting
                    ? const Color(0xFFFDE047)
                    : const Color(0xFFE2E8F0)),
            width: 1.2,
          ),
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
                  ? LampungTheme.statusSuccess
                  : (isConnecting
                      ? const Color(0xFFEAB308)
                      : LampungTheme.statusDanger),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                fontFamily: 'monospace',
                color: isConnected
                    ? const Color(0xFF15803D)
                    : (isConnecting
                        ? const Color(0xFFA16207)
                        : LampungTheme.slate600),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
          if (isConnected)
            GestureDetector(
              onTap: () => _service.disconnect(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: LampungTheme.statusDanger),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22DC2626),
                      offset: Offset(1, 1),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: LampungTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: LampungTheme.deepBlue,
                      offset: Offset(1, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi, size: 12, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Hubungkan',
                      style: TextStyle(
                        color: Colors.white,
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
        unselectedLabelColor: LampungTheme.slate400,
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
                      color: LampungTheme.primaryBlue,
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: LampungTheme.blue50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: LampungTheme.accentBlueLight),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/gamolan_logo.svg',
                    height: 56,
                    width: 56,
                  ),
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
                        : LampungTheme.blue50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isPlaying
                          ? LampungTheme.darkBlue
                          : LampungTheme.accentBlueLight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      indexNumber.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isPlaying
                            ? Colors.white
                            : LampungTheme.primaryBlue,
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
                      Wrap(
                        spacing: 6,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
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
                          Text(
                            '[ ${song.len} NADA ]',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: LampungTheme.slate500,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            song.isDefault
                                ? '[ ${song.category.name.toUpperCase()} ]'
                                : '[ KUSTOM ]',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              color: song.isDefault
                                  ? (song.category == SongCategory.lampung
                                      ? LampungTheme.secondaryBlue
                                      : LampungTheme.slate500)
                                  : LampungTheme.statusSuccess,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
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
                          offset: Offset(1, 2),
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
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: LampungTheme.slate400,
                    size: 20,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: LampungTheme.slate200),
                  ),
                  tooltip: 'Menu Lagu',
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded,
                              size: 16, color: LampungTheme.primaryBlue),
                          SizedBox(width: 8),
                          Text(
                            'Edit Notasi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: LampungTheme.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy_rounded,
                              size: 16, color: LampungTheme.secondaryBlue),
                          SizedBox(width: 8),
                          Text(
                            'Duplikat / Salin',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: LampungTheme.slate900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              size: 16, color: LampungTheme.statusDanger),
                          SizedBox(width: 8),
                          Text(
                            'Hapus Lagu',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: LampungTheme.statusDanger,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (val) {
                    if (val == 'edit') {
                      _editSong(song);
                    } else if (val == 'duplicate') {
                      _editSong(song, isDuplicate: true);
                    } else if (val == 'delete') {
                      _showDeleteDialog(song);
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
        color: LampungTheme.primaryBlue,
        border: Border(
          top: BorderSide(
            color: LampungTheme.deepBlue,
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: LampungTheme.darkBlue,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
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
                  child: Center(
                    child: Text(
                      nadaText,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w900,
                        color: LampungTheme.primaryBlue,
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
                          color: LampungTheme.accentBlueLight,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.stop_circle_rounded,
                      color: Colors.white, size: 32),
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
