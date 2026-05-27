import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/features/home/presentation/widgets/home_bottom_nav.dart';
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

  void _onTabSelected(HomeNavTab tab) =>
      dispatchHomeNavTab(context, tab, active: HomeNavTab.chat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            DocDocAppBar(
              title: 'Message',
              actions: [
                AppBarIconButton(
                  icon: Icons.add,
                  iconSize: 20.r,
                  onTap: () => _showNewMessageSheet(context),
                ),
              ],
            ),
            _SearchBar(
              controller: _searchController,
              onChanged: (query) =>
                  context.read<InboxCubit>().searchConversations(query),
            ),
            Expanded(
              child: BlocBuilder<InboxCubit, InboxState>(
                buildWhen: (p, c) =>
                    p.isLoading != c.isLoading ||
                    p.errorMessage != c.errorMessage ||
                    p.conversations != c.conversations,
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
                        onTap: () => Navigator.of(
                          context,
                        ).pushNamed(Routes.chatScreen, arguments: conversation),
                      );
                    },
                  );
                },
              ),
            ),
            HomeBottomNav(
              activeTab: HomeNavTab.chat,
              onTabSelected: _onTabSelected,
              onSearchTap: () => Navigator.of(context).pushNamed(Routes.search),
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
          Icon(Icons.tune_rounded, color: ColorsManager.darkBlue, size: 24.r),
        ],
      ),
    );
  }
}
