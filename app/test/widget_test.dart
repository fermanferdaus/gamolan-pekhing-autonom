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
}
