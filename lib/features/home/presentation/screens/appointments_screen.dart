import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/widgets/upcoming_appointment_card.dart';
import 'package:docdoc/features/home/presentation/widgets/completed_appointment_card.dart';
import 'package:docdoc/features/home/presentation/widgets/cancelled_appointment_card.dart';
import 'package:docdoc/features/home/presentation/widgets/cancel_appointment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<AppointmentCubit>().getAllAppointments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AppointmentModel> _filterByStatus(
    List<AppointmentModel> all,
    String status,
  ) {
    return all.where((a) => a.status == status).toList();
  }

  void _onCancel(AppointmentModel appointment) async {
    final confirmed = await CancelAppointmentDialog.show(context);
    if (confirmed == true && mounted) {
      context.read<AppointmentCubit>().cancelAppointment(appointment.id);
    }
  }

  void _onReschedule(AppointmentModel appointment) {
    Navigator.of(context).pushNamed(
      Routes.rescheduleAppointment,
      arguments: appointment,
    );
  }

  void _onChat(AppointmentModel appointment) {
    final doctor = appointment.doctor;
    if (doctor == null) return;
    Navigator.of(context).pushNamed(Routes.inboxScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppointmentsAppBar(
              onBack: () => Navigator.of(context).pop(),
              onSearch: () {},
            ),
            _buildTabBar(),
            Expanded(
              child: BlocConsumer<AppointmentCubit, AppointmentState>(
                listenWhen: (prev, curr) =>
                    prev.cancelledAppointmentId != curr.cancelledAppointmentId,
                buildWhen: (prev, curr) =>
                    prev.appointments != curr.appointments ||
                    prev.isLoading != curr.isLoading ||
                    prev.errorMessage != curr.errorMessage,
                listener: (context, state) {
                  if (state.cancelledAppointmentId != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Appointment cancelled'),
                        backgroundColor: Color(0xFF22C55E),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null && state.appointments.isEmpty) {
                    return _ErrorView(
                      message: state.errorMessage!,
                      onRetry: () =>
                          context.read<AppointmentCubit>().getAllAppointments(),
                    );
                  }
                  final appointments = state.appointments;
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _AppointmentsList(
                        appointments: _filterByStatus(appointments, 'pending'),
                        emptyMessage: 'No upcoming appointments',
                        emptyIcon: Icons.calendar_today_outlined,
                        onRefresh: () =>
                            context.read<AppointmentCubit>().getAllAppointments(),
                        itemBuilder: (appointment) => UpcomingAppointmentCard(
                          appointment: appointment,
                          onCancel: () => _onCancel(appointment),
                          onReschedule: () => _onReschedule(appointment),
                          onChat: () => _onChat(appointment),
                        ),
                      ),
                      _AppointmentsList(
                        appointments:
                            _filterByStatus(appointments, 'completed'),
                        emptyMessage: 'No completed appointments',
                        emptyIcon: Icons.check_circle_outline,
                        onRefresh: () =>
                            context.read<AppointmentCubit>().getAllAppointments(),
                        itemBuilder: (appointment) =>
                            CompletedAppointmentCard(appointment: appointment),
                      ),
                      _AppointmentsList(
                        appointments:
                            _filterByStatus(appointments, 'cancelled'),
                        emptyMessage: 'No cancelled appointments',
                        emptyIcon: Icons.cancel_outlined,
                        onRefresh: () =>
                            context.read<AppointmentCubit>().getAllAppointments(),
                        itemBuilder: (appointment) =>
                            CancelledAppointmentCard(appointment: appointment),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: ColorsManager.moreLighterGray,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: ColorsManager.mainBlue,
          borderRadius: BorderRadius.circular(10.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: ColorsManager.gray,
        labelStyle: TextStyles.font13DarkBlueMedium.copyWith(
          color: Colors.white,
        ),
        unselectedLabelStyle: TextStyles.font13GrayRegular,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Completed'),
          Tab(text: 'Cancelled'),
        ],
      ),
    );
  }
}

class _AppointmentsAppBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback? onSearch;

  const _AppointmentsAppBar({required this.onBack, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Material(
            color: ColorsManager.lighterGray,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onBack,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'My Appointment',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          Material(
            color: ColorsManager.lighterGray,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onSearch,
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.search_rounded,
                  size: 18.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final String emptyMessage;
  final IconData emptyIcon;
  final Future<void> Function() onRefresh;
  final Widget Function(AppointmentModel) itemBuilder;

  const _AppointmentsList({
    required this.appointments,
    required this.emptyMessage,
    required this.emptyIcon,
    required this.onRefresh,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return _EmptyState(message: emptyMessage, icon: emptyIcon);
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: ColorsManager.mainBlue,
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        itemCount: appointments.length,
        itemBuilder: (_, index) => itemBuilder(appointments[index]),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyState({required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64.r, color: ColorsManager.lighterGray),
          SizedBox(height: 16.h),
          Text(message, style: TextStyles.font14GrayRegular),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: ColorsManager.gray),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyles.font14GrayRegular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text('Retry', style: TextStyles.font14BlueSemiBold),
            ),
          ],
        ),
      ),
    );
  }
}
