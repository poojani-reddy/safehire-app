class Job {
  final String id;
  final String title;
  final String description;
  final String company;
  final String salary;
  final double riskScore;
  int reportCount;
  int genuineVotes;
  int fakeVotes;

  bool get isGenuine => riskScore < 50;


  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.salary,
    required this.riskScore,
    this.reportCount = 0,
    this.genuineVotes = 0,
    this.fakeVotes = 0,
  });
} 