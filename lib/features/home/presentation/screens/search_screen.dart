import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:docdoc/features/home/presentation/cubit/home_cubit.dart';
import 'package:docdoc/features/home/presentation/cubit/search_cubit.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_recommendation_card.dart';
import 'package:docdoc/features/home/presentation/widgets/recent_searches_list.dart';
import 'package:docdoc/features/home/presentation/widgets/search_input_bar.dart';
import 'package:docdoc/features/home/presentation/widgets/sort_filter_sheet.dart';
import 'package:docdoc/features/home/presentation/widgets/speciality_chips_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    context.read<SearchCubit>().loadRecentSearches();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _fillFromRecent(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: query.length),
    );
    context.read<SearchCubit>().onQueryChanged(query);
  }

  Future<void> _openFilterSheet(
    List<SpecializationModel> specializations,
    SearchState state,
  ) async {
    final result = await showModalBottomSheet<SortFilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SortFilterSheet(
        specializations: specializations,
        initialSpecializationId: state.activeSpecializationId,
        initialMinRating: state.activeMinRating,
      ),
    );
    if (result != null && mounted) {
      context.read<SearchCubit>().applyFilters(
            specializationId: result.specializationId,
            minRating: result.minRating,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final specializations =
        context.watch<HomeCubit>().state.specializations;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchAppBar(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (q) => context.read<SearchCubit>().onQueryChanged(q),
              onFilterTap: () => _openFilterSheet(
                specializations,
                context.read<SearchCubit>().state,
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                buildWhen: (prev, curr) =>
                    prev.query != curr.query ||
                    prev.isLoading != curr.isLoading ||
                    prev.results != curr.results ||
                    prev.recentSearches != curr.recentSearches ||
                    prev.errorMessage != curr.errorMessage ||
                    prev.activeSpecializationId != curr.activeSpecializationId,
                builder: (context, state) {
                  if (!state.hasQuery) {
                    return _EmptyQueryView(
                      searches: state.recentSearches,
                      onTap: _fillFromRecent,
                      onRemove: (q) =>
                          context.read<SearchCubit>().removeRecentSearch(q),
                      onClearAll: () =>
                          context.read<SearchCubit>().clearAllRecentSearches(),
                    );
                  }
                  if (state.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state.errorMessage != null) {
                    return _ErrorView(message: state.errorMessage!);
                  }
                  return _ResultsView(
                    state: state,
                    specializations: specializations,
                    onChipSelected: (id) =>
                        context.read<SearchCubit>().applyFilters(
                              specializationId: id,
                              minRating: state.activeMinRating,
                            ),
                    onDoctorTap: (doctorId) =>
                        Navigator.of(context).pushNamed(
                      Routes.doctorDetails,
                      arguments: doctorId,
                    ),
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

class _SearchAppBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const _SearchAppBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      child: Row(
        children: [
          AppBarIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SearchInputBar(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onFilterTap: onFilterTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyQueryView extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const _EmptyQueryView({
    required this.searches,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: RecentSearchesList(
        searches: searches,
        onTap: onTap,
        onRemove: onRemove,
        onClearAll: onClearAll,
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  final SearchState state;
  final List<SpecializationModel> specializations;
  final ValueChanged<int?> onChipSelected;
  final ValueChanged<int> onDoctorTap;

  const _ResultsView({
    required this.state,
    required this.specializations,
    required this.onChipSelected,
    required this.onDoctorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (specializations.isNotEmpty)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: SpecialityChipsRow(
              specializations: specializations,
              selectedId: state.activeSpecializationId,
              onSelected: onChipSelected,
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Text(
            '${state.results.length} found',
            style: TextStyles.font14DarkBlueMedium,
          ),
        ),
        if (state.results.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 56.r,
                    color: ColorsManager.lighterGray,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'No doctors found',
                    style: TextStyles.font18DarkBlueBold,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Try a different name or clear filters',
                    style: TextStyles.font13GrayRegular,
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: state.results.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1, color: ColorsManager.lighterGray),
              itemBuilder: (_, index) {
                final doctor = state.results[index];
                return DoctorRecommendationCard(
                  doctor: doctor,
                  specialityLabel:
                      doctor.specializationName ?? 'General',
                  onTap: () => onDoctorTap(doctor.id),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 56.r,
              color: ColorsManager.lighterGray,
            ),
            SizedBox(height: 12.h),
            Text(
              'Something went wrong',
              style: TextStyles.font18DarkBlueBold,
            ),
            SizedBox(height: 4.h),
            Text(
              message,
              style: TextStyles.font13GrayRegular,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
