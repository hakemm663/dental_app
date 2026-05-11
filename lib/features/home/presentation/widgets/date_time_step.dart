import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class DateTimeStep extends StatelessWidget {
  final DateTime selectedDay;
  final String? selectedTime;
  final AppointmentType selectedType;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<String> onTimeSelected;
  final ValueChanged<AppointmentType> onTypeSelected;
  final List<String> timeSlots;
  final int gridCrossAxisCount;

  const DateTimeStep({
    super.key,
    required this.selectedDay,
    required this.selectedTime,
    required this.selectedType,
    required this.onDaySelected,
    required this.onTimeSelected,
    required this.onTypeSelected,
    required this.timeSlots,
    this.gridCrossAxisCount = 3,
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
          crossAxisCount: gridCrossAxisCount,
        ),
        SizedBox(height: 28.h),
        Text('Appointment Type', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 12.h),
        _AppointmentTypeList(selected: selectedType, onSelected: onTypeSelected),
      ],
    );
  }
}

class _DateStrip extends StatelessWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;

  const _DateStrip({required this.selectedDay, required this.onDaySelected});

  DateTime get _weekStart =>
      selectedDay.subtract(Duration(days: selectedDay.weekday - 1));

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
  final int crossAxisCount;

  const _TimeGrid({
    required this.timeSlots,
    required this.selectedTime,
    required this.onTimeSelected,
    this.crossAxisCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
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
              color:
                  isSelected ? ColorsManager.mainBlue : ColorsManager.lightBlue,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? Colors.white : ColorsManager.darkBlue,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppointmentTypeList extends StatelessWidget {
  final AppointmentType selected;
  final ValueChanged<AppointmentType> onSelected;

  const _AppointmentTypeList({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AppointmentType.values.map((type) {
        final isSelected = selected == type;
        return GestureDetector(
          onTap: () => onSelected(type),
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSelected ? ColorsManager.lightBlue : Colors.white,
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
                  type.icon,
                  color: isSelected
                      ? ColorsManager.mainBlue
                      : ColorsManager.gray,
                  size: 22.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    type.label,
                    style: isSelected
                        ? TextStyles.font14DarkBlueMedium
                            .copyWith(color: ColorsManager.mainBlue)
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
                    color:
                        isSelected ? ColorsManager.mainBlue : Colors.white,
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
