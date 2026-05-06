import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:docdoc/features/inbox/data/repos/inbox_repo.dart';

class GetConversationsUseCase {
  final InboxRepo _repo;

  const GetConversationsUseCase(this._repo);

  Future<ApiResult<List<ConversationModel>>> call() async {
    try {
      return Success(await _repo.getConversations());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class SearchConversationsUseCase {
  final InboxRepo _repo;

  const SearchConversationsUseCase(this._repo);

  Future<ApiResult<List<ConversationModel>>> call(String query) async {
    try {
      return Success(await _repo.searchConversations(query));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class GetMessagesUseCase {
  final InboxRepo _repo;

  const GetMessagesUseCase(this._repo);

  Future<ApiResult<List<MessageModel>>> call(int conversationId) async {
    try {
      return Success(await _repo.getMessages(conversationId));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class SendMessageUseCase {
  final InboxRepo _repo;

  const SendMessageUseCase(this._repo);

  Future<ApiResult<MessageModel>> call(int conversationId, String text) async {
    try {
      return Success(await _repo.sendMessage(conversationId, text));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class GetDoctorsForNewMessageUseCase {
  final InboxRepo _repo;

  const GetDoctorsForNewMessageUseCase(this._repo);

  Future<ApiResult<List<DoctorModel>>> call() async {
    try {
      return Success(await _repo.getDoctorsForNewMessage());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
