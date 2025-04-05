import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import '../models/message.dart';

class AIAssistantSection extends StatefulWidget {
  const AIAssistantSection({Key? key}) : super(key: key);

  @override
  _AIAssistantSectionState createState() => _AIAssistantSectionState();
}

class _AIAssistantSectionState extends State<AIAssistantSection> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final provider = Provider.of<JobProvider>(context, listen: false);
    String userMessage = _messageController.text.trim();
    _messageController.clear();

    provider.sendMessage(userMessage);

    await Future.delayed(const Duration(seconds: 1)); // Simulating network delay
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer<JobProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: provider.messages.length,
                itemBuilder: (context, index) {
                  final message = provider.messages[index];
                  return _buildChatBubble(message);
                },
              );
            },
          ),
        ),
        if (_isLoading) _buildTypingIndicator(),
        _buildInputField(),
      ],
    );
  }

  /// Builds chat bubbles for user and AI responses
  Widget _buildChatBubble(Message message) {
    bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            topRight: const Radius.circular(10),
            bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(10),
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Typing indicator to show AI is generating a response
  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: 10),
          Text("Thinking...", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  /// Input field for user to type messages
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Ask something...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _isLoading ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
