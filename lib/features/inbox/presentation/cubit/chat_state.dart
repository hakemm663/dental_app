part of 'chat_cubit.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? errorMessage;

  const ChatState({
    required this.messages,
    required this.isLoading,
    this.errorMessage,
  });

  const ChatState.initial()
      : this(messages: const [], isLoading: false);

  const ChatState.loading()
      : this(messages: const [], isLoading: true);

  const ChatState.loaded({required List<MessageModel> messages})
      : this(messages: messages, isLoading: false);

  ChatState.error({required String message})
      : this(messages: const [], isLoading: false, errorMessage: message);
}
