import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/notification_model.dart';
import 'package:docdoc/features/home/presentation/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) =>
                  _AppBar(unreadCount: state.unreadCount),
            ),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }
                  if (state.notifications.isEmpty) {
                    return Center(
                      child: Text(
                        'No notifications',
                        style: TextStyles.font14GrayRegular,
                      ),
                    );
                  }
                  return _NotificationList(notifications: state.notifications);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final int unreadCount;

  const _AppBar({required this.unreadCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          const _BackButton(),
          Expanded(
            child: Text(
              'Notification',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '$unreadCount NEW',
                style: TextStyles.font12GrayMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            SizedBox(width: 40.w),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.r,
            color: ColorsManager.darkBlue,
          ),
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const _NotificationList({required this.notifications});

  @override
  Widget build(BuildContext context) {
    // Group by today vs earlier
    final now = DateTime.now();
    final today = notifications
        .where((n) => _isToday(n.createdAt, now))
        .toList();
    final earlier = notifications
        .where((n) => !_isToday(n.createdAt, now))
        .toList();

    return ListView(
      children: [
        if (today.isNotEmpty) ...[
          _GroupHeader(
            label: 'Today',
            onMarkAll: () =>
                context.read<NotificationsCubit>().markAllAsRead(),
          ),
          ...today.map((n) => _NotificationTile(notification: n)),
        ],
        if (earlier.isNotEmpty) ...[
          _GroupHeader(label: 'Yesterday'),
          ...earlier.map((n) => _NotificationTile(notification: n)),
        ],
      ],
    );
  }

  bool _isToday(DateTime dt, DateTime now) =>
      dt.year == now.year && dt.month == now.month && dt.day == now.day;
}

class _GroupHeader extends StatelessWidget {
  final String label;
  final VoidCallback? onMarkAll;

  const _GroupHeader({required this.label, this.onMarkAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.font13GrayRegular),
          if (onMarkAll != null)
            GestureDetector(
              onTap: onMarkAll,
              child: Text(
                'Mark all as read',
                style: TextStyles.font13BlueSemiBold,
              ),
            ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: notification.isRead ? Colors.white : ColorsManager.lightBlue,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NotificationIcon(type: notification.type),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyles.font14DarkBlueBold,
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.body,
                  style: TextStyles.font13GrayRegular,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _relativeTime(notification.createdAt),
                style: TextStyles.font12GrayRegular,
              ),
              if (!notification.isRead) ...[
                SizedBox(height: 6.h),
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4D6D),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationType type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, bg) = switch (type) {
      NotificationType.appointmentSuccess => (
          Icons.calendar_today_outlined,
          const Color(0xFFE8F5E9),
        ),
      NotificationType.scheduleChanged => (
          Icons.calendar_month_outlined,
          ColorsManager.lightBlue,
        ),
      NotificationType.videoCall => (
          Icons.videocam_outlined,
          const Color(0xFFE8F5E9),
        ),
      NotificationType.appointmentCancelled => (
          Icons.calendar_today_outlined,
          const Color(0xFFFFEBEE),
        ),
      NotificationType.paymentAdded => (
          Icons.account_balance_wallet_outlined,
          ColorsManager.lightBlue,
        ),
      NotificationType.unknown => (
          Icons.notifications_outlined,
          ColorsManager.moreLighterGray,
        ),
    };

    final iconColor = switch (type) {
      NotificationType.appointmentSuccess => const Color(0xFF4CAF50),
      NotificationType.scheduleChanged => ColorsManager.mainBlue,
      NotificationType.videoCall => const Color(0xFF4CAF50),
      NotificationType.appointmentCancelled => const Color(0xFFF44336),
      NotificationType.paymentAdded => ColorsManager.mainBlue,
      NotificationType.unknown => ColorsManager.gray,
    };

    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22.r),
    );
  }
}
