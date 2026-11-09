import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gamolan_pekhing/main.dart';
import 'package:gamolan_pekhing/models/song_model.dart';
import 'package:gamolan_pekhing/models/default_songs.dart';
import 'package:gamolan_pekhing/screens/composer_screen.dart';
import 'package:gamolan_pekhing/screens/not_angka_screen.dart';
import 'package:gamolan_pekhing/services/gamolan_service.dart';

void main() {
  test('SongModel fromJson and isDefault check', () {
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
    expect(song.isDefault, true);

    final customSong = SongModel(
      id: 25,
      name: 'Lagu Ciptaan',
      tempo: 120,
      len: 16,
      category: SongCategory.lainnya,
    );
    expect(customSong.isDefault, false);
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
      5: ('Yamko Rambe Yamko', 116, 98),
      6: ('Ampar-Ampar Pisang', 105, 77),
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

  testWidgets('GamolanApp builds and renders HomeScreen without assertion errors',
      (tester) async {
    await tester.pumpWidget(const GamolanApp());
    await tester.pump();
    expect(find.text('GAMOLAN PEKHING'), findsWidgets);
    GamolanService.resetForTest();
  });

  testWidgets('ComposerScreen renders in edit mode with pre-filled notes',
      (tester) async {
    final sampleSong = SongModel(
      id: 5,
      name: 'Bubuy Bulan',
      tempo: 104,
      len: 2,
      category: SongCategory.daerah,
    );
    final sampleNotes = [
      NoteItem(nada: 1, panjang: 4),
      NoteItem(nada: 2, panjang: 4),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: ComposerScreen(
          editingSong: sampleSong,
          initialNotes: sampleNotes,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('[ MODE SUNTING ]'), findsOneWidget);
    expect(find.text('EDIT LAGU'), findsOneWidget);
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    expect(find.text('Simpan Sebagai Lagu Baru (Salinan)'), findsOneWidget);
    expect(find.text('[ SUSUNAN: 2 NADA ]'), findsOneWidget);
  });

  testWidgets(
      'HomeScreen floating island navbar switches tabs and renders on narrow screen',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const GamolanApp());
    await tester.pump();
    expect(tester.takeException(), isNull, reason: 'Initial load should have no exception');

    expect(find.text('Daftar Lagu'), findsOneWidget);
    expect(find.text('BILAH'), findsOneWidget);
    expect(find.text('Komposer'), findsOneWidget);

    // Switch to Komposer
    await tester.tap(find.text('Komposer'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Switch to komposer should have no exception');
    expect(find.text('BUAT LAGU GAMOLAN'), findsOneWidget);

    // Switch back to Daftar Lagu
    await tester.tap(find.text('Daftar Lagu'));
    await tester.pumpAndSettle();
    expect(find.text('GAMOLAN PEKHING'), findsWidgets);

    expect(tester.takeException(), isNull);
    GamolanService.resetForTest();
  });

  testWidgets('NotAngkaScreen renders 8 bilah keys and handles tap',
      (tester) async {
    tester.view.physicalSize = const Size(800, 400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        home: NotAngkaScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('DO'), findsOneWidget);
    expect(find.text("DO'"), findsOneWidget);

    // Tap first bilah (DO - 1)
    await tester.tap(find.text('DO'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    GamolanService.resetForTest();
  });

  testWidgets('NotAngkaScreen renders full-bleed with display notch insets',
      (tester) async {
    tester.view.physicalSize = const Size(840, 390);
    tester.view.devicePixelRatio = 1.0;
    tester.view.padding = const FakeViewPadding(left: 48, top: 24, right: 32, bottom: 16);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetPadding();
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: NotAngkaScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('DO'), findsOneWidget);
    expect(find.text('GAMOLAN PEKHING'), findsOneWidget);
    expect(tester.takeException(), isNull);
    GamolanService.resetForTest();
  });
}
