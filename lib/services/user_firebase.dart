import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/models/user_entity.dart';
import 'dart:developer';

class UserFirebase {
  final db = FirebaseFirestore.instance;

  /// Get all users registerd
  Future<List<Map<String, dynamic>>> all() async {
    log('Get all users in database...');
    return db
        .collection('users')
        .orderBy('email')
        .limit(20)
        .get()
        .then((snapshot) {
      List<Map<String, dynamic>> list = [];
      for (final doc in snapshot.docs) {
        final obj = doc.data();
        final user = Map<String, dynamic>.from(obj);
        user['id'] = doc.id;
        list.add(user);
      }
      return list;
    });
  }

  /// Insert a new user into database
  Future<UserEntity> insert(UserEntity user) async {
    log('insert a user into database...');
    final docRef = await db.collection('users').add(user.toJson());
    return UserEntity(
        id: docRef.id,
        email: user.email,
        password: user.password,
        image: user.image,
        address: user.address);
  }

  /// Update profile
  Future<void> updateProfile(UserEntity user) async {
    log('update user profile...');
    return db.collection('users').doc(user.id).set(user.toJson());
  }
}
