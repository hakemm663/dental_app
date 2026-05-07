import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/inbox/presentation/cubit/inbox_cubit.dart';
import 'package:docdoc/features/inbox/presentation/widgets/conversation_tile.dart';
import 'package:docdoc/features/inbox/presentation/widgets/new_message_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              onNewMessage: () => _showNewMessageSheet(context),
            ),
            _SearchBar(
              controller: _searchController,
              onChanged: (query) =>
                  context.read<InboxCubit>().searchConversations(query),
            ),
            Expanded(
              child: BlocBuilder<InboxCubit, InboxState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }
                  if (state.conversations.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyles.font14GrayRegular,
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: state.conversations.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1.h,
                      indent: 24.w,
                      endIndent: 24.w,
                      color: ColorsManager.lighterGray,
                    ),
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      return ConversationTile(
                        conversation: conversation,
                        onTap: () => Navigator.of(context).pushNamed(
                          Routes.chatScreen,
                          arguments: conversation,
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

  void _showNewMessageSheet(BuildContext context) {
    context.read<InboxCubit>().loadDoctorsForNewMessage();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<InboxCubit>(),
        child: const NewMessageSheet(),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final VoidCallback onNewMessage;

  const _AppBar({required this.onNewMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          _BackButton(),
          Expanded(
            child: Text(
              'Message',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          _NewMessageButton(onTap: onNewMessage),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorsManager.lighterGray),
          ),
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

class _NewMessageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NewMessageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorsManager.lighterGray),
          ),
          child: Icon(
            Icons.add,
            size: 20.r,
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

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                controller: controller,
                onChanged: onChanged,
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
    );
  }
}
