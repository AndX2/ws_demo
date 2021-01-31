import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/service/message_service.dart';
import 'package:ws_demo/service/room_service.dart';
import 'package:ws_demo/ui/widget/chat_message.dart';
import 'package:ws_demo/ui/widget/room_header.dart';
import 'package:ws_demo/ui/widget/screen_back.dart';
import 'package:ws_demo/util/style.dart';
import 'package:ws_demo/util/ui_util.dart';

const _onMessageScrollDelay = Duration(milliseconds: 33);
const _autoScrollSpeed = Duration(milliseconds: 400);

///View
class RoomScreenWidget extends CoreMwwmWidget {
  final String roomName;
  RoomScreenWidget({
    Key key,
    @required this.roomName,
  }) : super(
          widgetModelBuilder: (context) {
            return RoomModel(
              WidgetModelDependencies(),
              roomName,
              Navigator.of(context),
            );
          },
        );

  @override
  State<StatefulWidget> createState() => _RoomWidgetState(roomName);
}

class _RoomWidgetState extends WidgetState<RoomModel> {
  final String roomName;

  _RoomWidgetState(this.roomName);

  @override
  Widget build(BuildContext context) {
    return ScreenBackWidget(
      child: Scaffold(
        key: wm.scaffoldKey,
        backgroundColor: Colors.transparent,
        body: StreamedStateBuilder<Profile>(
            streamedState: wm.profileState,
            builder: (context, profile) {
              return EntityStateBuilder<List<Message>>(
                  streamedState: wm.messageListState,
                  loadingChild: Center(child: CircularProgressIndicator()),
                  child: (context, list) {
                    return Stack(
                      children: [
                        Column(
                          children: [
                            _buildMessageList(context, list, profile),
                            _buildInputFooter(context),
                          ],
                        ),
                        _buildHeader(context),
                      ],
                    );
                  });
            }),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return RoomHeaderWidget(
      child: Text(
        roomName,
        maxLines: 2,
        style: context.sp(StyleRes.head36Red),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, List<Message> list, Profile profile) {
    return Expanded(
      child: ListView.builder(
        controller: wm.scrollController,
        padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(context).padding.top + 72.0, 16.0, 8.0),
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (_, index) => ChatMessageWidget(
          key: list[index].key,
          message: list[index],
          owner: list[index].owner(profile),
        ),
      ),
    );
  }

  Widget _buildInputFooter(BuildContext context) {
    return ScreenBackWidget(
        child: Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(width: 16.0),
            Expanded(
              child: TextField(
                controller: wm.inputMessageController,
                style: context.sp(StyleRes.content24Blue),
                cursorColor: ColorRes.textBlue,
                maxLines: 4,
                minLines: 1,
              ),
            ),
            StreamedStateBuilder<bool>(
                streamedState: wm.shippingStageState,
                builder: (context, disabled) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: ColorRes.textBlue,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.send,
                          size: context.sw600 ? 32.0 : 56.0,
                          color: !disabled ? ColorRes.textBlue : ColorRes.textBlue.withOpacity(.1),
                        ),
                      ),
                      onTap: !disabled ? wm.sendAction : null,
                    ),
                  );
                })
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: Divider(
              color: ColorRes.textRed,
              height: 1.0,
              thickness: 1.0,
            ),
          ),
        )
      ],
    ));
  }
}

/// [RoomModel] для [Room]
class RoomModel extends WidgetModel {
  /// пришедшие данные извне
  final String roomName;
  final NavigatorState _rootNavigator;
  final RoomService _roomService;
  final MessageService _messageService;

  RoomModel(
    WidgetModelDependencies dependencies,
    this.roomName,
    this._rootNavigator,
  )   : _roomService = getIt.get<RoomService>(),
        _messageService = getIt.get<MessageService>(),
        super(dependencies);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final messageListState = EntityStreamedState<List<Message>>()..loading();
  final profileState = StreamedState<Profile>();
  final inputMessageController = TextEditingController();
  final sendAction = Action<void>();
  final shippingStageState = StreamedState<bool>(false);

  @override
  void onLoad() {
    super.onLoad();
    _init();
    subscribe<List<Room>>(_roomService.roomListObservable.stream, _onRoomList);
  }

  @override
  void onBind() {
    super.onBind();
    subscribe<void>(sendAction.stream, _sendMessage);
  }

  void _sendMessage(_) async {
    final text = inputMessageController.text;
    if (text.length == 0) return;
    shippingStageState.accept(true);
    bool isSuccess = true;
    await _messageService.sendMessage(Room(roomName), text).catchError(
      (error) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text('Произошла ошибка, попробуйте позже', style: StyleRes.content24Yellow),
          ),
        );
        isSuccess = false;
      },
    );
    if (isSuccess) inputMessageController.clear();
    shippingStageState.accept(false);
  }

  void _init() {
    profileState.accept(_messageService.getProfile());
    _roomService.getRoomHistory(Room(roomName)).catchError(
          // (error) => messageListState.error(error),
          (error) => print(error),
        );
  }

  void _onRoomList(List<Room> list) {
    final messageList = list.firstWhere((room) => room.name == roomName, orElse: () => null)?.messageList;
    messageList?.sort();
    messageListState.content(messageList ?? List<Message>());
    _scrollToEnd();
  }

  void _scrollToEnd() async {
    //FixMe: костыль. Время передачи состояния scrollController = 2 такта (16 * 2 ms)
    await Future.delayed(_onMessageScrollDelay);
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: _autoScrollSpeed,
      curve: Curves.easeInOut,
    );
  }
}
