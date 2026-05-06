import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_recommendation_card.dart';
import 'package:docdoc/features/home/presentation/widgets/home_banner.dart';
import 'package:docdoc/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:docdoc/features/home/presentation/widgets/home_header.dart';
import 'package:docdoc/features/home/presentation/widgets/speciality_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'there';
  HomeNavTab activeTab = HomeNavTab.home;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
    context.read<DoctorsCubit>().getAllDoctors();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await SharedPrefHelper.getString(SharedPrefKeys.userName);
    if (!mounted) return;
    if (name.isNotEmpty) {
      setState(() => userName = name.split(' ').first);
    }
  }

  void _onTabSelected(HomeNavTab tab) {
    setState(() => activeTab = tab);
    switch (tab) {
      case HomeNavTab.home:
        break;
      case HomeNavTab.calendar:
        Navigator.of(context).pushNamed(Routes.appointments);
      case HomeNavTab.profile:
        Navigator.of(context).pushNamed(Routes.profile);
      case HomeNavTab.chat:
        Navigator.of(context).pushNamed(Routes.inboxScreen);
    }
  }

  void _onSearchTap() {
    _pushAndResetDoctors(Routes.recommendationDoctors);
  }

  /// Push a screen that may apply doctor filters and reset the list on return.
  Future<void> _pushAndResetDoctors(String route) async {
    await Navigator.of(context).pushNamed(route);
    if (!mounted) return;
    context.read<DoctorsCubit>().getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeHeader(
                      userName: userName,
                      onNotificationTap: () =>
                          Navigator.of(context).pushNamed(Routes.notifications),
                    ),
                    SizedBox(height: 24.h),
                    HomeBanner(
                      onFindNearbyTap: () =>
                          Navigator.of(context).pushNamed(Routes.findNearby),
                    ),
                    SizedBox(height: 28.h),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 28.h),
                            child: SizedBox(
                              height: 110.h,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                        if (state.specializations.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: 28.h),
                          child: SpecialitySection(
                            specializations: state.specializations,
                            onSeeAll: () =>
                                _pushAndResetDoctors(Routes.specialitiesScreen),
                            onSpecialityTap: (SpecializationModel spec) {
                              context
                                  .read<DoctorsCubit>()
                                  .applyFilters(specializationId: spec.id);
                              _pushAndResetDoctors(Routes.recommendationDoctors);
                            },
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recommendation Doctor',
                          style: TextStyles.font18DarkBlueBold
                              .copyWith(fontSize: 20.sp),
                        ),
                        GestureDetector(
                          onTap: () =>
                              _pushAndResetDoctors(Routes.recommendationDoctors),
                          child: Text(
                            'See All',
                            style: TextStyles.font13BlueSemiBold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    BlocBuilder<DoctorsCubit, DoctorsState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return SizedBox(
                            height: 200.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state.errorMessage != null) {
                          return Center(child: Text(state.errorMessage!));
                        }
                        if (state.doctors.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            child: Center(
                              child: Text(
                                'No doctors available',
                                style: TextStyles.font14GrayRegular,
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.doctors.length,
                          separatorBuilder: (_, _) => SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            final doctor = state.doctors[index];
                            return DoctorRecommendationCard(
                              doctor: doctor,
                              specialityLabel:
                                  doctor.specializationName ?? 'General',
                              onTap: () => Navigator.of(context).pushNamed(
                                Routes.doctorDetails,
                                arguments: doctor.id,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            HomeBottomNav(
              activeTab: activeTab,
              onTabSelected: _onTabSelected,
              onSearchTap: _onSearchTap,
              userName: userName,
            ),
          ],
        ),
      ),
    );
  }
}
