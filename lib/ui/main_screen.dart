import 'package:flutter/material.dart' hide Action;
import 'package:mwwm/mwwm.dart';
import 'package:relation/relation.dart';

import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/router.dart';
import 'package:ws_demo/service/message_service.dart';
import 'package:ws_demo/service/room_service.dart';
import 'package:ws_demo/ui/widget/bs_input.dart';
import 'package:ws_demo/ui/widget/primary_btn.dart';
import 'package:ws_demo/ui/widget/screen_back.dart';
import 'package:ws_demo/ui/widget/simple_card.dart';
import 'package:ws_demo/util/style.dart';
import 'package:ws_demo/util/ui_util.dart';

/// Главный экран (список каналов)
class MainScreenWidget extends CoreMwwmWidget {
  MainScreenWidget({
    Key key,
  }) : super(
          widgetModelBuilder: (context) => MainScreenModel(
            WidgetModelDependencies(),
            Navigator.of(context),
          ),
        );

  @override
  State<StatefulWidget> createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends WidgetState<MainScreenModel> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (wm.addChannelShownState.value) {
          wm.onBackAction();
          return false;
        } else {
          return true;
        }
      },
      child: ScreenBackWidget(
        child: Scaffold(
          key: wm.scaffoldKey,
          backgroundColor: Colors.transparent,
          body: EntityStateBuilder<List<Room>>(
            streamedState: wm.roomListState,
            loadingChild: Center(child: CircularProgressIndicator()),
            child: (ctx, list) => _buildRoomListView(ctx, list, context),
          ),
          floatingActionButton: _buildFab(context),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return StreamedStateBuilder<bool>(
        streamedState: wm.addChannelShownState,
        builder: (context, addChannel) {
          return EntityStateBuilder<List<Room>>(
            streamedState: wm.roomListState,
            loadingChild: Container(),
            child: (_, __) => Container(
              constraints: BoxConstraints(
                maxWidth: context.sw600 ? 48.0 : 72.0,
                maxHeight: context.sw600 ? 48.0 : 72.0,
              ),
              child: SimpleCard(
                  onPressed: () {
                    wm.addMessageAction();
                  },
                  padding: EdgeInsets.zero,
                  child: Icon(
                    addChannel ? Icons.add : Icons.edit_outlined,
                    size: context.sw600 ? 36.0 : 48.0,
                    color: ColorRes.textBlue,
                  )),
            ),
          );
        });
  }

  Widget _buildRoomListView(BuildContext ctx, List<Room> list, BuildContext context) {
    return Column(
      children: [
        StreamedStateBuilder<bool>(
          streamedState: wm.addChannelShownState,
          builder: (_, isShow) {
            return AnimatedContainer(
              key: ValueKey('addChannelBlock'),
              duration: Duration(milliseconds: 4000),
              child: isShow
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: ColorRes.splashBlue,
                        onTap: wm.addMessageAction,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(ctx).padding.top + 16.0, 16.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_box_rounded,
                                    color: ColorRes.textBlue,
                                    size: context.sw600 ? 36.0 : 48.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Text(
                                    'Выберите канал или создайте новый',
                                    style: context.sp(StyleRes.content24Blue),
                                  ),
                                ],
                              ),
                              Divider(color: ColorRes.textRed, thickness: .7, height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            );
          },
        ),
        Expanded(
          child: ListView(
            physics: BouncingScrollPhysics(),
            controller: wm.scrollController,
            padding: EdgeInsets.fromLTRB(16.0, MediaQuery.of(ctx).padding.top, 16.0, 16.0),
            children: list.map<Widget>((room) {
              final lastMessage = room.lastMessage;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: PrimaryBtn.regular(
                  key: ValueKey('${room.name}#${room.lastMessage.created}'),
                  onPressed: () => wm.onRoomSelectedAction(room),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.sp(StyleRes.head24Red),
                      ),
                      SizedBox(height: 4.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${lastMessage.sender.username}:',
                              style: context.sp(StyleRes.content20Blue.copyWith(decoration: TextDecoration.underline)),
                            ),
                            TextSpan(
                              text: '  ${lastMessage.text}',
                              style: context.sp(StyleRes.content16Blue),
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// [MainScreenModel] для [MainScreen]
class MainScreenModel extends WidgetModel {
  final NavigatorState _rootNavigator;
  final RoomService _roomService;
  final MessageService _messageService;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final bsFormKey = GlobalKey<FormState>();

  MainScreenModel(
    WidgetModelDependencies baseDependencies,
    this._rootNavigator,
  )   : _roomService = getIt.get<RoomService>(),
        _messageService = getIt.get<MessageService>(),
        super(baseDependencies);

  final scrollController = ScrollController();
  final roomListState = EntityStreamedState<List<Room>>()..loading();
  final addMessageAction = Action<void>();
  final addChannelShownState = StreamedState<bool>(false);
  final onBackAction = Action<void>();
  final onRoomSelectedAction = Action<Room>();
  final bsNameInputAction = Action<void>();
  final bsAddRoomAction = Action<void>();
  final bsTextFieldController = TextEditingController();

  @override
  void onLoad() {
    super.onLoad();
    _init();
    subscribe<List<Room>>(_roomService.roomListObservable.stream, _onRoomList);
    _messageService.subscribe();
  }

  @override
  void onBind() {
    super.onBind();
    subscribe<void>(onBackAction.stream, (_) => addChannelShownState.accept(false));
    subscribe<void>(addMessageAction.stream, _onAddMessageAction);
    subscribe<void>(bsNameInputAction.stream, _onBsNameAction);
    subscribe<void>(bsAddRoomAction.stream, _onAddRoom);
    subscribe<Room>(onRoomSelectedAction.stream, _onRoomSelected);
  }

  bool _isAutorized() {
    final profile = _messageService.getProfile();
    if (profile.userName == null || profile.userName.isEmpty) {
      bsTextFieldController.text = '';
      _createProfile();
      return false;
    } else
      return true;
  }

  void _onRoomSelected(Room room) {
    if (!_isAutorized()) return;
    _rootNavigator.pushNamed(Routes.room, arguments: {Routes.roomName: room.name});
  }

  void _onBsNameAction(_) {
    if (bsFormKey.currentState.validate()) {
      final name = bsTextFieldController.text;
      _messageService.setProfile(Profile(name));
      Navigator.of(scaffoldKey.currentContext).pop();
    }
  }

  void _onAddMessageAction(_) async {
    if (!_isAutorized()) return;
    if (!addChannelShownState.value) {
      addChannelShownState.accept(true);
      return;
    }
    _createRoom();
  }

  void _onAddRoom(_) {
    if (bsFormKey.currentState.validate()) {
      final roomName = bsTextFieldController.text;
      bsTextFieldController.clear();
      Navigator.of(scaffoldKey.currentContext).pop();
      _rootNavigator.pushNamed(Routes.room, arguments: {Routes.roomName: roomName});
    }
  }

  void _createRoom() async {
    scaffoldKey.currentState.showBottomSheet<Profile>(
      (context) => BsContent(
        formKey: bsFormKey,
        onPressed: bsAddRoomAction,
        textEditingController: bsTextFieldController,
        hint: 'Название нового канала',
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _createProfile() async {
    scaffoldKey.currentState.showBottomSheet<Profile>(
      (context) => BsContent(
        formKey: bsFormKey,
        onPressed: bsNameInputAction,
        textEditingController: bsTextFieldController,
        hint: 'Ваше имя',
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void _init() {
    _roomService.getRoomList().catchError((error) => roomListState.error(error));
  }

  void _onRoomList(List<Room> list) {
    final sortedList = List<Room>.from(list)..sort();

    roomListState.content(sortedList.reversed.toList());
  }
}
