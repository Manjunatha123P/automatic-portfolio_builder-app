class UserModel {
  String projectName;  // Added this line
  String name;
  String bio;
  String email;
  String profileImage;
  List<String> skills;
  List<Map<String, String>> projects;

  UserModel({
    required this.projectName,  // Updated this
    required this.name,
    required this.bio,
    required this.email,
    required this.profileImage,
    required this.skills,
    required this.projects,
  });

  Map<String, dynamic> toJson() => {
    "projectName": projectName,  // Updated this
    "name": name,
    "bio": bio,
    "email": email,
    "profileImage": profileImage,
    "skills": skills,
    "projects": projects,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    projectName: json["projectName"] ?? "",  // Updated this
    name: json["name"],
    bio: json["bio"],
    email: json["email"],
    profileImage: json["profileImage"],
    skills: List<String>.from(json["skills"]),
    projects: List<Map<String, String>>.from(json["projects"]),
  );
}
