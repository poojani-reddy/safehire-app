import 'package:flutter/material.dart';
import '../models/job.dart';

class JobCard extends StatelessWidget {
  final Job job;

  const JobCard({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(job.company),
            Text('Salary: ${job.salary}'),
            const SizedBox(height: 8),
            Text('Risk Score: ${job.riskScore.toStringAsFixed(1)}%'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Report'),
                ),
                TextButton(
                  onPressed: () {},
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