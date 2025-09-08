import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupon_place/src/features/coupon/model/coupon.dart';
import 'package:coupon_place/src/features/folder/model/folder.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User get _user => FirebaseAuth.instance.currentUser!;

  /// users/{uid}/folders
  CollectionReference get _userFolders =>
      _firestore.collection('users').doc(_user.uid).collection('folders');

  /// users/{uid}/coupons
  CollectionReference get _userCoupons =>
      _firestore.collection('users').doc(_user.uid).collection('coupons');

  /// 폴더 추가
  Future<void> addFolderToFirestore(Folder folder) async {
    await _userFolders.doc(folder.id).set({
      ...folder.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 폴더 목록 조회
  Future<List<Folder>> getFoldersFromFirestore() async {
    final querySnapshot = await _userFolders.get();
    return querySnapshot.docs
        .map((doc) => Folder.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// 폴더 삭제 + 해당 폴더 쿠폰 삭제
  Future<void> removeFolder(String folderId) async {
    // 1. 폴더 문서 삭제
    final folderSnapshot =
        await _userFolders.where('id', isEqualTo: folderId).limit(1).get();
    if (folderSnapshot.docs.isNotEmpty) {
      await folderSnapshot.docs.first.reference.delete();
    }

    // 2. 해당 폴더에 속한 쿠폰 삭제
    final couponsSnapshot =
        await _userCoupons.where('folderId', isEqualTo: folderId).get();

    for (final doc in couponsSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  /// 쿠폰 추가 (folderId 포함)
  Future<void> addCouponToFirestore(Coupon coupon) async {
    await _userCoupons.doc(coupon.id).set({
      ...coupon.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// 쿠폰 업데이트 (일부 필드 변경 가능)
  Future<void> updateCouponInFirestore(Coupon coupon) async {
    await _userCoupons.doc(coupon.id).update({
      ...coupon.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 특정 폴더 쿠폰 가져오기
  Future<List<Coupon>> getCouponsFromFirestore(String folderId) async {
    final querySnapshot =
        await _userCoupons.where('folderId', isEqualTo: folderId).get();

    return querySnapshot.docs
        .map((doc) => Coupon.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// 전체 쿠폰 가져오기 (검색, 필터 용도)
  Future<List<Coupon>> getAllCouponsFromFirestore() async {
    final querySnapshot = await _userCoupons.get();
    return querySnapshot.docs
        .map((doc) => Coupon.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// 쿠폰 삭제 (폴더 상세 or 전체 보기 모두 가능)
  Future<void> removeCoupon(String couponId) async {
    final docSnapshot = await _userCoupons.doc(couponId).get();
    if (docSnapshot.exists) {
      await docSnapshot.reference.delete();
    }
  }
}
