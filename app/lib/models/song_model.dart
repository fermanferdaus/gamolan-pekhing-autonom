enum SongCategory {
  nasional('Lagu Nasional'),
  daerah('Lagu Daerah'),
  lampung('Tradisional Lampung'),
  lainnya('Lainnya');

  final String label;
  const SongCategory(this.label);
}

class SongModel {
  final int id;
  final String name;
  final int tempo;
  final int len;
  final SongCategory category;

  SongModel({
    required this.id,
    required this.name,
    required this.tempo,
    required this.len,
    this.category = SongCategory.lainnya,
  });

  bool get isDefault => id < 20;

  factory SongModel.fromJson(Map<String, dynamic> json) {
    final catStr = json['cat'] as String? ?? 'lainnya';
    final cat = SongCategory.values.firstWhere(
      (c) => c.name == catStr,
      orElse: () => SongCategory.lainnya,
    );
    return SongModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Tanpa Nama',
      tempo: json['tempo'] as int? ?? 120,
      len: json['len'] as int? ?? 0,
      category: cat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tempo': tempo,
      'len': len,
      'cat': category.name,
    };
  }
}

class NoteItem {
  final int nada;
  final int panjang;

  NoteItem({required this.nada, required this.panjang});

  List<int> toList() => [nada, panjang];

  int get kanan => nada & 0x0F;
  int get kiri => nada >> 4;

  String get angka => kiri > 0 ? '$kanan+$kiri' : '$nada';

  String get namaNada {
    const names = ['-', 'DO', 'RE', 'MI', 'FA', 'SOL', 'LA', 'SI', "DO'"];
    if (kanan >= names.length || kiri >= names.length) return '?';
    return kiri > 0 ? '${names[kanan]}+${names[kiri]}' : names[kanan];
  }

  String get durasiLabel {
    switch (panjang) {
      case 1:
        return '¼';
      case 2:
        return '½';
      case 3:
        return '¾';
      case 4:
        return '1';
      case 8:
        return '2';
      default:
        return '$panjang/4';
    }
  }
}
