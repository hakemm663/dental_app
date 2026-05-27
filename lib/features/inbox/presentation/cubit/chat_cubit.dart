import 'dart:async';

import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:docdoc/features/inbox/domain/use_cases/inbox_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final SendImageMessageUseCase _sendImageMessageUseCase;
  final SendAttachmentMessageUseCase _sendAttachmentMessageUseCase;

  StreamSubscription<List<MessageModel>>? _messagesSub;

  ChatCubit(
    this._getMessagesUseCase,
    this._sendMessageUseCase,
    this._sendImageMessageUseCase,
    this._sendAttachmentMessageUseCase,
  ) : super(const ChatState.initial());

  void loadMessages(String conversationId) {
    emit(const ChatState.loading());
    _messagesSub?.cancel();
    _messagesSub = _getMessagesUseCase(conversationId).listen(
      (messages) => emit(ChatState.loaded(messages: messages)),
      onError: (Object error) =>
          emit(ChatState.error(message: error.toString())),
    );
  }

  Future<void> sendMessage(String conversationId, String text) async {
    final result = await _sendMessageUseCase(conversationId, text);
    switch (result) {
      case Success():
        break;
      case Failure(:final errMsg):
        emit(state.copyWith(sendError: errMsg));
    }
  }

  Future<void> sendImageMessage(String conversationId, String imageUrl) async {
    final result = await _sendImageMessageUseCase(conversationId, imageUrl);
    switch (result) {
      case Success():
        break;
      case Failure(:final errMsg):
        emit(state.copyWith(sendError: errMsg));
    }
  }

  Future<void> sendAttachmentMessage(
    String conversationId,
    String fileUrl,
    String fileName,
    int fileSize,
  ) async {
    final result = await _sendAttachmentMessageUseCase(
      conversationId,
      fileUrl,
      fileName,
      fileSize,
    );
    switch (result) {
      case Success():
        break;
      case Failure(:final errMsg):
        emit(state.copyWith(sendError: errMsg));
    }
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
