import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/job.dart';

/*class MLService {
  static late Interpreter _interpreter;

  static Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('fake_job_detector.tflite');  // Replace with your model file name
    } catch (e) {
      throw Exception("Error loading model: $e");
    }
  }

  static Future<Job> analyzeJob(Map<String, String> jobDetails) async {
    try {
      // Prepare the input data for the model
      final input = _prepareInputData(jobDetails);

      // Prepare an output buffer (based on your model output)
      final output = List.filled(2, 0.0).reshape([1, 2]);

      // Run inference with the model
      _interpreter.run(input, output);

      // Process the output from the model
      final riskScore = output[0][0];  // Assuming first index is the risk score
      final isGenuine = output[0][1] > 0.5;  // Assuming second index indicates genuine or fake

      // Return the job details with the risk score and fake/genuine status
      return Job(
        id: '',  // Generate or fetch ID if needed
        title: jobDetails['title']!,
        description: jobDetails['description']!,
        company: jobDetails['company']!,
        salary: jobDetails['salary']!,
        riskScore: riskScore
        
      );
    } catch (e) {
      throw Exception("Error analyzing job: $e");
    }
  }

  static Map<String, dynamic> _prepareInputData(Map<String, String> jobDetails) {
    // Prepare the input data based on your model’s input format
    // This might require you to convert the text into embeddings, vectors, etc. before feeding it to the model
    return {
      'title': jobDetails['title'],
      'description': jobDetails['description'],
      'company': jobDetails['company'],
      'salary': jobDetails['salary'],
    };
  }

  static void close() {
    _interpreter.close();
  }
}*/
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/job.dart';

class MLService {
  static Future<Job> analyzeJob(Map<String, String> jobDetails) async {
    final title = jobDetails['title'] ?? '';
    final description = jobDetails['description'] ?? '';
    final company = jobDetails['company'] ?? '';
    final salary = jobDetails['salary'] ?? '';

    // 🧠 Fetch fake risk score using your logic
    final riskScore = await _fetchRiskScore(title, description, company, salary);

    // 💡 Decide if job is genuine or fake based on threshold
    final isGenuine = riskScore < 50;

    return Job(
      title: title,
      description: description,
      company: company,
      salary: salary,
      riskScore: double.parse(riskScore.toStringAsFixed(2)), // Rounded to 2 decimals
      isGenuine: isGenuine, id: '',
    );
  }

  static Future<double> _fetchRiskScore(
    String title,
    String description,
    String company,
    String salary,
  ) async {
    try {
      final random = Random();

    // Generate realistic random scores
    // You can use conditions to simulate logic
    if (company.toLowerCase().contains("pvt") && description.toLowerCase().contains("work from home") && title.toLowerCase().contains("intern")) {
      return 60 + random.nextInt(30) + random.nextDouble(); // 60% to 90%
    } else if (description.toLowerCase().contains("mnc") && salary.toLowerCase().contains("lpa") ) {
      return 20 + random.nextInt(30) + random.nextDouble(); // 20% to 50%
    } else {
      return 35 + random.nextInt(40) + random.nextDouble(); // 35% to 75%
    }
    } catch (e) {
      debugPrint("Error generating fake risk score: $e");
      return 50.0; // Fallback
    }
  }
}

