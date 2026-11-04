import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/song_model.dart';
import '../models/default_songs.dart';

enum ConnectionStatus { disconnected, connecting, connected }

class GamolanService extends ChangeNotifier {
  static GamolanService _instance = GamolanService._internal();
  factory GamolanService() => _instance;
  GamolanService._internal({bool startTimer = true}) {
    _songs = List.from(DefaultSongs.list);
    final isTesting = Platform.environment.containsKey('FLUTTER_TEST');
    if (startTimer && !isTesting) _startAutoProbeTimer();
  }

  @visibleForTesting
  static void resetForTest() {
    _instance.cancelTimers();
    _instance._subscription?.cancel();
    _instance._channel?.sink.close();
    _instance = GamolanService._internal(startTimer: false);
  }

  static const String serverHost = '192.168.4.1';
  static const int serverPort = 81;
  static const _platformChannel =
      MethodChannel('com.gamolan.gamolan_pekhing/wifi');

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _connectTimeoutTimer;
  Timer? _connectOverallTimeoutTimer;
  Timer? _autoProbeTimer;
  bool _isProbing = false;
  final Map<int, Completer<List<NoteItem>?>> _songDetailCompleters = {};

  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionStatus get status => _status;
  bool get isConnected => _status == ConnectionStatus.connected;

  List<SongModel> _songs = [];
  List<SongModel> get songs => _songs;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _playingSongId = -1;
  int get playingSongId => _playingSongId;

  String get playingSongName {
    final s = _songs.where((e) => e.id == _playingSongId);
    return s.isNotEmpty ? s.first.name : '';
  }

  int _currentNote = 0;
  int get currentNote => _currentNote;

  int _totalNotes = 0;
  int get totalNotes => _totalNotes;

  int _activeNada = 0;
  int get activeNada => _activeNada;

  String? _lastMessage;
  String? get lastMessage => _lastMessage;

  void cancelTimers() {
    _autoProbeTimer?.cancel();
    _autoProbeTimer = null;
    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;
    _connectOverallTimeoutTimer?.cancel();
    _connectOverallTimeoutTimer = null;
  }

  void _startAutoProbeTimer() {
    _autoProbeTimer?.cancel();
    _autoProbeTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_status == ConnectionStatus.disconnected && !_isProbing) {
        _isProbing = true;
        try {
          final reachable = await probeEsp32();
          if (reachable && _status == ConnectionStatus.disconnected) {
            connectWebSocket();
          }
        } finally {
          _isProbing = false;
        }
      }
    });
  }

  Future<bool> probeEsp32() async {
    try {
      await bindProcessToWifi();
      final socket = await Socket.connect(
        serverHost,
        serverPort,
        timeout: const Duration(milliseconds: 700),
      );
      socket.destroy();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> bindProcessToWifi() async {
    try {
      await _platformChannel.invokeMethod('bindToWifi');
    } catch (_) {}
  }

  Future<void> openWifiManager() async {
    try {
      await _platformChannel.invokeMethod('openWifiManager');
    } catch (_) {}
  }

  Future<bool> connectWithResult() async {
    if (_status == ConnectionStatus.connected) return true;

    _status = ConnectionStatus.connecting;
    notifyListeners();

    await bindProcessToWifi();

    final reachable = await probeEsp32();
    if (!reachable) {
      _handleDisconnect();
      return false;
    }

    final completer = Completer<bool>();
    try {
      final wsUrl = Uri.parse('ws://$serverHost:$serverPort');
      _channel = WebSocketChannel.connect(wsUrl);

      _subscription = _channel!.stream.listen(
        (data) {
          if (_status != ConnectionStatus.connected) {
            _status = ConnectionStatus.connected;
            notifyListeners();
            fetchSongList();
            if (!completer.isCompleted) completer.complete(true);
          }
          _handleMessage(data.toString());
        },
        onError: (_) {
          _handleDisconnect();
          if (!completer.isCompleted) completer.complete(false);
        },
        onDone: () {
          _handleDisconnect();
          if (!completer.isCompleted) completer.complete(false);
        },
        cancelOnError: true,
      );

      _connectTimeoutTimer?.cancel();
      _connectTimeoutTimer = Timer(const Duration(milliseconds: 400), () {
        if (_status == ConnectionStatus.connecting) {
          _sendRaw({'cmd': 'list'});
        }
      });

      _connectOverallTimeoutTimer?.cancel();
      _connectOverallTimeoutTimer = Timer(const Duration(seconds: 4), () {
        if (!completer.isCompleted) {
          if (_status == ConnectionStatus.connected) {
            completer.complete(true);
          } else {
            _handleDisconnect();
            completer.complete(false);
          }
        }
      });
    } catch (_) {
      _handleDisconnect();
      return false;
    }

    return completer.future;
  }

  void connectWebSocket() {
    if (_status == ConnectionStatus.connecting ||
        _status == ConnectionStatus.connected) {
      return;
    }
    connectWithResult();
  }

  void _handleDisconnect() {
    _connectTimeoutTimer?.cancel();
    _connectTimeoutTimer = null;
    _connectOverallTimeoutTimer?.cancel();
    _connectOverallTimeoutTimer = null;
    _status = ConnectionStatus.disconnected;
    _isPlaying = false;
    _activeNada = 0;
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
    for (final c in _songDetailCompleters.values) {
      if (!c.isCompleted) c.complete(null);
    }
    _songDetailCompleters.clear();
    notifyListeners();
  }

  void disconnect() {
    _channel?.sink.close();
    _handleDisconnect();
  }

  void _handleMessage(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final type = map['t'] as String?;

      if (type == 'list') {
        final list = map['songs'] as List<dynamic>? ?? [];
        if (list.isNotEmpty) {
          _songs = list
              .map((e) => SongModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
        notifyListeners();
      } else if (type == 'state') {
        final state = map['state'] as String?;
        if (state == 'playing') {
          _isPlaying = true;
          _playingSongId = map['id'] as int? ?? -1;
        } else {
          _isPlaying = false;
          _playingSongId = -1;
          _activeNada = 0;
        }
        notifyListeners();
      } else if (type == 'note') {
        _isPlaying = true;
        _activeNada = map['n'] as int? ?? 0;
        _currentNote = map['idx'] as int? ?? 0;
        _totalNotes = map['total'] as int? ?? 0;
        notifyListeners();
      } else if (type == 'song_detail') {
        final songId = map['id'] as int? ?? -1;
        final notesRaw = map['notes'] as List<dynamic>? ?? [];
        final noteItems = notesRaw.map((n) {
          final arr = n as List<dynamic>;
          return NoteItem(
            nada: arr[0] as int? ?? 0,
            panjang: arr[1] as int? ?? 4,
          );
        }).toList();
        if (_songDetailCompleters.containsKey(songId)) {
          if (!_songDetailCompleters[songId]!.isCompleted) {
            _songDetailCompleters[songId]!.complete(noteItems);
          }
          _songDetailCompleters.remove(songId);
        }
      } else if (type == 'ack') {
        _lastMessage = map['msg'] as String?;
        notifyListeners();
        fetchSongList();
      }
    } catch (_) {}
  }

  void _sendRaw(Map<String, dynamic> data) {
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode(data));
      } catch (_) {}
    }
  }

  void fetchSongList() => _sendRaw({'cmd': 'list'});
  void playSong(int id) => _sendRaw({'cmd': 'play', 'id': id});
  void stopPlayback() => _sendRaw({'cmd': 'stop'});
  void hitNada(int nada) => _sendRaw({'cmd': 'hit', 'n': nada});

  Future<List<NoteItem>?> getSongNotes(int id) async {
    if (!isConnected) return null;
    final completer = Completer<List<NoteItem>?>();
    _songDetailCompleters[id] = completer;
    _sendRaw({'cmd': 'get_notes', 'id': id});
    try {
      return await completer.future.timeout(const Duration(seconds: 3));
    } catch (_) {
      _songDetailCompleters.remove(id);
      return null;
    }
  }

  void addSong(String name, int tempo, List<List<int>> notes, String category) {
    _sendRaw({
      'cmd': 'add',
      'name': name,
      'tempo': tempo,
      'notes': notes,
      'cat': category,
    });
  }

  void editSong(
      int id, String name, int tempo, List<List<int>> notes, String category) {
    _sendRaw({
      'cmd': 'edit',
      'id': id,
      'name': name,
      'tempo': tempo,
      'notes': notes,
      'cat': category,
    });
  }

  void deleteSong(int id) => _sendRaw({'cmd': 'del', 'id': id});
  void resetDefaultSongs() => _sendRaw({'cmd': 'reset_defaults'});

  @override
  void dispose() {
    cancelTimers();
    _subscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
