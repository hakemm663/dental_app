import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/inbox/presentation/cubit/inbox_cubit.dart';
import 'package:docdoc/features/inbox/presentation/widgets/doctor_contact_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewMessageSheet extends StatefulWidget {
  const NewMessageSheet({super.key});

  @override
  State<NewMessageSheet> createState() => _NewMessageSheetState();
}

class _NewMessageSheetState extends State<NewMessageSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 24.r),
                ),
                Expanded(
                  child: Text(
                    'Create New Message',
                    textAlign: TextAlign.center,
                    style: TextStyles.font18DarkBlueBold,
                  ),
                ),
                SizedBox(width: 24.r),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46.h,
                    decoration: BoxDecoration(
                      color: ColorsManager.moreLighterGray,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: 'Search Message',
                        hintStyle: TextStyles.font14LightGrayRegular,
                        prefixIcon: Icon(
                          Icons.search,
                          color: ColorsManager.lightGray,
                          size: 22.r,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.tune_rounded,
                  color: ColorsManager.darkBlue,
                  size: 24.r,
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<InboxCubit, InboxState>(
              builder: (context, state) {
                final doctors = _query.isEmpty
                    ? state.doctors
                    : state.doctors
                          .where(
                            (d) => d.name.toLowerCase().contains(
                              _query.toLowerCase(),
                            ),
                          )
                          .toList();

                if (doctors.isEmpty) {
                  return Center(
                    child: Text(
                      'No doctors found',
                      style: TextStyles.font14GrayRegular,
                    ),
                  );
                }

                return ListView.separated(
                  controller: scrollController,
                  itemCount: doctors.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1.h,
                    indent: 24.w,
                    endIndent: 24.w,
                    color: ColorsManager.lighterGray,
                  ),
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    return DoctorContactTile(
                      doctor: doctor,
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        final cubit = context.read<InboxCubit>();
                        navigator.pop();
                        final result = await cubit.getOrCreateConversation(
                          doctor,
                        );
                        switch (result) {
                          case Success(:final data):
                            navigator.pushNamed(
                              Routes.chatScreen,
                              arguments: data,
                            );
                          case Failure():
                            break;
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
