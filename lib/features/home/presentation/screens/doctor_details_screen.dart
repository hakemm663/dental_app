import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/review_model.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_details_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/doctor_reviews_cubit.dart';
import 'package:docdoc/features/inbox/presentation/cubit/inbox_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

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
    context.read<DoctorReviewsCubit>().loadReviews(widget.doctorId);
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
                    height: 420.h,
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        _AboutTab(doctor: doctor),
                        _LocationTab(doctor: doctor),
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
          const _BackButton(),
          Expanded(
            child: Text(
              'Dr $name',
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
                doctorDisplayName(doctor.name),
                style: TextStyles.font18DarkBlueBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.h),
              Text(
                [
                  doctor.specializationName ?? 'General',
                  if (doctor.address != null && doctor.address!.isNotEmpty)
                    doctor.address!,
                ].join('  |  '),
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
                        ? '${doctor.rating!.toStringAsFixed(1)} (${doctor.reviewsCount ?? 0} reviews)'
                        : '—',
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
        _ChatButton(doctor: doctor),
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
  final DoctorModel doctor;

  const _ChatButton({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () async {
          final inboxCubit = getIt<InboxCubit>();
          final result = await inboxCubit.getOrCreateConversation(doctor);
          if (!context.mounted) return;
          switch (result) {
            case Success(:final data):
              Navigator.of(context).pushNamed(
                Routes.chatScreen,
                arguments: data,
              );
            case Failure():
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not open chat')),
              );
          }
        },
        child: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsManager.white, width: 1.5),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            color: ColorsManager.mainBlue,
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

// ── About Tab ─────────────────────────────────────────────────────────────────

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
              title: 'About me',
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
          if (doctor.str != null && doctor.str!.isNotEmpty) ...[
            _Section(
              title: 'STR',
              child: Text(doctor.str!, style: TextStyles.font14GrayRegular),
            ),
            SizedBox(height: 20.h),
          ],
          if (doctor.experiences != null && doctor.experiences!.isNotEmpty) ...[
            _Section(
              title: 'Pengalaman Praktik',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: doctor.experiences!
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.place,
                              style: TextStyles.font14DarkBlueMedium,
                            ),
                            Text(
                              e.isCurrent
                                  ? '${e.fromYear} - sekarang'
                                  : '${e.fromYear} - ${e.toYear ?? ''}',
                              style: TextStyles.font13GrayRegular,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(height: 20.h),
          ],
          if (doctor.fees != null)
            _Section(
              title: 'Consultation Fees',
              child: Text(
                '${doctor.fees!.toStringAsFixed(0)} EGP',
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

// ── Location Tab ──────────────────────────────────────────────────────────────

class _LocationTab extends StatelessWidget {
  final DoctorModel doctor;

  const _LocationTab({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final hasCoords = doctor.latitude != null && doctor.longitude != null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: 'Practice Place',
            child: Text(
              doctor.address ?? 'Not available',
              style: TextStyles.font14GrayRegular,
            ),
          ),
          SizedBox(height: 20.h),
          _Section(
            title: 'Location Map',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 200.h,
                child: hasCoords
                    ? FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(
                            doctor.latitude!,
                            doctor.longitude!,
                          ),
                          initialZoom: 14,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.none,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.docdoc.app',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                  doctor.latitude!,
                                  doctor.longitude!,
                                ),
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 36.r,
                                ),
                              ),
                            ],
                          ),
                          const RichAttributionWidget(
                            attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(
                        color: ColorsManager.moreLighterGray,
                        child: Center(
                          child: Text(
                            'Location not available',
                            style: TextStyles.font14GrayRegular,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reviews Tab ───────────────────────────────────────────────────────────────

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorReviewsCubit, DoctorReviewsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.reviews.isEmpty) {
          return Center(
            child: Text('No reviews yet', style: TextStyles.font14GrayRegular),
          );
        }
        return ListView.separated(
          itemCount: state.reviews.length,
          separatorBuilder: (_, _) =>
              Divider(height: 24.h, color: ColorsManager.lighterGray),
          itemBuilder: (_, index) => _ReviewItem(review: state.reviews[index]),
        );
      },
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final ReviewModel review;

  const _ReviewItem({required this.review});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewerAvatar(image: review.reviewerImage, name: review.reviewerName),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.reviewerName,
                    style: TextStyles.font14DarkBlueBold,
                  ),
                  Text(
                    _relativeDate(review.createdAt),
                    style: TextStyles.font12GrayRegular,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star_rounded,
                    size: 16.r,
                    color: i < review.rating
                        ? const Color(0xFFFFB800)
                        : ColorsManager.lighterGray,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(review.body, style: TextStyles.font13GrayRegular),
            ],
          ),
        ),
      ],
    );
  }

  String _relativeDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}

class _ReviewerAvatar extends StatelessWidget {
  final String? image;
  final String name;

  const _ReviewerAvatar({this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 44.r,
        height: 44.r,
        color: ColorsManager.moreLighterGray,
        child: image != null && image!.isNotEmpty
            ? Image.network(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initial(name: name),
              )
            : _Initial(name: name),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  final String name;

  const _Initial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyles.font14DarkBlueBold.copyWith(
          color: ColorsManager.mainBlue,
        ),
      ),
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────

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
