class FakeJobReport {
  final String companyName;
  final String description;
  final String? evidence;
  final String date;

  FakeJobReport({
    required this.companyName,
    required this.description,
    this.evidence,
    required this.date,
  });
}