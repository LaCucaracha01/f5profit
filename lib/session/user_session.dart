class UserSession {
  static int? currentUserId;

  static void setUserId(int id) {
    currentUserId = id;
  }

  static void clear() {
    currentUserId = null;
  }
}
