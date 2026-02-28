import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ❗ DO NOT hardcode API keys here
// Use environment variables or secure storage instead
const String GROQ_API_KEY = String.fromEnvironment('GROQ_API_KEY');
const String firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');

class ApiService {
  final String apiKey = GROQ_API_KEY;

  Future<String> analyzeResume(File file) async {
    final uri = Uri.parse("https://your-backend.com/resume-analyzer");

    var request = http.MultipartRequest("POST", uri);
    request.files.add(await http.MultipartFile.fromPath('resume', file.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);
      return data["analysis"] ?? "Could not analyze resume.";
    } else {
      return "Resume analysis failed. Try again.";
    }
  }

  Future<String> detectScam(String message) async {
    final response = await http.post(
      Uri.parse("https://your-backend.com/interview-scam-check"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["result"] ?? "No scam analysis found.";
    } else {
      return "Error: Unable to analyze scam message";
    }
  }

  Future<String> fetchAIResponse(String prompt) async {
    final response = await http.post(
      Uri.parse("https://your-chat-api.com/ai"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({"prompt": prompt}),
    );

    final data = jsonDecode(response.body);
    return data["response"] ?? "No response received.";
  }

  Future<double?> getJobRiskScore(
      String title, String description, String company, String salary) async {
    final response = await http.post(
      Uri.parse("https://your-backend.com/job-risk-score"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": title,
        "description": description,
        "company": company,
        "salary": salary,
      }),
    );

    final data = jsonDecode(response.body);
    return data["risk_score"];
  }
}