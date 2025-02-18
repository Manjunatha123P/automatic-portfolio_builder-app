import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
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
  List<Project> projects = []; // Use the Project class

  File? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _profileImage = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  void addProject() {
    projects.add(Project(title: "New Project", description: "Description", link: ""));
    setState(() {});
  }

  void submit() {
    UserModel user = UserModel(
      projectName: _projectNameController.text,
      name: _nameController.text,
      bio: _bioController.text,
      email: _emailController.text,
      profileImage: _profileImage?.path,
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
        child: SingleChildScrollView( // Make it scrollable
          child: Column(
            children: [
              TextField(controller: _projectNameController, decoration: const InputDecoration(labelText: "Project Name")),
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Your Name")),
              TextField(controller: _bioController, decoration: const InputDecoration(labelText: "Bio")),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),

              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Pick Profile Image"),
              ),
              if (_profileImage != null)
                Image.file(_profileImage!, height: 100),

              ListView.builder(
                shrinkWrap: true,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectWidget(
                    project: projects[index],
                    onProjectUpdated: (updatedProject) {
                      setState(() {
                        projects[index] = updatedProject;
                      });
                    },
                  );
                },
              ),
              ElevatedButton(onPressed: addProject, child: const Text("Add Project")),

              ElevatedButton(onPressed: submit, child: const Text("Generate Portfolio")),
            ],
          ),
        ),
      ),
    );
  }
}


class ProjectWidget extends StatefulWidget {
  final Project project;
  final Function(Project) onProjectUpdated;

  const ProjectWidget({super.key, required this.project, required this.onProjectUpdated});

  @override
  _ProjectWidgetState createState() => _ProjectWidgetState();
}

class _ProjectWidgetState extends State<ProjectWidget> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _linkController = TextEditingController(text: widget.project.link ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Project Title"),
              onChanged: (value) {
                widget.onProjectUpdated(Project(
                  title: value,
                  description: widget.project.description,
                  link: widget.project.link,
                ));
              },
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Project Description"),
              onChanged: (value) {
                widget.onProjectUpdated(Project(
                  title: widget.project.title,
                  description: value,
                  link: widget.project.link,
                ));
              },
            ),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(labelText: "Project Link (Optional)"),
              onChanged: (value) {
                widget.onProjectUpdated(Project(
                  title: widget.project.title,
                  description: widget.project.description,
                  link: value,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}