import 'package:flutter/material.dart';

class JobFilterSheet extends StatefulWidget {
  const JobFilterSheet({super.key});

  @override
  State<JobFilterSheet> createState() => _JobFilterSheetState();
}

class _JobFilterSheetState extends State<JobFilterSheet> {
  RangeValues _salaryRange = const RangeValues(0, 200000);
  double _maxRiskScore = 100;
  bool _showVerifiedOnly = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Jobs',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Salary Range'),
          RangeSlider(
            values: _salaryRange,
            max: 200000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_salaryRange.start.round()}',
              '\$${_salaryRange.end.round()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _salaryRange = values;
              });
            },
          ),
          const SizedBox(height: 16),
          const Text('Maximum Risk Score'),
          Slider(
            value: _maxRiskScore,
            max: 100,
            divisions: 10,
            label: '${_maxRiskScore.round()}%',
            onChanged: (double value) {
              setState(() {
                _maxRiskScore = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Show Verified Jobs Only'),
            value: _showVerifiedOnly,
            onChanged: (bool value) {
              setState(() {
                _showVerifiedOnly = value;
              });
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Apply filters
                Navigator.pop(context, {
                  'salaryRange': _salaryRange,
                  'maxRiskScore': _maxRiskScore,
                  'verifiedOnly': _showVerifiedOnly,
                });
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
} 