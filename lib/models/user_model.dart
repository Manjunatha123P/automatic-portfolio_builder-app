class UserModel {
  final String projectName;
  final String name;
  final String bio;
  final String email;
  final String? profileImage; // Make profileImage nullable
  final List<String> skills;
  final List<Project> projects; // Use a Project class

  UserModel({
    required this.projectName,
    required this.name,
    required this.bio,
    required this.email,
    this.profileImage,
    required this.skills,
    required this.projects,
  });

  // Add a factory constructor to create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    projectName: json['projectName'],
    name: json['name'],
    bio: json['bio'],
    email: json['email'],
    profileImage: json['profileImage'],
    skills: List<String>.from(json['skills']),
    projects: List<Project>.from(json['projects'].map((project) => Project.fromJson(project))),
  );

  // Add a toJson method to convert a UserModel to a JSON map
  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'name': name,
    'bio': bio,
    'email': email,
    'profileImage': profileImage,
    'skills': skills,
    'projects': projects.map((project) => project.toJson()).toList(),
  };
}


class Project {
  final String title;
  final String description;
  final String? link; // link can be optional

  Project({required this.title, required this.description, this.link});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    title: json['title'],
    description: json['description'],
    link: json['link'],
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'link': link,
  };
}