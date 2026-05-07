enum MessageType { text, image, attachment }

class MessageModel {
  final int id;
  final int conversationId;
  final String text;
  final int senderId;
  final DateTime timestamp;
  final bool isMe;
  final MessageType type;
  final String? imageUrl;
  final String? fileName;
  final int? fileSize;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.imageUrl,
    this.fileName,
    this.fileSize,
  });
}
