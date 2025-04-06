import 'package:flutter/material.dart';
import '../services/ml_service.dart';  // Connects to fake ML logic
import '../models/job.dart';          // Job model
import '../widgets/risk_score_indicator.dart';  // For visual score indicator

class JobAnalysisScreen extends StatefulWidget {
  const JobAnalysisScreen({super.key});

  @override
  State<JobAnalysisScreen> createState() => _JobAnalysisScreenState();
}

class _JobAnalysisScreenState extends State<JobAnalysisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _salaryController = TextEditingController();
  bool _isAnalyzing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Analysis'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter job title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter company name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(
                  labelText: 'Salary Range',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter salary range' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Job Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter job description' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeJob,
                child: _isAnalyzing
                    ? const CircularProgressIndicator()
                    : const Text('Analyze Job Posting'),
              ),
              if (_isAnalyzing) const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _analyzeJob() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isAnalyzing = true);

      try {
        final jobDetails = {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'company': _companyController.text,
          'salary': _salaryController.text,
        };

        final result = await MLService.analyzeJob(jobDetails);

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AnalysisResultDialog(job: result),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isAnalyzing = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _companyController.dispose();
    _salaryController.dispose();
    super.dispose();
  }
}

class AnalysisResultDialog extends StatelessWidget {
  const AnalysisResultDialog({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Analysis Result'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RiskScoreIndicator(score: job.riskScore),
          const SizedBox(height: 16),
          Text(
            'This job posting appears to be ${job.isGenuine ? 'genuine ✅' : 'fake ⚠️'}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // You can trigger your AI assistant screen here
            },
            child: const Text('Ask AI Assistant for details'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
