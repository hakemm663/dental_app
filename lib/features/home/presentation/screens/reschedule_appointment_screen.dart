import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/screens/reschedule_confirmed_screen.dart';
import 'package:docdoc/features/home/presentation/widgets/date_time_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RescheduleAppointmentScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const RescheduleAppointmentScreen({super.key, required this.appointment});

  @override
  State<RescheduleAppointmentScreen> createState() =>
      _RescheduleAppointmentScreenState();
}

class _RescheduleAppointmentScreenState
    extends State<RescheduleAppointmentScreen> {
  static const List<String> _timeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];

  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  AppointmentType _selectedType = AppointmentType.inPerson;

  String get _startTimePayload {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final parsed = DateFormat('hh:mm a').parse(_selectedTime!);
    final time = DateFormat('HH:mm').format(parsed);
    return '$date $time';
  }

  void _onReschedule() {
    if (_selectedTime == null) return;
    context.read<AppointmentCubit>().rescheduleAppointment(
          id: widget.appointment.id,
          startTime: _startTimePayload,
          appointmentType: _selectedType,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentCubit, AppointmentState>(
      listenWhen: (prev, curr) =>
          prev.rescheduledAppointment != curr.rescheduledAppointment ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.rescheduledAppointment != null) {
          Navigator.of(context).pushReplacementNamed(
            Routes.rescheduleConfirmed,
            arguments: RescheduleConfirmedArgs(
              appointment: state.rescheduledAppointment!,
              selectedDay: _selectedDay,
              selectedTime: _selectedTime!,
              appointmentType: _selectedType,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _RescheduleAppBar(
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: DateTimeStep(
                    selectedDay: _selectedDay,
                    selectedTime: _selectedTime,
                    selectedType: _selectedType,
                    timeSlots: _timeSlots,
                    gridCrossAxisCount: 2,
                    onDaySelected: (d) => setState(() {
                      _selectedDay = d;
                      _selectedTime = null;
                    }),
                    onTimeSelected: (t) => setState(() => _selectedTime = t),
                    onTypeSelected: (t) =>
                        setState(() => _selectedType = t),
                  ),
                ),
              ),
              BlocBuilder<AppointmentCubit, AppointmentState>(
                buildWhen: (p, c) => p.isRescheduling != c.isRescheduling,
                builder: (_, state) => Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
                  child: state.isRescheduling
                      ? const Center(child: CircularProgressIndicator())
                      : AppTextButton(
                          buttonText: 'Reschedule',
                          textStyle: TextStyles.font16WhiteSemiBold,
                          borderRadius: 16,
                          onPressed:
                              _selectedTime != null ? _onReschedule : () {},
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RescheduleAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _RescheduleAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppBarIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          Expanded(
            child: Text(
              'Reschedule Appointment',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }
}
