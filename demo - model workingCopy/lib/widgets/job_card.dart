import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/job.dart';
import '../models/user_experience.dart';
import '../models/fake_job_report.dart';
import '../providers/user_provider.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.title, style: Theme.of(context).textTheme.titleLarge),
            Text(job.company),
            Text('Salary: ${job.salary}'),
            const SizedBox(height: 8),
            Text('Risk Score: ${job.riskScore.toStringAsFixed(1)}%'),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 🚨 Report Button
                TextButton(
                  onPressed: () {
                    final report = FakeJobReport(
                      companyName: job.company,
                      description: 'Suspicious job reported: ${job.title}',
                      date: DateTime.now().toIso8601String().split('T')[0],
                    );

                    userProvider.addFakeJobReport(report);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('🚨 Job reported as fake')),
                    );
                  },
                  child: const Text('Report'),
                ),

                // ✅ Vote Button
                TextButton(
                  onPressed: () {
                    final experience = UserExperience(
                      title: 'Voted: ${job.title}',
                      description: 'User marked job at ${job.company} as trusted',
                      date: DateTime.now().toIso8601String().split('T')[0],
                    );

                    userProvider.addExperience(experience);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✅ Voted as trusted')),
                    );
                  },
                  child: const Text('Vote'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
