import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/notification_model.dart';
import 'package:docdoc/features/home/domain/use_cases/notifications_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkAllNotificationsReadUseCase _markAllReadUseCase;

  NotificationsCubit(this._getNotificationsUseCase, this._markAllReadUseCase)
      : super(const NotificationsState.initial());

  Future<void> loadNotifications() async {
    emit(const NotificationsState.loading());
    final result = await _getNotificationsUseCase();
    switch (result) {
      case Success(:final data):
        emit(NotificationsState.loaded(notifications: data));
      case Failure(:final errMsg):
        emit(NotificationsState.error(message: errMsg));
    }
  }

  Future<void> markAllAsRead() async {
    await _markAllReadUseCase();
    final current = state.notifications;
    emit(NotificationsState.loaded(
      notifications: current.map((n) => n.copyWith(isRead: true)).toList(),
    ));
  }
}
