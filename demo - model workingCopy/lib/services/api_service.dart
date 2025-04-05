import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_key.dart'; // Ensure this file securely stores API keys

class ApiService {
  static const String groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';  
  static const String groqModel = 'llama-3.3-70b-versatile'; // Adjust model as needed
  static const String firebaseMLUrl = 'https://firebaseml.googleapis.com/v1/projects/YOUR_PROJECT_ID/models/YOUR_MODEL_ID:predict';
  static const String groqApiKey = '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';

  /// 🔹 Fetch AI-generated responses using GROQ API
  Future<String> fetchAIResponse(String userInput) async {
    try {
      final response = await http.post(
        Uri.parse(groqApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $groqApiKey', // Use secure storage
        },
        body: jsonEncode({
          'model': groqModel,
          'messages': [
            {'role': 'system', 'content': 'You are an AI assistant helping with job verification.'},
            {'role': 'user', 'content': userInput},
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices']?[0]?['message']?['content'] ?? 'No response received.';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error: Unable to process request. Please check your network. $e';
    }
  }

  /// 🔹 Get job risk score from Firebase ML
  Future<double?> getJobRiskScore(String title, String description, String company, String salary) async {
    try {
      final response = await http.post(
        Uri.parse(firebaseMLUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseApiKey',  // Ensure Firebase API key
        },
        body: jsonEncode({
          'instances': [
            {
              'title': title,
              'description': description,
              'company': company,
              'salary': salary,
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['predictions']?[0]?['risk_score'] as num?)?.toDouble();
      } else {
        return null; // Indicate failure instead of assuming a default score
      }
    } catch (e) {
      return null; // Handle errors gracefully
    }
  }
}
