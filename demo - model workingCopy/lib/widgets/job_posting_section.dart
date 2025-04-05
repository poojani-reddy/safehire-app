import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/job_provider.dart';
import 'job_card.dart';

class JobPostingSection extends StatelessWidget {
  const JobPostingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {
              _showJobPostingDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Job Posting'),
          ),
        ),
        Expanded(
          child: Consumer<JobProvider>(
            builder: (context, jobProvider, child) {
              return ListView.builder(
                itemCount: jobProvider.jobs.length,
                itemBuilder: (context, index) {
                  return JobCard(job: jobProvider.jobs[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showJobPostingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const JobPostingDialog(),
    );
  }
}

class JobPostingDialog extends StatefulWidget {
  const JobPostingDialog({super.key});

  @override
  State<JobPostingDialog> createState() => _JobPostingDialogState();
}

class _JobPostingDialogState extends State<JobPostingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _companyController = TextEditingController();
  final _salaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Job Posting'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Job Title'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: 'Company'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter company name' : null,
              ),
              TextFormField(
                controller: _salaryController,
                decoration: const InputDecoration(labelText: 'Salary Range'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter salary range' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Job Description'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter description' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              // Add job posting
              context.read<JobProvider>().addJob(
                    _titleController.text,
                    _descriptionController.text,
                    _companyController.text,
                    _salaryController.text,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
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