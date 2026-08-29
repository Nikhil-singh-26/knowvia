abstract class AuthService {
  Future<bool> signIn();
  Future<void> signOut();
  String? get currentUserId;
  Stream<String?> get authStateChanges;
}

abstract class CloudStorageService {
  Future<void> uploadNote(Map<String, dynamic> noteData);
  Future<List<Map<String, dynamic>>> downloadNotes();
  Future<void> uploadAttachment(String filePath);
  Future<String?> downloadAttachment(String fileName);
}

class SyncManager {
  final AuthService auth;
  final CloudStorageService storage;

  SyncManager(this.auth, this.storage);

  Future<void> sync() async {
    if (auth.currentUserId == null) return;
    // Logic for sync conflict resolution and bidirectional sync goes here
  }
}
