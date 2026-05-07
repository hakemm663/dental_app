import 'package:docdoc/core/networking/api_error_handler.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:docdoc/features/inbox/data/repos/firebase_chat_repo.dart';

class GetConversationsUseCase {
  final FirebaseChatRepo _repo;

  const GetConversationsUseCase(this._repo);

  Stream<List<ConversationModel>> call() => _repo.getConversationsStream();
}

class SearchConversationsUseCase {
  final FirebaseChatRepo _repo;

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
  final FirebaseChatRepo _repo;

  const GetMessagesUseCase(this._repo);

  Stream<List<MessageModel>> call(String conversationId) =>
      _repo.getMessagesStream(conversationId);
}

class SendMessageUseCase {
  final FirebaseChatRepo _repo;

  const SendMessageUseCase(this._repo);

  Future<ApiResult<MessageModel>> call(
      String conversationId, String text) async {
    try {
      return Success(await _repo.sendMessage(conversationId, text));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class SendImageMessageUseCase {
  final FirebaseChatRepo _repo;

  const SendImageMessageUseCase(this._repo);

  Future<ApiResult<MessageModel>> call(
      String conversationId, String imageUrl) async {
    try {
      return Success(await _repo.sendImageMessage(conversationId, imageUrl));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class SendAttachmentMessageUseCase {
  final FirebaseChatRepo _repo;

  const SendAttachmentMessageUseCase(this._repo);

  Future<ApiResult<MessageModel>> call(
    String conversationId,
    String fileUrl,
    String fileName,
    int fileSize,
  ) async {
    try {
      return Success(await _repo.sendAttachmentMessage(
          conversationId, fileUrl, fileName, fileSize));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class GetDoctorsForNewMessageUseCase {
  final FirebaseChatRepo _repo;

  const GetDoctorsForNewMessageUseCase(this._repo);

  Future<ApiResult<List<DoctorModel>>> call() async {
    try {
      return Success(await _repo.getDoctorsForNewMessage());
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}

class GetOrCreateConversationUseCase {
  final FirebaseChatRepo _repo;

  const GetOrCreateConversationUseCase(this._repo);

  Future<ApiResult<ConversationModel>> call(DoctorModel doctor) async {
    try {
      return Success(await _repo.getOrCreateConversation(doctor));
    } catch (error) {
      return Failure(ApiErrorHandler.handle(error));
    }
  }
}
