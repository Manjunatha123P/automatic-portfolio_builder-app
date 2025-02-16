import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'preview_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<String> skills = [];
  List<Map<String, String>> projects = [];

  void addProject() {
    projects.add({"title": "New Project", "description": "Description", "link": ""});
    setState(() {});
  }

  void submit() {
    UserModel user = UserModel(
      projectName: _projectNameController.text,
      name: _nameController.text,
      bio: _bioController.text,
      email: _emailController.text,
      profileImage: "https://via.placeholder.com/150",
      skills: skills,
      projects: projects,
    );

    Navigator.push(context, MaterialPageRoute(builder: (_) => PreviewPage(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Portfolio Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _projectNameController, decoration: const InputDecoration(labelText: "Project Name")),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Your Name")),
            TextField(controller: _bioController, decoration: const InputDecoration(labelText: "Bio")),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            ElevatedButton(onPressed: addProject, child: const Text("Add Project")),
            ElevatedButton(onPressed: submit, child: const Text("Generate Portfolio")),
          ],
        ),
      ),
    );
  }
}
