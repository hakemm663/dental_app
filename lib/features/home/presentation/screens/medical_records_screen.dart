import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/colored_icon_badge.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/core/widgets/empty_state_view.dart';
import 'package:docdoc/core/widgets/error_retry_view.dart';
import 'package:docdoc/features/home/data/models/medical_record_model.dart';
import 'package:docdoc/features/home/presentation/cubit/medical_records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordsCubit>().getMedicalRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DocDocAppBar(title: 'Medical Records'),
            Expanded(
              child: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
                buildWhen: (p, c) =>
                    p.isLoading != c.isLoading ||
                    p.errorMessage != c.errorMessage ||
                    p.records != c.records,
                builder: (_, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return ErrorRetryView(
                      message: state.errorMessage!,
                      onRetry: () => context
                          .read<MedicalRecordsCubit>()
                          .getMedicalRecords(),
                    );
                  }
                  if (state.records.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.folder_outlined,
                      message: 'No medical records',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<MedicalRecordsCubit>().getMedicalRecords(),
                    color: ColorsManager.mainBlue,
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                      itemCount: state.records.length,
                      separatorBuilder: (_, _) =>
                          Divider(height: 1, color: ColorsManager.lighterGray),
                      itemBuilder: (_, i) =>
                          _RecordTile(record: state.records[i]),
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

class _RecordTile extends StatelessWidget {
  final MedicalRecordModel record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          const ColoredIconBadge(
            icon: Icons.description_outlined,
            backgroundColor: ColorsManager.warningOrangeBg,
            iconColor: ColorsManager.warningOrange,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.name, style: TextStyles.font14DarkBlueMedium),
                if (record.type != null || record.date != null) ...[
                  SizedBox(height: 2.h),
                  Text(
                    [
                      record.type,
                      record.date,
                    ].where((s) => s != null).join(' • '),
                    style: TextStyles.font12GrayRegular,
                  ),
                ],
              ],
            ),
          ),
          if (record.fileUrl != null)
            Icon(
              Icons.download_outlined,
              size: 20.r,
              color: ColorsManager.mainBlue,
            ),
        ],
      ),
    );
  }
}
