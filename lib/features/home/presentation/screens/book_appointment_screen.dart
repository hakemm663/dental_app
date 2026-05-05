import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/models/payment_method.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';
import 'package:docdoc/features/home/presentation/screens/booking_confirmed_screen.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_stepper.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_summary_view.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_total_sheet.dart';
import 'package:docdoc/features/home/presentation/widgets/date_time_step.dart';
import 'package:docdoc/features/home/presentation/widgets/payment_option_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  static const List<String> _timeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
  ];

  // TODO(backend): tax should come from a pricing endpoint, not a flat 5%.
  static const double _taxRate = 0.05;

  int _step = 0;
  DateTime _selectedDay = DateTime.now();
  String? _selectedTime;
  AppointmentType _selectedType = AppointmentType.inPerson;
  PaymentMethod? _selectedPayment;
  CardBrand _lastBrand = CardBrand.mastercard;

  bool get _canContinueStep0 => _selectedTime != null;
  bool get _canContinueStep1 => _selectedPayment != null;

  void _onPaymentChanged(PaymentMethod method) {
    setState(() {
      _selectedPayment = method;
      if (method is CreditCardPayment) _lastBrand = method.brand;
    });
  }

  double get _subtotal => widget.doctor.fees ?? 0;
  double get _tax => _subtotal * _taxRate;

  String get _startTimePayload {
    final date = DateFormat('yyyy-MM-dd').format(_selectedDay);
    final parsed = DateFormat('hh:mm a').parse(_selectedTime!);
    final time = DateFormat('HH:mm').format(parsed);
    return '$date $time';
  }

  void _onContinue() => setState(() => _step = (_step + 1).clamp(0, 2));

  void _onBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  void _onChangePayment() => setState(() => _step = 1);

  void _bookNow() {
    context.read<AppointmentCubit>().storeAppointment(
      doctorId: widget.doctor.id,
      startTime: _startTimePayload,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentCubit, AppointmentState>(
      listenWhen: (prev, curr) =>
          prev.createdAppointment != curr.createdAppointment ||
          prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.createdAppointment != null) {
          Navigator.of(context).pushReplacementNamed(
            Routes.bookingConfirmed,
            arguments: BookingConfirmedArgs(
              doctor: widget.doctor,
              selectedDay: _selectedDay,
              selectedTime: _selectedTime!,
              appointmentType: _selectedType,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _BookingAppBar(onBack: _onBack),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 8.h),
                child: BookingStepper(currentStep: _step),
              ),
              SizedBox(height: 16.h),
              Expanded(child: _buildBody()),
              if (_step == 2)
                BlocBuilder<AppointmentCubit, AppointmentState>(
                  buildWhen: (p, c) => p.isCreating != c.isCreating,
                  builder: (_, state) => BookingTotalSheet(
                    subtotal: _subtotal,
                    tax: _tax,
                    isLoading: state.isCreating,
                    onBookNow: _bookNow,
                  ),
                )
              else
                _ContinueBar(
                  enabled: _step == 0 ? _canContinueStep0 : _canContinueStep1,
                  onContinue: _onContinue,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
      child: switch (_step) {
        0 => DateTimeStep(
          selectedDay: _selectedDay,
          selectedTime: _selectedTime,
          selectedType: _selectedType,
          timeSlots: _timeSlots,
          onDaySelected: (d) => setState(() {
            _selectedDay = d;
            _selectedTime = null;
          }),
          onTimeSelected: (t) => setState(() => _selectedTime = t),
          onTypeSelected: (t) => setState(() => _selectedType = t),
        ),
        1 => PaymentOptionSection(
          selected: _selectedPayment,
          defaultCreditBrand: _lastBrand,
          onChanged: _onPaymentChanged,
        ),
        _ => BookingSummaryView(
          doctor: widget.doctor,
          selectedDay: _selectedDay,
          selectedTime: _selectedTime ?? '',
          appointmentType: _selectedType,
          paymentMethod: _selectedPayment ?? const PayPalPayment(),
          onChangePayment: _onChangePayment,
        ),
      },
    );
  }
}

class _BookingAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _BookingAppBar({required this.onBack});

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

class _ContinueBar extends StatelessWidget {
  final bool enabled;
  final VoidCallback onContinue;

  const _ContinueBar({required this.enabled, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: AppTextButton(
        buttonText: 'Continue',
        textStyle: TextStyles.font16WhiteSemiBold,
        borderRadius: 16,
        onPressed: enabled ? onContinue : () {},
      ),
    );
  }
}
