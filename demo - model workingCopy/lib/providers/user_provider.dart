import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/user_experience.dart';
import '../models/fake_job_report.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final Map<String, UserCredentials> _userCredentials = {};
  String? _userName;
  String? _userEmail;
  String? _phone;
  String? _location;
  String? _industry;
  String? _jobType;
  String? _experience;
  String? _salary;
  int? _applicationCount;
  int? _verificationCount;
  int? _reviewCount;

  final List<UserExperience> _experiences = [];
  final List<FakeJobReport> _fakeJobReports = [];

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get phone => _phone;
  String? get location => _location;
  String? get industry => _industry;
  String? get jobType => _jobType;
  String? get experience => _experience;
  String? get salary => _salary;
  int? get applicationCount => _applicationCount;
  int? get verificationCount => _verificationCount;
  int? get reviewCount => _reviewCount;

  List<UserExperience> get experiences => List.unmodifiable(_experiences);
  List<FakeJobReport> get fakeJobReports => List.unmodifiable(_fakeJobReports);

  Future<void> registerUser(String email, String password, String name) async {
    if (_userCredentials.containsKey(email)) {
      throw 'Email already registered';
    }

    _userCredentials[email] = UserCredentials(
      email: email,
      password: password,
      name: name,
    );
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final credentials = _userCredentials[email];
    if (credentials == null) {
      throw 'User not found';
    }
    if (credentials.password != password) {
      throw 'Invalid password';
    }

    _user = User(
      id: email,
      name: credentials.name,
      badges: ['New User'],
    );
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void updateBadges(String badge) {
    if (_user != null) {
      _user!.badges.add(badge);
      notifyListeners();
    }
  }

  void setUserDetails({String? name, String? email}) {
    _userName = name;
    _userEmail = email;
    notifyListeners();
  }

  void updateUserDetails({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? industry,
    String? jobType,
    String? experience,
    String? salary,
  }) {
    _userName = name ?? _userName;
    _userEmail = email ?? _userEmail;
    _phone = phone ?? _phone;
    _location = location ?? _location;
    _industry = industry ?? _industry;
    _jobType = jobType ?? _jobType;
    _experience = experience ?? _experience;
    _salary = salary ?? _salary;
    notifyListeners();
  }

  void updateActivityCounts({
    int? applications,
    int? verifications,
    int? reviews,
  }) {
    _applicationCount = applications ?? _applicationCount;
    _verificationCount = verifications ?? _verificationCount;
    _reviewCount = reviews ?? _reviewCount;
    notifyListeners();
  }

  void addExperience(UserExperience experience) {
    _experiences.add(experience);
    // TODO: Save to database
    notifyListeners();
  }

  void addFakeJobReport(FakeJobReport report) {
    _fakeJobReports.add(report);
    // TODO: Save to database
    notifyListeners();
  }
}

class UserCredentials {
  final String email;
  final String password;
  final String name;

  UserCredentials({
    required this.email,
    required this.password,
    required this.name,
  });
} 