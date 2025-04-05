import 'dart:convert';

/// Represents a chat message with type, content, and metadata.
class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;

  Message({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
    this.type = MessageType.text,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Converts Message to JSON format.
  Map<String, dynamic> toJson() => {
        'content': content,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'type': type.name, // Store enum as a readable string
      };

  /// Creates a Message from a JSON object.
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      type: _parseMessageType(json['type'] as String?),
    );
  }

  /// Parses a string to MessageType, defaulting to `text` if unknown.
  static MessageType _parseMessageType(String? type) {
    return MessageType.values
        .firstWhere((e) => e.name == type, orElse: () => MessageType.text);
  }

  /// Creates a copy of the Message with modified fields.
  Message copyWith({
    String? content,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
  }) {
    return Message(
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }

  /// Encodes a list of messages to JSON string.
  static String encode(List<Message> messages) {
    return json.encode(messages.map((msg) => msg.toJson()).toList());
  }

  /// Decodes JSON string to a list of Message objects.
  static List<Message> decode(String jsonString) {
    return (json.decode(jsonString) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Message.fromJson)
        .toList();
  }
}

/// Enum for different message types in the chat.
enum MessageType {
  text,          // Regular text message
  aiResponse,    // AI-generated response
  jobSuggestion, // Job recommendation from AI
  warning,       // Fake job alert
}
