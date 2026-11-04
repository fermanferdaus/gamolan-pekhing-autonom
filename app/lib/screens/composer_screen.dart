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
    {'val': 6, 'label': '1½ Ketuk', 'short': '1½'},
    {'val': 8, 'label': '2 Ketuk', 'short': '2'},
    {'val': 12, 'label': '3 Ketuk', 'short': '3'},
    {'val': 16, 'label': '4 Ketuk', 'short': '4'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
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

    final rawNotes = _notes.map((e) => e.toList()).toList();
    _service.addSong(name, _tempo, rawNotes, _selectedCategory.name);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: LampungTheme.statusSuccess,
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
      backgroundColor: LampungTheme.slate50,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: LampungTheme.slate900,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: LampungTheme.slate800),
              ),
              child: SvgPicture.asset(
                'assets/images/siger_crown.svg',
                height: 20,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '[ KOMPOSER MUSIK ]',
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
                  'BUAT LAGU GAMOLAN',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: LampungTheme.slate950,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: LampungTheme.slate800),
        ),
        actions: [
          if (_notes.isNotEmpty)
            IconButton(
              icon:
                  const Icon(Icons.delete_sweep, color: LampungTheme.statusDanger),
              tooltip: 'Hapus Semua',
              onPressed: _clearAllNotes,
            ),
        ],
      ),
      body: SingleChildScrollView(
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
                  const Text(
                    '[ INFORMASI LAGU ]',
                    style: TextStyle(
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
                          horizontal: 14, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: LampungTheme.slate200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: LampungTheme.primaryBlue, width: 1.6),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: LampungTheme.slate50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: LampungTheme.slate200),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<SongCategory>(
                              value: _selectedCategory,
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
                      const Icon(Icons.speed,
                          color: LampungTheme.primaryBlue, size: 20),
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
                        color: isSelected ? Colors.white : LampungTheme.slate700,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 11,
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
                    border: Border.all(color: LampungTheme.slate200),
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
                              color: LampungTheme.slate900,
                            ),
                          ),
                          Text(
                            bar['solfege'] as String,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: LampungTheme.primaryBlue,
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
                icon: const Icon(Icons.pause,
                    color: LampungTheme.slate600, size: 18),
                label: const Text(
                  'Istirahat / Diam (0)',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: LampungTheme.slate700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: LampungTheme.slate300),
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
                        Icon(Icons.backspace,
                            size: 14, color: LampungTheme.statusDanger),
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDiam
                                ? LampungTheme.slate100
                                : LampungTheme.blue50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDiam
                                  ? LampungTheme.slate300
                                  : LampungTheme.primaryBlue,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isDiam ? '-' : '${item.nada}',
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
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 48,
              decoration: const BoxDecoration(
                boxShadow: LampungTheme.hardShadowPill,
                borderRadius: BorderRadius.all(Radius.circular(999)),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.cloud_upload_rounded),
                label: const Text(
                  'Simpan ke Gamolan',
                  style: TextStyle(
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
                onPressed: _saveSong,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
