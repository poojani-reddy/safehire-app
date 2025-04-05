import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/fake_job_report.dart';

class ShareExperienceScreen extends StatefulWidget {
  const ShareExperienceScreen({super.key});

  @override
  State<ShareExperienceScreen> createState() => _ShareExperienceScreenState();
}

class _ShareExperienceScreenState extends State<ShareExperienceScreen> {
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _experienceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _descriptionController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      final report = FakeJobReport(
        companyName: _companyController.text,
        description: _descriptionController.text,
        evidence: _experienceController.text,
        date: DateTime.now().toString().split(' ')[0],
      );

      context.read<UserProvider>().addFakeJobReport(report);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for sharing your experience!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Experience'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Help others by reporting fake job postings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Company Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  labelText: 'Job Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'What made you think this job was fake? *',
                  border: OutlineInputBorder(),
                  hintText: 'Describe the red flags or suspicious elements',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide details about the fake job posting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Share Your Experience (Optional)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _experienceController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Your Experience',
                  border: OutlineInputBorder(),
                  hintText: 'Share your experience to help others...',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.colorScheme.primary,
                ),
                child: const Text(
                  'Submit Report',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 