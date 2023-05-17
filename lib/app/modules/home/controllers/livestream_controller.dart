import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:twitch/app/modules/home/controllers/auth_controller.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/models/comments.dart';
import 'package:twitch/app/modules/home/models/livestream_model.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';
import 'package:twitch/app/modules/home/views/broad_cast_screen.dart';
import 'package:twitch/app/modules/home/widgets/loading_dialog.dart';
import 'package:twitch/app/services/db_services.dart';
import 'package:twitch/app/services/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class LiveStreamController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DatabaseServices db = DatabaseServices();
  UserController uc = Get.find<UserController>();

  Future<String> startLiveStream(
      {required String title, required File? image}) async {
    showLoadingDialog(message: 'Starting LiveStream');

    DocumentSnapshot snap = await db.liveStreamCollection
        .doc('${uc.user.uid}${uc.user.username}')
        .get();
    String channelId = '';
    try {
      if (!((await db.liveStreamCollection
              .doc('${uc.user.uid}${uc.user.username}')
              .get())
          .exists)) {
        String thumbnailUrl = await FirebaseStorageServices.uploadToStorage(
          folderName: 'livestream-thumbnails',
          file: image!,
          uid: uc.user.uid!,
        );
        channelId = '${uc.user.uid}${uc.user.username}';
        log(uc.user.username!);
        LiveStream liveStream = LiveStream(
          title: title,
          image: thumbnailUrl,
          uid: uc.user.uid!,
          username: uc.user.username!,
          viewers: 0,
          channelId: channelId,
          startedAt: DateTime.now(),
        );
        log(uc.user.username!);
        db.liveStreamCollection.doc(channelId).set(liveStream.toMap());
        hideLoadingDialog();
      } else {
        hideLoadingDialog();
        Get.snackbar('Error', 'Two Live Stream cannot start at one time');
      }
    } on FirebaseException catch (e) {
      Get.snackbar('Streaming Failed', e.toString());
    }
    return channelId;
  }

  Future<void> endLiveStream(String channelId) async {
    showLoadingDialog(message: 'Ending Live Stream');
    try {
      QuerySnapshot snap = await db.liveStreamCollection
          .doc(channelId)
          .collection('comments')
          .get();
      for (int i = 0; i < snap.docs.length; i++) {
        await db.liveStreamCollection
            .doc(channelId)
            .collection('comments')
            .doc(
              ((snap.docs[i].data()! as dynamic)['commentId']),
            )
            .delete();
      }
      await db.liveStreamCollection.doc(channelId).delete();
      hideLoadingDialog();
    } on Exception catch (e) {
      hideLoadingDialog();
      debugPrint(e.toString());
    }
  }

  Future<void> updateViewCount(
      {required String id, required bool isIncrease}) async {
    try {
      await db.liveStreamCollection
          .doc(id)
          .update({'viewers': FieldValue.increment(isIncrease ? 1 : -1)});
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> chat({required String text, required String id}) async {
    try {
      String commentId = const Uuid().v1();
      CommentsModel comments = CommentsModel(
          commentId: commentId,
          createdAt: DateTime.now(),
          message: text,
          ownerId: uc.user.uid,
          username: uc.user.username);
      await db.liveStreamCollection
          .doc(id)
          .collection('comments')
          .doc(commentId)
          .set(comments.toMap());
    } on FirebaseException catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Stream<List<CommentsModel>> getComment({required String channelId}) {
    return db.liveStreamCollection
        .doc(channelId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return CommentsModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  
}
