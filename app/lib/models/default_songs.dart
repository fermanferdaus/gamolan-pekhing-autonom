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
      tempo: 80,
      len: 110,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 2,
      name: 'Bagimu Negeri',
      tempo: 80,
      len: 45,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 3,
      name: 'Garuda Pancasila',
      tempo: 100,
      len: 82,
      category: SongCategory.nasional,
    ),
    SongModel(
      id: 4,
      name: 'Ibu Kita Kartini',
      tempo: 88,
      len: 57,
      category: SongCategory.nasional,
    ),

    // --- 2. LAGU DAERAH ---
    SongModel(
      id: 5,
      name: 'Anak Kambing Saya',
      tempo: 112,
      len: 100,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 6,
      name: 'Cublak-Cublak Suweng',
      tempo: 140,
      len: 54,
      category: SongCategory.daerah,
    ),
    SongModel(
      id: 7,
      name: 'Gundul-Gundul Pacul',
      tempo: 112,
      len: 56,
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
      len: 54,
      category: SongCategory.daerah,
    ),

    // --- 3. TRADISIONAL LAMPUNG (Gamolan Pekhing Asli) ---
    SongModel(
      id: 10,
      name: 'Tabuh Sambai Agung',
      tempo: 100,
      len: 272,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 11,
      name: 'Tabuh Sekeli',
      tempo: 100,
      len: 184,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 12,
      name: 'Tabuh Jakhang',
      tempo: 66,
      len: 304,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 13,
      name: 'Tabuh Tari',
      tempo: 76,
      len: 152,
      category: SongCategory.lampung,
    ),
    SongModel(
      id: 14,
      name: 'Tabuh Alau-Alau Kembahang',
      tempo: 132,
      len: 56,
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
      name: 'Pelangi-Pelangi',
      tempo: 80,
      len: 49,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 18,
      name: 'Balonku Ada Lima',
      tempo: 68,
      len: 58,
      category: SongCategory.lainnya,
    ),
    SongModel(
      id: 19,
      name: 'Naik Delman',
      tempo: 92,
      len: 117,
      category: SongCategory.lainnya,
    ),
  ];
}
