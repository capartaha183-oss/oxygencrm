import 'dart:convert';
import 'package:http/http.dart' as http;

class AdGuardServer {
  final String id;
  final String name;
  final String ip;
  final int port;
  final String username;
  final String password;
  bool isOnline;
  String? _sessionCookie;

  AdGuardServer({
    required this.id,
    required this.name,
    required this.ip,
    required this.port,
    required this.username,
    required this.password,
    this.isOnline = false,
  });

  String get baseUrl => 'http://$ip:$port';

  Map<String, String> get headers {
    final h = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_sessionCookie != null) {
      h['Cookie'] = _sessionCookie!;
    }
    return h;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'ip': ip,
    'port': port,
    'username': username,
    'password': password,
  };

  factory AdGuardServer.fromJson(Map<String, dynamic> j) => AdGuardServer(
    id: j['id'],
    name: j['name'],
    ip: j['ip'],
    port: j['port'],
    username: j['username'],
    password: j['password'],
  );
}

class AdGuardStats {
  final int totalQueries;
  final int blockedQueries;
  final double blockedPercent;
  final int avgProcessingTime;

  AdGuardStats({
    required this.totalQueries,
    required this.blockedQueries,
    required this.blockedPercent,
    required this.avgProcessingTime,
  });

  factory AdGuardStats.fromJson(Map<String, dynamic> j) => AdGuardStats(
    totalQueries: j['num_dns_queries'] ?? 0,
    blockedQueries: j['num_blocked_filtering'] ?? 0,
    blockedPercent: (j['num_blocked_filtering'] ?? 0) /
        (j['num_dns_queries'] == 0 ? 1 : j['num_dns_queries']) * 100,
    avgProcessingTime: ((j['avg_processing_time'] ?? 0) * 1000).toInt(),
  );
}

class AdGuardService {
  // Önce login yap, session cookie al
  static Future<bool> _login(AdGuardServer server) async {
    try {
      final res = await http.post(
        Uri.parse('${server.baseUrl}/control/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': server.username,
          'password': server.password,
        }),
      ).timeout(const Duration(seconds: 5));

      if (res.statusCode == 200) {
        // Session cookie'yi kaydet
        final cookie = res.headers['set-cookie'];
        if (cookie != null) {
          server._sessionCookie = cookie.split(';').first;
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> checkStatus(AdGuardServer server) async {
    try {
      // Önce login ol
      final loggedIn = await _login(server);
      if (!loggedIn) return false;

      final res = await http.get(
        Uri.parse('${server.baseUrl}/control/status'),
        headers: server.headers,
      ).timeout(const Duration(seconds: 5));

      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<AdGuardStats?> getStats(AdGuardServer server) async {
    try {
      final res = await http.get(
        Uri.parse('${server.baseUrl}/control/stats'),
        headers: server.headers,
      ).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        return AdGuardStats.fromJson(jsonDecode(res.body));
      }
    } catch (_) {}
    return null;
  }

  static Future<List<String>> getClients(AdGuardServer server) async {
    try {
      final res = await http.get(
        Uri.parse('${server.baseUrl}/control/clients'),
        headers: server.headers,
      ).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final clients = data['clients'] as List? ?? [];
        return clients.map((c) => c['name']?.toString() ?? c['ids']?[0]?.toString() ?? '').toList();
      }
    } catch (_) {}
    return [];
  }

  static Future<bool> sendCommand(AdGuardServer server, String command) async {
    try {
      String endpoint = '';
      switch (command) {
        case 'restart': endpoint = '/control/restart'; break;
        case 'flush_dns': endpoint = '/control/cache/clear'; break;
      }
      final res = await http.post(
        Uri.parse('${server.baseUrl}$endpoint'),
        headers: server.headers,
      ).timeout(const Duration(seconds: 10));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getFilters(AdGuardServer server) async {
    try {
      final res = await http.get(
        Uri.parse('${server.baseUrl}/control/filtering/status'),
        headers: server.headers,
      ).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final filters = data['filters'] as List? ?? [];
        return filters.cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return [];
  }
}
