import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wifi_iot/wifi_iot.dart';
import '../models/song_model.dart';
import '../models/default_songs.dart';

enum ConnectionStatus { disconnected, connecting, connected }

class GamolanService extends ChangeNotifier {
  static final GamolanService _instance = GamolanService._internal();
  factory GamolanService() => _instance;
  GamolanService._internal() {
    _songs = List.from(DefaultSongs.list);
    _startAutoCheckTimer();
  }

  static const _wsAddress = '192.168.4.1:81';
  static const _apSsid = 'GamolanPekhing';
  static const _platformChannel =
      MethodChannel('com.gamolan.gamolan_pekhing/wifi');

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _connectTimer;
  Timer? _autoCheckTimer;

  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionStatus get status => _status;
  bool get isConnected => _status == ConnectionStatus.connected;

  String? _connectedSsid;
  String? get connectedSsid => _connectedSsid;

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

  void _startAutoCheckTimer() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_status == ConnectionStatus.disconnected) {
        final connected = await isWifiConnectedToGamolan();
        if (connected) {
          connectWebSocket();
        }
      }
    });
  }

  Future<bool> isWifiConnectedToGamolan() async {
    try {
      final ssid = await WiFiForIoTPlugin.getSSID();
      if (ssid == null) return false;
      final clean = ssid.replaceAll('"', '').trim();
      return clean == _apSsid;
    } catch (_) {
      return false;
    }
  }

  Future<void> openWifiManager() async {
    try {
      await _platformChannel.invokeMethod('openWifiManager');
    } catch (_) {
      try {
        await WiFiForIoTPlugin.setEnabled(true, shouldOpenSettings: true);
      } catch (e) {
        debugPrint('[WiFi] Gagal membuka settings: $e');
      }
    }
  }

  void connectWebSocket() {
    if (_status == ConnectionStatus.connecting ||
        _status == ConnectionStatus.connected) {
      return;
    }

    _status = ConnectionStatus.connecting;
    notifyListeners();

    try {
      final wsUrl = Uri.parse('ws://$_wsAddress');
      _channel = WebSocketChannel.connect(wsUrl);

      _subscription = _channel!.stream.listen(
        (data) {
          if (_status != ConnectionStatus.connected) {
            _status = ConnectionStatus.connected;
            _connectedSsid = _apSsid;
            notifyListeners();
            fetchSongList();
          }
          _handleMessage(data.toString());
        },
        onError: (_) => _handleDisconnect(),
        onDone: () => _handleDisconnect(),
        cancelOnError: true,
      );

      _connectTimer?.cancel();
      _connectTimer = Timer(const Duration(milliseconds: 300), () {
        if (_status == ConnectionStatus.connecting) {
          _sendRaw({'cmd': 'list'});
        }
      });
    } catch (_) {
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _connectTimer?.cancel();
    _connectTimer = null;
    _status = ConnectionStatus.disconnected;
    _isPlaying = false;
    _activeNada = 0;
    _connectedSsid = null;
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
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

  void addSong(String name, int tempo, List<List<int>> notes, String category) {
    _sendRaw({
      'cmd': 'add',
      'name': name,
      'tempo': tempo,
      'notes': notes,
      'cat': category,
    });
  }

  void deleteSong(int id) => _sendRaw({'cmd': 'del', 'id': id});

  @override
  void dispose() {
    _autoCheckTimer?.cancel();
    _connectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();
    super.dispose();
  }
}
