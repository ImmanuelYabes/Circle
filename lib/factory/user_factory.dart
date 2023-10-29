class UserCircle {
  String uid;
  String name;
  String email;
  DateTime birthDate;
  String profileUrl;
  String aboutMe;
  List<String> interest;
  String facebook;
  String instagram;
  String twitter;
  int age = -1;
  UserCircle({required this.uid, required this.name, required this.email, required this.birthDate, required this.profileUrl, required this.aboutMe, required this.interest, required this.facebook, required this.instagram, required this.twitter}) {
    age = DateTime.now().year - birthDate.year;
    if (DateTime.now().month < birthDate.month ||
        (DateTime.now().month == birthDate.month && DateTime.now().day < birthDate.day)) {
      age--;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'birthdate': birthDate,
      'profileUrl': profileUrl,
      'aboutMe': aboutMe,
      'interest': interest,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter
    };
  }
}