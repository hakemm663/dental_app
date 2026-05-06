import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:docdoc/features/inbox/domain/use_cases/inbox_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  ChatCubit(this._getMessagesUseCase, this._sendMessageUseCase)
      : super(const ChatState.initial());

  Future<void> loadMessages(int conversationId) async {
    emit(const ChatState.loading());
    final result = await _getMessagesUseCase(conversationId);
    switch (result) {
      case Success(:final data):
        emit(ChatState.loaded(messages: data));
      case Failure(:final errMsg):
        emit(ChatState.error(message: errMsg));
    }
  }

  Future<void> sendMessage(int conversationId, String text) async {
    final result = await _sendMessageUseCase(conversationId, text);
    switch (result) {
      case Success(:final data):
        emit(ChatState.loaded(
          messages: [...state.messages, data],
        ));
      case Failure():
        break;
    }
  }
}
