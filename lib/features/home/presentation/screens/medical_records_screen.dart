import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
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
            _AppBar(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: BlocBuilder<MedicalRecordsCubit, MedicalRecordsState>(
                builder: (_, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return _ErrorView(
                      message: state.errorMessage!,
                      onRetry: () =>
                          context.read<MedicalRecordsCubit>().getMedicalRecords(),
                    );
                  }
                  if (state.records.isEmpty) {
                    return _EmptyState();
                  }
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<MedicalRecordsCubit>().getMedicalRecords(),
                    color: ColorsManager.mainBlue,
                    child: ListView.separated(
                      padding:
                          EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
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

class _AppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _AppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppBarIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          Expanded(
            child: Text(
              'Medical Records',
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

class _RecordTile extends StatelessWidget {
  final MedicalRecordModel record;

  const _RecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.description_outlined,
              color: const Color(0xFFF59E0B),
              size: 22.r,
            ),
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
                    [record.type, record.date]
                        .where((s) => s != null)
                        .join(' • '),
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 64.r,
            color: ColorsManager.lighterGray,
          ),
          SizedBox(height: 16.h),
          Text('No medical records', style: TextStyles.font14GrayRegular),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: ColorsManager.gray),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyles.font14GrayRegular,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: onRetry,
              child: Text('Retry', style: TextStyles.font14BlueSemiBold),
            ),
          ],
        ),
      ),
    );
  }
}
