import 'dart:async';

import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_recommendation_card.dart';
import 'package:docdoc/features/home/presentation/widgets/sort_filter_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendationDoctorsScreen extends StatefulWidget {
  const RecommendationDoctorsScreen({super.key});

  @override
  State<RecommendationDoctorsScreen> createState() =>
      _RecommendationDoctorsScreenState();
}

class _RecommendationDoctorsScreenState
    extends State<RecommendationDoctorsScreen> {
  late final TextEditingController _searchController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (query.trim().isEmpty) {
        context.read<DoctorsCubit>().getAllDoctors();
      } else {
        context.read<DoctorsCubit>().searchDoctors(query.trim());
      }
    });
  }

  void _openFilterSheet() {
    final specializations =
        context.read<HomeCubit>().state.specializations;
    final currentState = context.read<DoctorsCubit>().state;
    showModalBottomSheet<SortFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SortFilterSheet(
        specializations: specializations,
        initialSpecializationId: currentState.activeSpecializationId,
        initialMinRating: currentState.activeMinRating,
      ),
    ).then((result) {
      if (result != null && mounted) {
        context.read<DoctorsCubit>().applyFilters(
              specializationId: result.specializationId,
              minRating: result.minRating,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(onFilterTap: _openFilterSheet),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 0),
              child: _SearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onFilterTap: _openFilterSheet,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }
                  if (state.doctors.isEmpty) {
                    return Center(
                      child: Text(
                        'No doctors found',
                        style: TextStyles.font14GrayRegular,
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const _AppBar({required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          const _BackButton(),
          Expanded(
            child: Text(
              'Recommendation Doctor',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: onFilterTap,
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

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52.h,
            decoration: BoxDecoration(
              color: ColorsManager.moreLighterGray,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyles.font14DarkBlueMedium,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyles.font14GrayRegular,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: ColorsManager.gray,
                  size: 22.r,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        GestureDetector(
          onTap: onFilterTap,
          child: Icon(
            Icons.tune_rounded,
            color: ColorsManager.darkBlue,
            size: 26.r,
          ),
        ),
      ],
    );
  }
}
