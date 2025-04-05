import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/fake_job_report.dart';

class AddFakeJobReportDialog extends StatefulWidget {
  const AddFakeJobReportDialog({super.key});

  @override
  State<AddFakeJobReportDialog> createState() => _AddFakeJobReportDialogState();
}

class _AddFakeJobReportDialogState extends State<AddFakeJobReportDialog> {
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _evidenceController = TextEditingController();

  @override
  void dispose() {
    _companyController.dispose();
    _descriptionController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_companyController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    final report = FakeJobReport(
      companyName: _companyController.text,
      description: _descriptionController.text,
      evidence: _evidenceController.text,
      date: DateTime.now().toString().split(' ')[0],
    );

    context.read<UserProvider>().addFakeJobReport(report);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Report Fake Job'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _companyController,
            decoration: const InputDecoration(
              labelText: 'Company Name',
              hintText: 'Enter company name',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the fake job posting...',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _evidenceController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Evidence (Optional)',
              hintText: 'Any links or evidence to support your report',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
          ),
          child: const Text('Submit Report'),
        ),
      ],
    );
  }
}