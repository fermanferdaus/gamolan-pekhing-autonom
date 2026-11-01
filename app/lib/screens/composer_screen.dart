import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/song_model.dart';
import '../services/gamolan_service.dart';
import '../theme/lampung_theme.dart';

class ComposerScreen extends StatefulWidget {
  const ComposerScreen({super.key});

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
    {'val': 8, 'label': '2 Ketuk', 'short': '2'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addNote(int nada) {
    if (nada > 0) _service.hitNada(nada);
    setState(() {
      _notes.add(NoteItem(nada: nada, panjang: _selectedPanjang));
    });
    Future.delayed(const Duration(milliseconds: 60), () {
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
        backgroundColor: LampungTheme.bgCard,
        title: const Text('Hapus Semua Notasi?',
            style: TextStyle(color: LampungTheme.textPrimary)),
        content: const Text('Semua not angka yang sudah disusun akan dihapus.',
            style: TextStyle(color: LampungTheme.textSecondary)),
        actions: [
          TextButton(
              child: const Text('Batal',
                  style: TextStyle(color: LampungTheme.textMuted)),
              onPressed: () => Navigator.pop(ctx)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: LampungTheme.tapisRed),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => _notes.clear());
            },
          ),
        ],
      ),
    );
  }

  void _saveSong() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nama lagu terlebih dahulu!')),
      );
      return;
    }
    if (_notes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tambahkan minimal 1 nada!')),
      );
      return;
    }

    final rawNotes = _notes.map((e) => e.toList()).toList();
    _service.addSong(name, _tempo, rawNotes, _selectedCategory.name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1B3B1E),
        content:
            Text('Lagu "$name" (${_notes.length} nada) dikirim ke Gamolan!'),
      ),
    );

    setState(() {
      _nameController.clear();
      _notes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LampungTheme.bgDark,
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/siger.svg',
              height: 20,
              colorFilter: ColorFilter.mode(
                LampungTheme.gold.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Buat Lagu',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: LampungTheme.textPrimary)),
          ],
        ),
        backgroundColor: LampungTheme.bgMedium,
        elevation: 0,
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon:
                  const Icon(Icons.delete_sweep, color: LampungTheme.tapisRed),
              tooltip: 'Hapus Semua',
              onPressed: _clearAllNotes,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: LampungTheme.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: LampungTheme.goldDark.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: LampungTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Judul Lagu',
                      labelStyle:
                          const TextStyle(color: LampungTheme.textSecondary),
                      hintText: 'Contoh: Tanah Airku',
                      hintStyle:
                          const TextStyle(color: LampungTheme.textMuted),
                      prefixIcon:
                          const Icon(Icons.title, color: LampungTheme.gold),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                LampungTheme.goldDark.withValues(alpha: 0.3)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: LampungTheme.gold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.category,
                          color: LampungTheme.gold, size: 20),
                      const SizedBox(width: 8),
                      const Text('Kategori:',
                          style: TextStyle(
                              color: LampungTheme.textPrimary,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: LampungTheme.bgSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: LampungTheme.goldDark
                                    .withValues(alpha: 0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<SongCategory>(
                              value: _selectedCategory,
                              dropdownColor: LampungTheme.bgCard,
                              style: const TextStyle(
                                  color: LampungTheme.textPrimary,
                                  fontSize: 14),
                              isExpanded: true,
                              items: SongCategory.values
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(
                                            '${c.icon} ${c.label}'),
                                      ))
                                  .toList(),
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _selectedCategory = v);
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
                      const Icon(Icons.speed,
                          color: LampungTheme.gold, size: 20),
                      const SizedBox(width: 8),
                      Text('$_tempo BPM',
                          style: const TextStyle(
                              color: LampungTheme.textPrimary,
                              fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: _tempo.toDouble(),
                          min: 60,
                          max: 200,
                          divisions: 28,
                          activeColor: LampungTheme.gold,
                          inactiveColor: LampungTheme.bgSurface,
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
            const Text('Panjang Ketukan',
                style: TextStyle(
                    color: LampungTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
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
                      label: Text('${opt['short']} (${opt['label']})'),
                      selectedColor: LampungTheme.gold,
                      backgroundColor: LampungTheme.bgCard,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? LampungTheme.bgDark
                            : LampungTheme.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(
                              () => _selectedPanjang = opt['val'] as int);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),
            const Text('Ketuk Bilah',
                style: TextStyle(
                    color: LampungTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
            const SizedBox(height: 6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final bar = _bars[index];
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LampungTheme.goldBronze,
                    foregroundColor: const Color(0xFF221804),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side:
                          BorderSide(color: LampungTheme.goldDark, width: 1.5),
                    ),
                  ),
                  onPressed: () => _addNote(bar['num'] as int),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${bar['num']}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                      Text(bar['solfege'] as String,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.pause,
                    color: LampungTheme.textSecondary, size: 18),
                label: const Text('Istirahat (0)',
                    style: TextStyle(
                        color: LampungTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: LampungTheme.bgCard,
                  side: BorderSide(
                      color: LampungTheme.goldDark.withValues(alpha: 0.3)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _addNote(0),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Susunan (${_notes.length} nada)',
                    style: const TextStyle(
                        color: LampungTheme.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                if (_notes.isNotEmpty)
                  GestureDetector(
                    onTap: _removeLastNote,
                    child: const Row(
                      children: [
                        Icon(Icons.backspace,
                            size: 14, color: LampungTheme.tapisRed),
                        SizedBox(width: 4),
                        Text('Hapus',
                            style: TextStyle(
                                color: LampungTheme.tapisRed, fontSize: 11)),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 62,
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: LampungTheme.bgDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: LampungTheme.goldDark.withValues(alpha: 0.2)),
              ),
              child: _notes.isEmpty
                  ? const Center(
                      child: Text('Ketuk bilah untuk mulai menyusun lagu.',
                          style: TextStyle(
                              color: LampungTheme.textMuted, fontSize: 11),
                          textAlign: TextAlign.center))
                  : ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: _notes.length,
                      itemBuilder: (context, index) {
                        final item = _notes[index];
                        final isDiam = item.nada == 0;
                        return Container(
                          margin: const EdgeInsets.only(right: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDiam
                                ? LampungTheme.bgSurface
                                : LampungTheme.gold,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isDiam
                                  ? LampungTheme.goldDark
                                      .withValues(alpha: 0.3)
                                  : LampungTheme.goldDark,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isDiam ? '-' : '${item.nada}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDiam
                                          ? LampungTheme.textSecondary
                                          : LampungTheme.bgDark)),
                              Text(
                                  isDiam
                                      ? 'diam'
                                      : '${item.namaNada}·${item.durasiLabel}',
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: isDiam
                                          ? LampungTheme.textMuted
                                          : const Color(0xFF3E2D07),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Simpan ke Gamolan',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LampungTheme.gold,
                  foregroundColor: LampungTheme.bgDark,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveSong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
