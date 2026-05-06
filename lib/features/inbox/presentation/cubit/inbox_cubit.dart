import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/domain/use_cases/inbox_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: unused_import — re-exported for the part file
export 'package:docdoc/features/home/data/models/doctor_model.dart';
export 'package:docdoc/features/inbox/data/models/conversation_model.dart';

part 'inbox_state.dart';

class InboxCubit extends Cubit<InboxState> {
  final GetConversationsUseCase _getConversationsUseCase;
  final SearchConversationsUseCase _searchConversationsUseCase;
  final GetDoctorsForNewMessageUseCase _getDoctorsForNewMessageUseCase;

  InboxCubit(
    this._getConversationsUseCase,
    this._searchConversationsUseCase,
    this._getDoctorsForNewMessageUseCase,
  ) : super(const InboxState.initial());

  Future<void> loadConversations() async {
    emit(const InboxState.loading());
    final result = await _getConversationsUseCase();
    switch (result) {
      case Success(:final data):
        emit(InboxState.loaded(conversations: data));
      case Failure(:final errMsg):
        emit(InboxState.error(message: errMsg));
    }
  }

  Future<void> searchConversations(String query) async {
    if (query.isEmpty) {
      return loadConversations();
    }
    final result = await _searchConversationsUseCase(query);
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(conversations: data, isLoading: false));
      case Failure(:final errMsg):
        emit(InboxState.error(message: errMsg));
    }
  }

  Future<void> loadDoctorsForNewMessage() async {
    final result = await _getDoctorsForNewMessageUseCase();
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(doctors: data));
      case Failure():
        break;
    }
  }
}
