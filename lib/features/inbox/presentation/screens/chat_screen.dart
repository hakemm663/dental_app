import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/services/firebase_storage_service.dart';
import 'package:docdoc/core/services/media_picker_service.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/presentation/cubit/chat_cubit.dart';
import 'package:docdoc/features/inbox/presentation/widgets/attachment_sheet.dart';
import 'package:docdoc/features/inbox/presentation/widgets/chat_input_bar.dart';
import 'package:docdoc/features/inbox/presentation/widgets/message_bubble.dart';
import 'package:docdoc/features/inbox/presentation/widgets/session_start_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final ConversationModel conversation;

  const ChatScreen({super.key, required this.conversation});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scrollController = ScrollController();
  final _mediaPicker = getIt<MediaPickerService>();
  final _storageService = getIt<FirebaseStorageService>();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(widget.conversation.id);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleCameraTap() async {
    // Native OS camera via image_picker — no custom in-app camera page.
    final imagePath = await _mediaPicker.pickImageFromCamera();
    if (!mounted || imagePath == null) return;
    await _uploadAndSendImage(imagePath);
  }

  Future<void> _handleDocumentPick() async {
    final result = await _mediaPicker.pickDocument();
    if (!mounted || result == null) return;
    await _uploadAndSendAttachment(result);
  }

  Future<void> _handleFilePick() async {
    final result = await _mediaPicker.pickFile();
    if (!mounted || result == null) return;

    final url = await _storageService.uploadChatAttachment(
      result.path,
      widget.conversation.id,
    );
    if (!mounted) return;
    context.read<ChatCubit>().sendAttachmentMessage(
      widget.conversation.id,
      url,
      result.name,
      result.size,
    );
  }

  Future<void> _uploadAndSendImage(String filePath) async {
    final url = await _storageService.uploadChatImage(
      filePath,
      widget.conversation.id,
    );
    if (!mounted) return;
    context.read<ChatCubit>().sendImageMessage(widget.conversation.id, url);
  }

  Future<void> _uploadAndSendAttachment(String filePath) async {
    final url = await _storageService.uploadChatAttachment(
      filePath,
      widget.conversation.id,
    );
    if (!mounted) return;
    final fileName = filePath.split('/').last;
    context.read<ChatCubit>().sendAttachmentMessage(
      widget.conversation.id,
      url,
      fileName,
      0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.conversation.doctor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ChatAppBar(
              doctorName: doctor.name,
              specialization: doctor.specializationName,
              onVideoCall: () => Navigator.of(
                context,
              ).pushNamed(Routes.videoCall, arguments: widget.conversation),
            ),
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (!state.isLoading && state.messages.isNotEmpty) {
                    _scrollToBottom();
                  }
                  if (state.sendError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.sendError!),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 8.h),
                    itemCount: state.messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return const SessionStartDivider();
                      return MessageBubble(message: state.messages[index - 1]);
                    },
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: (text) {
                context.read<ChatCubit>().sendMessage(
                  widget.conversation.id,
                  text,
                );
              },
              onAttachmentTap: () => _showAttachmentSheet(context),
              onCameraTap: _handleCameraTap,
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => AttachmentSheet(
        onCamera: () {
          Navigator.of(context).pop();
          _handleCameraTap();
        },
        onDocument: () {
          Navigator.of(context).pop();
          _handleDocumentPick();
        },
        onAttachFile: () {
          Navigator.of(context).pop();
          _handleFilePick();
        },
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final String doctorName;
  final String? specialization;
  final VoidCallback onVideoCall;

  const _ChatAppBar({
    required this.doctorName,
    this.specialization,
    required this.onVideoCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Material(
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
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  doctorName,
                  style: TextStyles.font18DarkBlueSemiBold,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                if (specialization != null)
                  Text(specialization!, style: TextStyles.font12GrayRegular),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: onVideoCall,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: ColorsManager.lighterGray),
                ),
                child: Icon(
                  Icons.videocam_outlined,
                  size: 22.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
