class AuthService {
  static String? currentUser;
  static DateTime? loginTime;
  static int loginCount = 0;
  static DateTime? lastLoginTime;

  static void login(String username) {
    currentUser = username;
    loginTime = DateTime.now();
    loginCount++;
    lastLoginTime = DateTime.now();
  }

  static void logout() {
    currentUser = null;
    loginTime = null;
  }

  static String get sessionDuration {
    if (loginTime == null) return '-';
    final diff = DateTime.now().difference(loginTime!);
    if (diff.inHours > 0) return '${diff.inHours}s ${diff.inMinutes % 60}dk';
    if (diff.inMinutes > 0) return '${diff.inMinutes} dakika';
    return '${diff.inSeconds} saniye';
  }

  static String get lastLoginFormatted {
    if (lastLoginTime == null) return '-';
    return '${lastLoginTime!.day.toString().padLeft(2, '0')}.'
        '${lastLoginTime!.month.toString().padLeft(2, '0')}.'
        '${lastLoginTime!.year} '
        '${lastLoginTime!.hour.toString().padLeft(2, '0')}:'
        '${lastLoginTime!.minute.toString().padLeft(2, '0')}';
  }
}
