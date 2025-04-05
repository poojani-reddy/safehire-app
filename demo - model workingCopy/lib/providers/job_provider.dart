import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import '../models/job.dart';
import '../models/message.dart';
import '../api_key.dart'; // Ensure API keys are stored properly

class JobProvider with ChangeNotifier {
  final List<Job> _jobs = [];
  final List<Message> _messages = [];

  List<Job> get jobs => _jobs;
  List<Message> get messages => _messages;

  /// Adds a job with risk score fetched from Firebase
  Future<Job> addJob(
      String title, String description, String company, String salary) async {
    double riskScore = await _fetchRiskScore(title, description, company, salary);

    final job = Job(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      company: company,
      salary: salary,
      riskScore: riskScore,
    );

    _jobs.add(job);
    notifyListeners();
    return job;
  }

  /// Fetches risk score for a job from Firebase
  Future<double> _fetchRiskScore(
      String title, String description, String company, String salary) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('job_risk_scores')
          .doc('$title-$company')
          .get();

      if (snapshot.exists) {
        return snapshot['riskScore']?.toDouble() ?? 50.0;
      } else {
        return 50.0;
      }
    } catch (e) {
      debugPrint("Error fetching risk score: $e");
      return 50.0;
    }
  }

  /// Handles user messages and fetches AI-generated responses
  void sendMessage(String content) async {
    _messages.add(Message(content: content, isUser: true, type: MessageType.text));
    notifyListeners();

    String aiResponse = await _fetchAIResponse(content);

    _messages.add(Message(content: aiResponse, isUser: false, type: MessageType.aiResponse));
    notifyListeners();
  }

  /// AI Assistant Response Handling
  Future<String> _fetchAIResponse(String query) async {
    const String groqApiKey = GROQ_API_KEY;

    try {
      // Check if user is asking about a job posting
      if (query.toLowerCase().contains("why is this job fake")) {
        return await _explainFakeJob(query);
      } else if (query.toLowerCase().contains("suggest genuine jobs")) {
        return await _suggestGenuineJobs();
      } else {
        // General AI response for job-related questions
        final response = await http.post(
          Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $groqApiKey",
          },
          body: jsonEncode({             
            "model": "llama-3.3-70b-versatile",
            "messages": [
              {"role": "system", "content": "You are a job search assistant."},
              {"role": "user", "content": query},
            ],
            "max_tokens": 200,
            "temperature": 0.7,
          }),
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body)["choices"][0]["message"]["content"].trim();
        } else {
          debugPrint("AI Response Error: ${response.statusCode}");
          debugPrint("AI Response Error: ${response.body}");
          return "Error: Unable to fetch AI response.";
        }
      }
    } catch (e) {
      debugPrint("Exception in AI fetch: $e");
      return "Error: $e";
    }
  }

  /// Explains why a job is fake based on ML model analysis
  Future<String> _explainFakeJob(String query) async {
    try {
      String jobTitle = query.replaceAll("why is this job fake", "").trim();
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('job_analysis')
          .doc(jobTitle)
          .get();

      if (snapshot.exists) {
        return snapshot['fakeReason'] ?? "No specific reason found.";
      } else {
        return "I don't have information about this job.";
      }
    } catch (e) {
      debugPrint("Error fetching fake job reason: $e");
      return "Unable to determine why this job is fake.";
    }
  }

  /// Suggests genuine jobs based on user preferences
  Future<String> _suggestGenuineJobs() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('verified_jobs')
          .limit(5)
          .get();

      if (snapshot.docs.isNotEmpty) {
        List<String> jobList = snapshot.docs.map((doc) => doc['title'] as String).toList();
        return "Here are some genuine job recommendations:\n${jobList.join('\n')}";
      } else {
        return "No verified job listings available at the moment.";
      }
    } catch (e) {
      debugPrint("Error fetching genuine jobs: $e");
      return "Unable to retrieve job recommendations.";
    }
  }

  /// Report a job by increasing its report count
  void reportJob(String jobId) {
    final job = _jobs.firstWhere((job) => job.id == jobId);
    job.reportCount++;
    notifyListeners();
  }

  /// Vote a job as genuine or fake
  void voteJob(String jobId, bool isGenuine) {
    final job = _jobs.firstWhere((job) => job.id == jobId);
    if (isGenuine) {
      job.genuineVotes++;
    } else {
      job.fakeVotes++;
    }
    notifyListeners();
  }
}
