import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController userInputController = TextEditingController();
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  final ApiService apiService = ApiService();

  bool isListening = false;
  bool isLoading = false;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    initializeSpeechToText();
  }

  void initializeSpeechToText() async {
    await speechToText.initialize();
  }

  void startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
      isListening = true;
    });
  }

  void stopListening() async {
    await speechToText.stop();
    setState(() {
      isListening = false;
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      userInputController.text = result.recognizedWords;
    });
  }

  Future<void> fetchAIResponse(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      messages.add({"text": userInput, "isUser": true});
      userInputController.clear();
      isLoading = true;
    });

    try {
      String aiResponse = await apiService.fetchAIResponse(userInput);
      setState(() {
        messages.add({"text": aiResponse, "isUser": false});
        isLoading = false;
      });

      flutterTts.speak(aiResponse);
    } catch (error) {
      setState(() {
        messages.add({"text": "Error fetching AI response. Try again later.", "isUser": false});
        isLoading = false;
      });
    }
  }

  Future<void> fetchJobRiskAnalysis(String title, String description, String company, String salary) async {
  double riskScore = await apiService.getJobRiskScore(title, description, company, salary) ?? 0.0;
  setState(() {
    messages.add({"text": "Job Risk Score: $riskScore%", "isUser": false});
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildChatBubble(message);
              },
            ),
          ),
          if (isLoading) _buildTypingIndicator(),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map<String, dynamic> message) {
    bool isUser = message["isUser"];
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          message["text"],
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

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

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: userInputController,
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
            icon: Icon(isListening ? Icons.mic_off : Icons.mic, color: Colors.red),
            onPressed: isListening ? stopListening : startListening,
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () => fetchAIResponse(userInputController.text),
          ),
        ],
      ),
    );
  }
}
