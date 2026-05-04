import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/notification_model.dart';
import 'package:docdoc/features/home/data/repos/notifications_repo.dart';

class GetNotificationsUseCase {
  final NotificationsRepo _repo;

  const GetNotificationsUseCase(this._repo);

  Future<ApiResult<List<NotificationModel>>> call() async {
    try {
      return Success(await _repo.getNotifications());
    } catch (error) {
      return Failure(error.toString());
    }
  }
}

class MarkAllNotificationsReadUseCase {
  final NotificationsRepo _repo;

  const MarkAllNotificationsReadUseCase(this._repo);

  Future<ApiResult<void>> call() async {
    try {
      await _repo.markAllAsRead();
      return const Success(null);
    } catch (error) {
      return Failure(error.toString());
    }
  }
}
