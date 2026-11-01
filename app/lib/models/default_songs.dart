import 'song_model.dart';

class DefaultSongs {
  DefaultSongs._();

  static final List<SongModel> list = [
    // --- 1. LAGU NASIONAL ---
    SongModel(
      id: 0,
      name: 'Indonesia Raya',
      tempo: 96,
      len: 45,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 1,
      name: 'Tanah Airku',
      tempo: 84,
      len: 70,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 2,
      name: 'Bagimu Negeri',
      tempo: 80,
      len: 49,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 3,
      name: 'Garuda Pancasila',
      tempo: 96,
      len: 84,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 4,
      name: 'Ibu Kita Kartini',
      tempo: 88,
      len: 58,
      category: SongCategory.nasional,
    ),

    // --- 2. LAGU DAERAH ---
    SongModel(
      id: 5,
      name: 'Bubuy Bulan',
      tempo: 104,
      len: 60,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 6,
      name: 'Ampar-Ampar Pisang',
      tempo: 108,
      len: 57,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 7,
      name: 'Gundul-Gundul Pacul',
      tempo: 112,
      len: 45,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 8,
      name: 'Apuse',
      tempo: 96,
      len: 53,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 9,
      name: 'Suwe Ora Jamu',
      tempo: 104,
      len: 44,
      category: SongCategory.daerah,
    ),

    // --- 3. TRADISIONAL LAMPUNG (Gamolan Pekhing Asli) ---
    SongModel(
      id: 10,
      name: 'Tabuh Segata',
      tempo: 96,
      len: 42,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 11,
      name: 'Sang Bumi Ruwa Jurai',
      tempo: 100,
      len: 42,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 12,
      name: 'Tanoh Lado',
      tempo: 92,
      len: 42,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 13,
      name: 'Gitar Tunggal Lampung',
      tempo: 88,
      len: 48,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 14,
      name: 'Mulang Unyin',
      tempo: 92,
      len: 42,
      category: SongCategory.lampung,
    ),

    // --- 4. LAINNYA ---
    SongModel(
      id: 15,
      name: 'Twinkle Twinkle Little Star',
      tempo: 100,
      len: 42,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 16,
      name: 'Selamat Ulang Tahun',
      tempo: 100,
      len: 26,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 17,
      name: 'Ode to Joy',
      tempo: 108,
      len: 63,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 18,
      name: 'Do Re Mi',
      tempo: 108,
      len: 57,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 19,
      name: 'Mary Had a Little Lamb',
      tempo: 104,
      len: 28,
      category: SongCategory.lainnya,
    ),
  ];
}
