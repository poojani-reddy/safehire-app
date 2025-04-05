import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/add_experience_dialog.dart';
import '../widgets/add_fake_job_report_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExperienceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddExperienceDialog(),
    );
  }

  void _showAddFakeJobDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddFakeJobReportDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    userProvider.userEmail ?? 'email@example.com',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Personal Information
            _buildSection(
              'Personal Information',
              [
                _buildInfoRow('Name', userProvider.userName ?? 'Not set'),
                _buildInfoRow('Email', userProvider.userEmail ?? 'Not set'),
                _buildInfoRow('Phone', userProvider.phone ?? 'Not set'),
                _buildInfoRow('Location', userProvider.location ?? 'Not set'),
              ],
            ),

            // Job Preferences
            _buildSection(
              'Job Preferences',
              [
                _buildInfoRow('Industry', userProvider.industry ?? 'Not set'),
                _buildInfoRow('Job Type', userProvider.jobType ?? 'Not set'),
                _buildInfoRow('Experience', userProvider.experience ?? 'Not set'),
                _buildInfoRow('Expected Salary', userProvider.salary ?? 'Not set'),
              ],
            ),

            // Activity History
            _buildSection(
              'Activity History',
              [
                ListTile(
                  leading: const Icon(Icons.work),
                  title: const Text('Job Applications'),
                  trailing: Text(
                    userProvider.applicationCount?.toString() ?? '0',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.verified),
                  title: const Text('Verifications'),
                  trailing: Text(
                    userProvider.verificationCount?.toString() ?? '0',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Reviews'),
                  trailing: Text(
                    userProvider.reviewCount?.toString() ?? '0',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),

            // User Experiences Section
            _buildSection(
              'Experiences & Reports',
              [
                // Add Experience Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddExperienceDialog(context),
                    icon: const Icon(Icons.add_comment),
                    label: const Text('Share Your Experience'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ),
                // Add Fake Job Report Button
                ElevatedButton.icon(
                  onPressed: () => _showAddFakeJobDialog(context),
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('Report Fake Job'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.red[400],
                  ),
                ),
                const SizedBox(height: 16),
                // List of user's experiences
                ...userProvider.experiences.map((exp) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(exp.title),
                    subtitle: Text(exp.description),
                    trailing: Text(exp.date),
                  ),
                )),
                // List of fake job reports
                ...userProvider.fakeJobReports.map((report) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: Colors.red[50],
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.red),
                    title: Text(report.companyName),
                    subtitle: Text(report.description),
                    trailing: Text(report.date),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}