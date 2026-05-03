import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<DoctorDetailsCubit>().getDoctorDetails(widget.doctorId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          final doctor = state.doctor;
          if (doctor == null) {
            return const Center(child: Text('No doctor found'));
          }
          return _DoctorDetailsBody(
            doctor: doctor,
            tabController: _tabController,
          );
        },
      ),
    );
  }
}

class _DoctorDetailsBody extends StatelessWidget {
  final DoctorModel doctor;
  final TabController tabController;

  const _DoctorDetailsBody({required this.doctor, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _DetailsAppBar(name: doctor.name),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DoctorSummary(doctor: doctor),
                  SizedBox(height: 24.h),
                  _DetailsTabBar(tabController: tabController),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 300.h,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _AboutTab(doctor: doctor),
                        _LocationTab(address: doctor.address),
                        const _ReviewsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BookButton(doctor: doctor),
        ],
      ),
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  final String name;

  const _DetailsAppBar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _BackButton(),
          Expanded(
            child: Text(
              'Dr. $name',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: Icon(
                  Icons.more_horiz_rounded,
                  color: ColorsManager.darkBlue,
                  size: 24.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
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

class _DoctorSummary extends StatelessWidget {
  final DoctorModel doctor;

  const _DoctorSummary({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _DoctorAvatar(image: doctor.image, name: doctor.name),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dr. ${doctor.name}',
                style: TextStyles.font18DarkBlueBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              if (doctor.address != null && doctor.address!.isNotEmpty)
                Text(
                  doctor.address!,
                  style: TextStyles.font13GrayRegular,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFB800),
                    size: 16.r,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    doctor.rating != null
                        ? doctor.rating!.toStringAsFixed(1)
                        : '—',
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        _ChatButton(),
      ],
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? image;
  final String name;

  const _DoctorAvatar({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 100.r,
        height: 100.r,
        color: ColorsManager.moreLighterGray,
        child: image == null || image!.isEmpty
            ? Center(
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyles.font24BlueBold,
                ),
              )
            : Image.network(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyles.font24BlueBold,
                  ),
                ),
              ),
      ),
    );
  }
}

class _ChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.mainBlue,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () {
          // TODO: navigate to chat screen
        },
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.white,
            size: 22.r,
          ),
        ),
      ),
    );
  }
}

class _DetailsTabBar extends StatelessWidget {
  final TabController tabController;

  const _DetailsTabBar({required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: ColorsManager.mainBlue,
      unselectedLabelColor: ColorsManager.gray,
      labelStyle: TextStyles.font14DarkBlueMedium.copyWith(
        color: ColorsManager.mainBlue,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyles.font14GrayRegular,
      indicatorColor: ColorsManager.mainBlue,
      indicatorWeight: 2.5,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: ColorsManager.lighterGray,
      tabs: const [
        Tab(text: 'About'),
        Tab(text: 'Location'),
        Tab(text: 'Reviews'),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  final DoctorModel doctor;

  const _AboutTab({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (doctor.bio != null && doctor.bio!.isNotEmpty) ...[
            _Section(
              title: 'Biography',
              child: Text(doctor.bio!, style: TextStyles.font14GrayRegular),
            ),
            SizedBox(height: 20.h),
          ],
          if (doctor.startTime != null || doctor.endTime != null) ...[
            _Section(
              title: 'Working Time',
              child: Text(
                _formatWorkingTime(doctor.startTime, doctor.endTime),
                style: TextStyles.font14GrayRegular,
              ),
            ),
            SizedBox(height: 20.h),
          ],
          if (doctor.fees != null)
            _Section(
              title: 'Consultation Fees',
              child: Text(
                '\$${doctor.fees!.toStringAsFixed(0)}',
                style: TextStyles.font14DarkBlueMedium,
              ),
            ),
        ],
      ),
    );
  }

  String _formatWorkingTime(String? start, String? end) {
    if (start != null && end != null) return '$start – $end';
    if (start != null) return 'From $start';
    if (end != null) return 'Until $end';
    return '—';
  }
}

class _LocationTab extends StatelessWidget {
  final String? address;

  const _LocationTab({this.address});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: _Section(
        title: 'Address',
        child: Text(
          address ?? 'No address available',
          style: TextStyles.font14GrayRegular,
        ),
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No reviews yet', style: TextStyles.font14GrayRegular),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }
}

class _BookButton extends StatelessWidget {
  final DoctorModel doctor;

  const _BookButton({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: AppTextButton(
        buttonText: 'Make An Appointment',
        textStyle: TextStyles.font16WhiteSemiBold,
        borderRadius: 16,
        onPressed: () => Navigator.of(
          context,
        ).pushNamed(Routes.bookAppointment, arguments: doctor),
      ),
    );
  }
}
