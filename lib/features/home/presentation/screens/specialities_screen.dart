import 'package:docdoc/core/helpers/specialty_icon_resolver.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialitiesScreen extends StatelessWidget {
  const SpecialitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _AppBar(),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.specializations.isEmpty) {
                    return Center(
                      child: Text(
                        'No specialities found',
                        style: TextStyles.font14GrayRegular,
                      ),
                    );
                  }
                  return GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 24.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 24.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: state.specializations.length,
                    itemBuilder: (context, index) {
                      final spec = state.specializations[index];
                      return _SpecialityGridItem(
                        spec: spec,
                        onTap: () => _onSpecialityTap(context, spec),
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

  void _onSpecialityTap(BuildContext context, SpecializationModel spec) {
    context
        .read<DoctorsCubit>()
        .applyFilters(specializationId: spec.id);
    Navigator.of(context).pushNamed(Routes.recommendationDoctors);
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          const _BackButton(),
          Expanded(
            child: Text(
              'Doctor Speciality',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
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

class _SpecialityGridItem extends StatelessWidget {
  final SpecializationModel spec;
  final VoidCallback onTap;

  const _SpecialityGridItem({required this.spec, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: const BoxDecoration(
              color: ColorsManager.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              specialtyIconFor(spec.name),
              color: ColorsManager.mainBlue,
              size: 36.r,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            spec.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font13DarkBlueMedium,
          ),
        ],
      ),
    );
  }
}
