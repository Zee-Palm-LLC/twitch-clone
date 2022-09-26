import 'dart:convert';
import 'dart:developer';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:twitch/app/data/constants/constants.dart';
import 'package:twitch/app/modules/home/controllers/livestream_controller.dart';
import 'package:twitch/app/modules/home/controllers/user_controller.dart';
import 'package:twitch/app/modules/home/models/user_model.dart';
import 'package:twitch/app/modules/home/views/home_screen.dart';
import 'package:twitch/app/modules/home/widgets/chat.dart';
import 'package:twitch/config/appId.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:http/http.dart' as http;

class BroadCastScreen extends StatefulWidget {
  bool isBroadCaster;
  String channelId;
  BroadCastScreen(
      {Key? key, required this.isBroadCaster, required this.channelId})
      : super(key: key);

  @override
  State<BroadCastScreen> createState() => _BroadCastScreenState();
}

class _BroadCastScreenState extends State<BroadCastScreen> {
  late final RtcEngine _engine;
  List<int> remoteUid = [];
  bool switchCamera = true;
  bool isMuted = false;
  UserModel user = Get.find<UserController>().user;
  var lc = Get.find<LiveStreamController>();
  @override
  void initState() {
    _initEngine();
    super.initState();
  }

  void _initEngine() async {
    _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    _engine.setClientRole(
        widget.isBroadCaster ? ClientRole.Broadcaster : ClientRole.Audience);
    _addListener();
    _joinChannel();
  }

  String baseUrl = 'https://twitch-tutorial.herokuapp.com/';
  String? token;

  Future<void> getToken() async {
    final res = await http.get(
      // ignore: prefer_interpolation_to_compose_strings
      Uri.parse(baseUrl +
          '/rtc/' +
          widget.channelId +
          '/publisher/userAccount/' +
          user.uid! +
          '/'),
    );

    if (res.statusCode == 200) {
      setState(() {
        token = res.body;
        token = jsonDecode(token!)['rtcToken'];
      });
    } else {
      debugPrint('Failed to fetch the token');
    }
  }

  void _addListener() {
    _engine.setEventHandler(
        RtcEngineEventHandler(joinChannelSuccess: ((channel, uid, elapsed) {
      debugPrint('Joined Success $channel,$uid,$elapsed');
    }), userJoined: (uid, elapsed) {
      debugPrint('User Joined,$uid,$elapsed');
      remoteUid.add(uid);
    }, userOffline: (uid, reason) {
      debugPrint('Reason $uid,$reason');
      setState(() {
        remoteUid.removeWhere((element) => element == uid);
      });
    }, leaveChannel: (stats) {
      debugPrint('Stats $stats');
      setState(() {
        remoteUid.clear();
      });
    }, tokenPrivilegeWillExpire: (token) async {
      await getToken();
      await _engine.renewToken(token);
    }));
  }

  _joinChannel() async {
    await getToken();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.camera, Permission.microphone].request();
    }
    await _engine.joinChannelWithUserAccount(
        token, 'testing123', Get.find<UserController>().user.uid!);
  }

  _leaveChannel() async {
    await _engine.leaveChannel();
    if ('${user.uid}${user.username}' == widget.channelId) {
      await lc.endLiveStream(widget.channelId);
    } else {
      await lc.updateViewCount(id: widget.channelId, isIncrease: false);
    }
    Get.to(() => const HomeScreen());
  }

  void _switchCamera() {
    _engine.switchCamera().then((value) {
      setState(() {
        switchCamera = !switchCamera;
      });
    }).catchError((error) {
      print(error);
    });
  }

  void onToogleMute() async {
    setState(() {
      isMuted = !isMuted;
    });
    await _engine.muteLocalAudioStream(isMuted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _leaveChannel();
        return Future.value(true);
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(8.h),
          child: Column(
            children: [
              _renderVideo(user, true),
              if ('${user.uid}${user.username}' == widget.channelId)
                Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: onToogleMute,
                        child: Text(isMuted ? 'UnMute' : 'Mute',
                            style: CustomTextStyle.kMedium16),
                      ),
                    ]),
              Expanded(child: Chat(channelId: widget.channelId))
            ],
          ),
        ),
      ),
    );
  }

  _renderVideo(user, isScreenSharing) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: "${user.uid}${user.username}" == widget.channelId
          ? isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.TextureView.screenShare()
              : const RtcLocalView.SurfaceView(
                  zOrderMediaOverlay: true,
                  zOrderOnTop: true,
                )
          : isScreenSharing
              ? kIsWeb
                  ? const RtcLocalView.SurfaceView.screenShare()
                  : const RtcLocalView.TextureView.screenShare()
              : remoteUid.isNotEmpty
                  ? kIsWeb
                      ? RtcRemoteView.SurfaceView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                      : RtcRemoteView.TextureView(
                          uid: remoteUid[0],
                          channelId: widget.channelId,
                        )
                  : Container(),
    );
  }
}
