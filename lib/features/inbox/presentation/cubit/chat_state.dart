part of 'chat_cubit.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? errorMessage;
  final String? sendError;

  const ChatState({
    required this.messages,
    required this.isLoading,
    this.errorMessage,
    this.sendError,
  });

  const ChatState.initial()
      : this(messages: const [], isLoading: false);

  const ChatState.loading()
      : this(messages: const [], isLoading: true);

  const ChatState.loaded({required List<MessageModel> messages})
      : this(messages: messages, isLoading: false);

  ChatState.error({required String message})
      : this(messages: const [], isLoading: false, errorMessage: message);

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? errorMessage,
    String? sendError,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        sendError: sendError,
      );
}
