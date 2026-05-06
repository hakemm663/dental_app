part of 'inbox_cubit.dart';

class InboxState {
  final List<ConversationModel> conversations;
  final List<DoctorModel> doctors;
  final bool isLoading;
  final String? errorMessage;

  const InboxState({
    required this.conversations,
    required this.doctors,
    required this.isLoading,
    this.errorMessage,
  });

  const InboxState.initial()
      : this(conversations: const [], doctors: const [], isLoading: false);

  const InboxState.loading()
      : this(conversations: const [], doctors: const [], isLoading: true);

  const InboxState.loaded({
    required List<ConversationModel> conversations,
    List<DoctorModel> doctors = const [],
  }) : this(conversations: conversations, doctors: doctors, isLoading: false);

  InboxState.error({required String message})
      : this(
          conversations: const [],
          doctors: const [],
          isLoading: false,
          errorMessage: message,
        );

  InboxState copyWith({
    List<ConversationModel>? conversations,
    List<DoctorModel>? doctors,
    bool? isLoading,
    String? errorMessage,
  }) =>
      InboxState(
        conversations: conversations ?? this.conversations,
        doctors: doctors ?? this.doctors,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
      );
}
