import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_place/src/features/coupon/provider/folder_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User get _user => FirebaseAuth.instance.currentUser!;

  CollectionReference get _userFolders =>
      _firestore.collection('users').doc(_user.uid).collection('folders');

  Future<void> addFolderToFirestore(Folder folder) async {
    await _userFolders.add({
      ...folder.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
