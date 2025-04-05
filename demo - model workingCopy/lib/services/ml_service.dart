import 'package:tflite_flutter/tflite_flutter.dart';
import '../models/job.dart';

class MLService {
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
}
