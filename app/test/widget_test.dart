import 'package:flutter_test/flutter_test.dart';
import 'package:gamolan_pekhing/models/song_model.dart';
import 'package:gamolan_pekhing/models/default_songs.dart';

void main() {
  test('SongModel fromJson with category', () {
    final song = SongModel.fromJson({
      'id': 0,
      'name': 'Indonesia Raya',
      'tempo': 104,
      'len': 44,
      'cat': 'nasional',
    });
    expect(song.id, 0);
    expect(song.name, 'Indonesia Raya');
    expect(song.tempo, 104);
    expect(song.len, 44);
    expect(song.category, SongCategory.nasional);
  });

  test('NoteItem labels', () {
    final note = NoteItem(nada: 3, panjang: 4);
    expect(note.namaNada, 'MI');
    expect(note.durasiLabel, '1');
    expect(note.toList(), [3, 4]);
  });

  test('DefaultSongs has 20 songs with 5 in each category', () {
    expect(DefaultSongs.list.length, 20);
    for (final cat in SongCategory.values) {
      final inCat = DefaultSongs.list.where((s) => s.category == cat).length;
      expect(inCat, 5, reason: 'Category ${cat.name} should have 5 songs');
    }
  });

  test('Default songs match firmware PROGMEM song sizes', () {
    // (id, name, tempo, len) must equal main.ino song_N arrays & defaultSongTempos.
    const firmware = {
      0: ('Indonesia Raya', 96, 45),
      1: ('Tanah Airku', 80, 110),
      2: ('Bagimu Negeri', 80, 45),
      3: ('Garuda Pancasila', 100, 82),
      4: ('Ibu Kita Kartini', 88, 57),
      7: ('Gundul-Gundul Pacul', 112, 56),
      8: ('Apuse', 96, 53),
      9: ('Suwe Ora Jamu', 104, 54),
    };
    firmware.forEach((id, meta) {
      final song = DefaultSongs.list.firstWhere((s) => s.id == id);
      expect(song.name, meta.$1);
      expect(song.tempo, meta.$2, reason: '${meta.$1} tempo');
      expect(song.len, meta.$3, reason: '${meta.$1} len');
    });
  });
}
