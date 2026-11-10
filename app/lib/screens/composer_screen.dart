import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/song_model.dart';
import '../services/gamolan_service.dart';
import '../theme/lampung_theme.dart';

class ComposerScreen extends StatefulWidget {
  final SongModel? editingSong;
  final List<NoteItem>? initialNotes;

  const ComposerScreen({super.key, this.editingSong, this.initialNotes});

  @override
  State<ComposerScreen> createState() => _ComposerScreenState();
}

class _ComposerScreenState extends State<ComposerScreen> {
  final GamolanService _service = GamolanService();
  final TextEditingController _nameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _tempo = 120;
  int _selectedPanjang = 4;
  SongCategory _selectedCategory = SongCategory.lainnya;
  final List<NoteItem> _notes = [];

  final _bars = List.generate(8, (i) {
    const solfeges = ['DO', 'RE', 'MI', 'FA', 'SOL', 'LA', 'SI', "DO'"];
    return {'num': i + 1, 'solfege': solfeges[i]};
  });

  final _panjangOptions = [
    {'val': 1, 'label': '¼ Ketuk', 'short': '¼'},
    {'val': 2, 'label': '½ Ketuk', 'short': '½'},
    {'val': 3, 'label': '¾ Ketuk', 'short': '¾'},
    {'val': 4, 'label': '1 Ketuk', 'short': '1'},
    {'val': 6, 'label': '1½ Ketuk', 'short': '1½'},
    {'val': 8, 'label': '2 Ketuk', 'short': '2'},
    {'val': 12, 'label': '3 Ketuk', 'short': '3'},
    {'val': 16, 'label': '4 Ketuk', 'short': '4'},
  ];

  int? _activePreviewNoteIndex;
  Timer? _localPreviewTimer;
  bool _isLocalPreviewing = false;

  bool get _isPreviewActive => _service.isPreviewing || _isLocalPreviewing;

  double _calculateDuration() {
    final totalUnits = _notes.fold<int>(0, (sum, n) => sum + n.panjang);
    return totalUnits * (60.0 / _tempo / 4.0);
  }

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
    if (widget.editingSong != null) {
      _nameController.text = widget.editingSong!.name;
      _tempo = widget.editingSong!.tempo;
      _selectedCategory = widget.editingSong!.category;
    }
    if (widget.initialNotes != null && widget.initialNotes!.isNotEmpty) {
      _notes.addAll(widget.initialNotes!);
    }
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    _localPreviewTimer?.cancel();
    _localPreviewTimer = null;
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onServiceUpdate() {
    if (!mounted) return;
    if (_service.isPreviewing) {
      setState(() {
        _activePreviewNoteIndex = _service.currentNote;
      });
      _scrollToActiveNote(_service.currentNote);
    } else if (_activePreviewNoteIndex != null && !_isLocalPreviewing) {
      setState(() {
        _activePreviewNoteIndex = null;
      });
    }
  }

  void _scrollToActiveNote(int index) {
    if (!_scrollController.hasClients || index < 0 || index >= _notes.length) {
      return;
    }
    const noteWidth = 64.0;
    final targetOffset = (index * noteWidth) - 100.0;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  void _togglePreview() {
    if (_notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text('Tambahkan nada terlebih dahulu untuk pratinjau!'),
        ),
      );
      return;
    }

    if (_isPreviewActive) {
      _stopPreview();
    } else {
      _startPreview();
    }
  }

  void _stopPreview() {
    if (_service.isConnected) {
      _service.stopPlayback();
    }
    _stopLocalPreview();
  }

  void _startPreview() {
    if (_service.isConnected) {
      final rawNotes = _notes.map((e) => e.toList()).toList();
      _service.previewSong(_tempo, rawNotes);
    } else {
      _startLocalPreview();
    }
  }

  void _startLocalPreview() {
    _localPreviewTimer?.cancel();
    setState(() {
      _isLocalPreviewing = true;
      _activePreviewNoteIndex = 0;
    });

    void playNext(int index) {
      if (!mounted || !_isLocalPreviewing) return;
      if (index >= _notes.length) {
        _stopLocalPreview();
        return;
      }

      setState(() {
        _activePreviewNoteIndex = index;
      });
      _scrollToActiveNote(index);

      final note = _notes[index];
      final durMs = (note.panjang * 60000 / (_tempo * 4)).round();
      _localPreviewTimer = Timer(Duration(milliseconds: durMs), () {
        playNext(index + 1);
      });
    }

    playNext(0);
  }

  void _stopLocalPreview() {
    _localPreviewTimer?.cancel();
    _localPreviewTimer = null;
    _isLocalPreviewing = false;
    _activePreviewNoteIndex = null;
    if (mounted) {
      setState(() {});
    }
  }

  void _addNote(int nada) {
    setState(() {
      _notes.add(NoteItem(nada: nada, panjang: _selectedPanjang));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeLastNote() {
    if (_notes.isNotEmpty) {
      setState(() => _notes.removeLast());
    }
  }

  void _clearAllNotes() {
    if (_notes.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: LampungTheme.slate200),
        ),
        title: const Text(
          'Hapus Semua Notasi?',
          style: TextStyle(
            color: LampungTheme.slate900,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Semua not angka yang sudah disusun akan dihapus.',
          style: TextStyle(color: LampungTheme.slate600),
        ),
        actions: [
          TextButton(
            child: const Text(
              'Batal',
              style: TextStyle(color: LampungTheme.slate500),
            ),
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
              setState(() => _notes.clear());
            },
          ),
        ],
      ),
    );
  }

  void _saveSong({bool saveAsNew = false}) {
    if (!_service.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text(
            'Gamolan belum terhubung! Sambungkan ke Wi-Fi terlebih dahulu.',
          ),
        ),
      );
      return;
    }
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text('Masukkan nama lagu terlebih dahulu!'),
        ),
      );
      return;
    }
    if (_notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: LampungTheme.statusDanger,
          content: Text('Tambahkan minimal 1 nada!'),
        ),
      );
      return;
    }

    _showPreviewAndConfirmDialog(saveAsNew: saveAsNew);
  }

  void _executeSave({bool saveAsNew = false}) {
    final name = _nameController.text.trim();
    final rawNotes = _notes.map((e) => e.toList()).toList();
    final isEditing = widget.editingSong != null && !saveAsNew;

    if (isEditing) {
      _service.editSong(
        widget.editingSong!.id,
        name,
        _tempo,
        rawNotes,
        _selectedCategory.name,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: LampungTheme.statusSuccess,
          content: Text('Lagu "$name" berhasil diperbarui di Gamolan!'),
        ),
      );
    } else {
      _service.addSong(name, _tempo, rawNotes, _selectedCategory.name);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: LampungTheme.statusSuccess,
          content: Text(
            'Lagu "$name" (${_notes.length} nada) dikirim ke Gamolan!',
          ),
        ),
      );
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      setState(() {
        _nameController.clear();
        _notes.clear();
      });
    }
  }

  void _showPreviewAndConfirmDialog({required bool saveAsNew}) {
    final name = _nameController.text.trim();
    final isEditing = widget.editingSong != null && !saveAsNew;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final isPreviewingNow = _isPreviewActive;
            final durationSec = _calculateDuration();

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, -4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: LampungTheme.slate300,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const Text(
                      '[ PRATINJAU SEBELUM MENYIMPAN ]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: LampungTheme.primaryBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: LampungTheme.slate900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: LampungTheme.slate50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: LampungTheme.slate200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetaItem(
                            'Kategori',
                            _selectedCategory.name.toUpperCase(),
                          ),
                          _buildMetaDivider(),
                          _buildMetaItem('Tempo', '$_tempo BPM'),
                          _buildMetaDivider(),
                          _buildMetaItem('Jumlah', '${_notes.length} Nada'),
                          _buildMetaDivider(),
                          _buildMetaItem(
                            'Durasi',
                            '~${durationSec.toStringAsFixed(1)}s',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        icon: Icon(
                          isPreviewingNow
                              ? Icons.stop_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        label: Text(
                          isPreviewingNow
                              ? 'Hentikan Pratinjau'
                              : 'Dengarkan Pratinjau di Gamolan',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPreviewingNow
                              ? LampungTheme.statusDanger
                              : LampungTheme.primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        onPressed: () {
                          _togglePreview();
                          setSheetState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: LampungTheme.slate600,
                                side: const BorderSide(
                                  color: LampungTheme.slate300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: const Text('Kembali Edit'),
                              onPressed: () {
                                _stopPreview();
                                Navigator.pop(sheetCtx);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: LampungTheme.statusSuccess,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: Text(
                                isEditing
                                    ? 'Simpan Sekarang'
                                    : 'Konfirmasi Simpan',
                              ),
                              onPressed: () {
                                _stopPreview();
                                Navigator.pop(sheetCtx);
                                _executeSave(saveAsNew: saveAsNew);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMetaItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: LampungTheme.slate500,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: LampungTheme.slate900,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDivider() {
    return Container(width: 1, height: 24, color: LampungTheme.slate200);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editingSong != null;
    final canPop = Navigator.canPop(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Row(
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
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEditing ? '[ MODE SUNTING ]' : '[ KOMPOSER MUSIK ]',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                      color: LampungTheme.accentBlueLight,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isEditing ? 'EDIT LAGU' : 'BUAT LAGU GAMOLAN',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: LampungTheme.primaryBlue,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: LampungTheme.darkBlue),
        ),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              tooltip: 'Hapus Semua',
              onPressed: _clearAllNotes,
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
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
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: LampungTheme.slate200),
                    boxShadow: LampungTheme.hardShadowCard,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEditing
                            ? '[ INFORMASI LAGU (ID: ${widget.editingSong!.id}) ]'
                            : '[ INFORMASI LAGU ]',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: LampungTheme.primaryBlue,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(
                          color: LampungTheme.slate900,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: LampungTheme.slate50,
                          labelText: 'Nama Lagu',
                          labelStyle: const TextStyle(
                            color: LampungTheme.slate500,
                            fontSize: 12,
                          ),
                          hintText: 'Contoh: Tabuh Sampeang',
                          hintStyle: const TextStyle(
                            color: LampungTheme.slate400,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: LampungTheme.slate200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: LampungTheme.primaryBlue,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Kategori:',
                            style: TextStyle(
                              color: LampungTheme.slate600,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: LampungTheme.slate50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: LampungTheme.slate200,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<SongCategory>(
                                  value: _selectedCategory,
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  style: const TextStyle(
                                    color: LampungTheme.slate900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                  items: SongCategory.values.map((cat) {
                                    return DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat.label),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _selectedCategory = val);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.speed,
                            color: LampungTheme.primaryBlue,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '[ $_tempo BPM ]',
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              color: LampungTheme.primaryBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: _tempo.toDouble(),
                              min: 60,
                              max: 200,
                              divisions: 28,
                              activeColor: LampungTheme.primaryBlue,
                              inactiveColor: LampungTheme.slate200,
                              onChanged: (val) =>
                                  setState(() => _tempo = val.round()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '[ PANJANG KETUKAN ]',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: LampungTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _panjangOptions.map((opt) {
                      final isSelected = _selectedPanjang == opt['val'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: Text('${opt['short']} (${opt['label']})'),
                          selectedColor: LampungTheme.primaryBlue,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                            side: BorderSide(
                              color: isSelected
                                  ? LampungTheme.primaryBlue
                                  : LampungTheme.slate200,
                            ),
                          ),
                          labelStyle: TextStyle(
                            fontFamily: 'monospace',
                            color: isSelected
                                ? Colors.white
                                : LampungTheme.slate700,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 11,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                () => _selectedPanjang = opt['val'] as int,
                              );
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  '[ KETUK BILAH ]',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: LampungTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.35,
                  ),
                  itemBuilder: (context, index) {
                    final bar = _bars[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: LampungTheme.accentBlueLight),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1F1D4ED8),
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _addNote(bar['num'] as int),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${bar['num']}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: LampungTheme.primaryBlue,
                                ),
                              ),
                              Text(
                                bar['solfege'] as String,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: LampungTheme.secondaryBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton.icon(
                    icon: const Icon(
                      Icons.pause,
                      color: LampungTheme.primaryBlue,
                      size: 18,
                    ),
                    label: const Text(
                      'Istirahat / Diam (0)',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: LampungTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: LampungTheme.accentBlueLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () => _addNote(0),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '[ SUSUNAN: ${_notes.length} NADA ]',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        color: LampungTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                    if (_notes.isNotEmpty)
                      GestureDetector(
                        onTap: _removeLastNote,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.backspace,
                              size: 14,
                              color: LampungTheme.statusDanger,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Hapus Terakhir',
                              style: TextStyle(
                                color: LampungTheme.statusDanger,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  height: 64,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: LampungTheme.slate200),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1F1D4ED8),
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: _notes.isEmpty
                      ? const Center(
                          child: Text(
                            'Ketuk bilah untuk mulai menyusun lagu.',
                            style: TextStyle(
                              color: LampungTheme.slate400,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final item = _notes[index];
                            final isDiam = item.nada == 0;
                            final isActive = index == _activePreviewNoteIndex;
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? LampungTheme.accentBlueLight.withValues(
                                        alpha: 0.35,
                                      )
                                    : isDiam
                                    ? LampungTheme.slate100
                                    : LampungTheme.blue50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isActive
                                      ? LampungTheme.primaryBlue
                                      : isDiam
                                      ? LampungTheme.slate300
                                      : LampungTheme.primaryBlue,
                                  width: isActive ? 2.5 : 1.0,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isDiam ? '-' : item.angka,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDiam
                                          ? LampungTheme.slate600
                                          : LampungTheme.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    isDiam
                                        ? 'diam'
                                        : '${item.namaNada}·${item.durasiLabel}',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 8,
                                      color: isDiam
                                          ? LampungTheme.slate500
                                          : LampungTheme.darkBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 44,
                  decoration: const BoxDecoration(
                    boxShadow: LampungTheme.hardShadowPill,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  child: OutlinedButton.icon(
                    icon: Icon(
                      _isPreviewActive
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      color: _isPreviewActive
                          ? LampungTheme.statusDanger
                          : LampungTheme.primaryBlue,
                    ),
                    label: Text(
                      _isPreviewActive
                          ? 'Hentikan Pratinjau'
                          : 'Pratinjau Suara (~${_calculateDuration().toStringAsFixed(1)}s)',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: _isPreviewActive
                            ? LampungTheme.statusDanger
                            : LampungTheme.primaryBlue,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _isPreviewActive
                          ? LampungTheme.statusDanger.withValues(alpha: 0.08)
                          : Colors.white,
                      side: BorderSide(
                        color: _isPreviewActive
                            ? LampungTheme.statusDanger
                            : LampungTheme.primaryBlue,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: _notes.isEmpty ? null : _togglePreview,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 48,
                  decoration: const BoxDecoration(
                    boxShadow: LampungTheme.hardShadowPill,
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      isEditing
                          ? Icons.check_circle_rounded
                          : Icons.cloud_upload_rounded,
                    ),
                    label: Text(
                      isEditing ? 'Simpan Perubahan' : 'Simpan ke Gamolan',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LampungTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: () => _saveSong(saveAsNew: false),
                  ),
                ),
                if (isEditing) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text(
                        'Simpan Sebagai Lagu Baru (Salinan)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: LampungTheme.primaryBlue,
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: LampungTheme.primaryBlue,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      onPressed: () => _saveSong(saveAsNew: true),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
