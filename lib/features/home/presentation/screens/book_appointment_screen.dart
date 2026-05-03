import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

enum _AppointmentType { inPerson, videoCall, phoneCall }

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _step = 0;
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  _AppointmentType _selectedType = _AppointmentType.inPerson;
  final TextEditingController _notesController = TextEditingController();

  static const List<String> _timeSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '11:00 AM', '11:30 AM', '01:00 PM', '01:30 PM',
    '02:00 PM', '02:30 PM', '03:00 PM', '03:30 PM',
  ];

  bool get _canProceedStep0 => _selectedTime != null;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onContinue(BuildContext context) {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      context.read<AppointmentCubit>().storeAppointment(
            doctorId: widget.doctor.id,
            notes: _notesController.text.isEmpty ? null : _notesController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _BookingAppBar(doctorName: widget.doctor.name),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StepIndicator(currentStep: _step),
                    SizedBox(height: 28.h),
                    if (_step == 0) _DateTimeStep(
                      selectedDay: _selectedDay,
                      selectedTime: _selectedTime,
                      selectedType: _selectedType,
                      onDaySelected: (d) => setState(() {
                        _selectedDay = d;
                        _selectedTime = null;
                      }),
                      onTimeSelected: (t) => setState(() => _selectedTime = t),
                      onTypeSelected: (t) => setState(() => _selectedType = t),
                      timeSlots: _timeSlots,
                    ),
                    if (_step == 1) _PaymentStep(),
                    if (_step == 2) _SummaryStep(
                      doctor: widget.doctor,
                      selectedDay: _selectedDay,
                      selectedTime: _selectedTime ?? '',
                      selectedType: _selectedType,
                      notesController: _notesController,
                    ),
                  ],
                ),
              ),
            ),
            _BottomBar(
              step: _step,
              canProceed: _step == 0 ? _canProceedStep0 : true,
              onBack: _step > 0 ? () => setState(() => _step--) : null,
              onContinue: () => _onContinue(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── App Bar ───────────────────────────────────────────────────────────────

class _BookingAppBar extends StatelessWidget {
  final String doctorName;

  const _BookingAppBar({required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _BackBtn(),
          Expanded(
            child: Text(
              'Book Appointment',
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

class _BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.lighterGray,
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

// ─── Step Indicator ────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  static const List<String> _labels = ['Date & Time', 'Payment', 'Summary'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = i ~/ 2;
          final filled = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 2.h,
              color: filled ? ColorsManager.mainBlue : ColorsManager.lighterGray,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isDone = stepIndex < currentStep;
        return Column(
          children: [
            Container(
              width: 28.r,
              height: 28.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive || isDone
                    ? ColorsManager.mainBlue
                    : ColorsManager.lighterGray,
              ),
              alignment: Alignment.center,
              child: isDone
                  ? Icon(Icons.check, color: Colors.white, size: 14.r)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : ColorsManager.gray,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            SizedBox(height: 4.h),
            Text(
              _labels[stepIndex],
              style: TextStyle(
                fontSize: 10.sp,
                color: isActive ? ColorsManager.mainBlue : ColorsManager.gray,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ─── Step 0: Date & Time ───────────────────────────────────────────────────

class _DateTimeStep extends StatelessWidget {
  final DateTime selectedDay;
  final String? selectedTime;
  final _AppointmentType selectedType;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<String> onTimeSelected;
  final ValueChanged<_AppointmentType> onTypeSelected;
  final List<String> timeSlots;

  const _DateTimeStep({
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedType,
    required this.onDaySelected,
    required this.onTimeSelected,
    required this.onTypeSelected,
    required this.timeSlots,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateStrip(selectedDay: selectedDay, onDaySelected: onDaySelected),
        SizedBox(height: 28.h),
        Text('Available Time', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 16.h),
        _TimeGrid(
          timeSlots: timeSlots,
          selectedTime: selectedTime,
          onTimeSelected: onTimeSelected,
        ),
        SizedBox(height: 28.h),
        Text('Appointment Type', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 12.h),
        _AppointmentTypeList(
          selected: selectedType,
          onSelected: onTypeSelected,
        ),
      ],
    );
  }
}

class _DateStrip extends StatelessWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const _DateStrip({
    required this.selectedDay,
    required this.onDaySelected,
  });

  DateTime get _weekStart {
    final now = selectedDay;
    return now.subtract(Duration(days: now.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    final start = _weekStart;
    final days = List.generate(7, (i) => start.add(Duration(days: i)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(selectedDay),
              style: TextStyles.font18DarkBlueBold,
            ),
            Row(
              children: [
                _ArrowBtn(
                  icon: Icons.chevron_left,
                  onTap: () => onDaySelected(
                    selectedDay.subtract(const Duration(days: 7)),
                  ),
                ),
                SizedBox(width: 4.w),
                _ArrowBtn(
                  icon: Icons.chevron_right,
                  onTap: () => onDaySelected(
                    selectedDay.add(const Duration(days: 7)),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: days.map((day) {
            final isSelected = day.day == selectedDay.day &&
                day.month == selectedDay.month &&
                day.year == selectedDay.year;
            return Expanded(
              child: GestureDetector(
                onTap: () => onDaySelected(day),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ColorsManager.mainBlue
                        : ColorsManager.lightBlue,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('E').format(day)[0],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : ColorsManager.gray,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : ColorsManager.darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ArrowBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.lightBlue,
      borderRadius: BorderRadius.circular(8.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(4.r),
          child: Icon(icon, size: 20.r, color: ColorsManager.mainBlue),
        ),
      ),
    );
  }
}

class _TimeGrid extends StatelessWidget {
  final List<String> timeSlots;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const _TimeGrid({
    required this.timeSlots,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 2.8,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (_, index) {
        final slot = timeSlots[index];
        final isSelected = slot == selectedTime;
        return GestureDetector(
          onTap: () => onTimeSelected(slot),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorsManager.mainBlue
                  : ColorsManager.lightBlue,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? ColorsManager.mainBlue
                    : Colors.transparent,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : ColorsManager.darkBlue,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentTypeList extends StatelessWidget {
  final _AppointmentType selected;
  final ValueChanged<_AppointmentType> onSelected;

  const _AppointmentTypeList({
    required this.selected,
    required this.onSelected,
  });

  static const _types = [
    (_AppointmentType.inPerson, Icons.local_hospital_outlined, 'In Person'),
    (_AppointmentType.videoCall, Icons.videocam_outlined, 'Video Call'),
    (_AppointmentType.phoneCall, Icons.call_outlined, 'Phone Call'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _types.map((entry) {
        final (type, icon, label) = entry;
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onSelected(type),
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color:
                  isSelected ? ColorsManager.lightBlue : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? ColorsManager.mainBlue
                    : ColorsManager.lighterGray,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? ColorsManager.mainBlue
                      : ColorsManager.gray,
                  size: 22.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: isSelected
                        ? TextStyles.font14DarkBlueMedium.copyWith(
                            color: ColorsManager.mainBlue,
                          )
                        : TextStyles.font14GrayRegular,
                  ),
                ),
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? ColorsManager.mainBlue
                          : ColorsManager.lightGray,
                      width: 2,
                    ),
                    color: isSelected
                        ? ColorsManager.mainBlue
                        : Colors.white,
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 12.r)
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Step 1: Payment ───────────────────────────────────────────────────────

class _PaymentStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Text(
          'Payment options coming soon',
          style: TextStyles.font14GrayRegular,
        ),
      ),
    );
  }
}

// ─── Step 2: Summary ──────────────────────────────────────────────────────

class _SummaryStep extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime selectedDay;
  final String selectedTime;
  final _AppointmentType selectedType;
  final TextEditingController notesController;

  const _SummaryStep({
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedType,
    required this.notesController,
  });

  String _typeLabel(_AppointmentType t) => switch (t) {
        _AppointmentType.inPerson => 'In Person',
        _AppointmentType.videoCall => 'Video Call',
        _AppointmentType.phoneCall => 'Phone Call',
      };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state.createdAppointment != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment booked!')),
          );
          Navigator.of(context).pop();
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appointment Summary', style: TextStyles.font18DarkBlueBold),
            SizedBox(height: 20.h),
            _SummaryRow(
              icon: Icons.person_outline_rounded,
              label: 'Doctor',
              value: 'Dr. ${doctor.name}',
            ),
            _SummaryRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: DateFormat('EEEE, MMM d yyyy').format(selectedDay),
            ),
            _SummaryRow(
              icon: Icons.access_time_rounded,
              label: 'Time',
              value: selectedTime,
            ),
            _SummaryRow(
              icon: Icons.local_hospital_outlined,
              label: 'Type',
              value: _typeLabel(selectedType),
            ),
            if (doctor.fees != null)
              _SummaryRow(
                icon: Icons.attach_money_rounded,
                label: 'Fees',
                value: '\$${doctor.fees!.toStringAsFixed(0)}',
              ),
            SizedBox(height: 20.h),
            Text('Notes (optional)', style: TextStyles.font14DarkBlueMedium),
            SizedBox(height: 8.h),
            TextField(
              controller: notesController,
              maxLines: 3,
              style: TextStyles.font14GrayRegular,
              decoration: InputDecoration(
                hintText: 'Add any notes for the doctor...',
                hintStyle: TextStyles.font14GrayRegular,
                filled: true,
                fillColor: ColorsManager.lightBlue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.all(14.r),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              color: ColorsManager.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ColorsManager.mainBlue, size: 20.r),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyles.font12GrayRegular),
              SizedBox(height: 2.h),
              Text(value, style: TextStyles.font14DarkBlueMedium),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Bar ────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int step;
  final bool canProceed;
  final VoidCallback? onBack;
  final VoidCallback onContinue;

  const _BottomBar({
    required this.step,
    required this.canProceed,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentCubit, AppointmentState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
          child: Row(
            children: [
              if (onBack != null) ...[
                Material(
                  color: ColorsManager.lightBlue,
                  borderRadius: BorderRadius.circular(16.r),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: onBack,
                    child: SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: ColorsManager.mainBlue,
                        size: 18.r,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: AppTextButton(
                  buttonText: state.isCreating
                      ? 'Booking...'
                      : step == 2
                          ? 'Confirm Appointment'
                          : 'Continue',
                  textStyle: TextStyles.font16WhiteSemiBold,
                  borderRadius: 16,
                  onPressed: canProceed && !state.isCreating ? onContinue : () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
