import '../services/adguard_service.dart';

class ServerStore {
  static final List<AdGuardServer> servers = [];

  static void add(AdGuardServer server) {
    servers.add(server);
  }

  static void remove(AdGuardServer server) {
    servers.remove(server);
  }

  static int get onlineCount => servers.where((s) => s.isOnline).length;
  static int get offlineCount => servers.where((s) => !s.isOnline).length;
}
