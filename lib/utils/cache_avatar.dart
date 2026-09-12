class ZegoAvatarCache {
  ZegoAvatarCache._();

  static final Map<String, String> _photoUrls = {};

  static void set(String uid, String photoUrl) {
    if (photoUrl.isNotEmpty) {
      _photoUrls[uid] = photoUrl;
    }
  }

  static void setAll(Map<String, String> entries) {
    _photoUrls.addAll(entries);
  }

  static String? get(String? uid) {
    if (uid == null) return null;
    return _photoUrls[uid];
  }
}