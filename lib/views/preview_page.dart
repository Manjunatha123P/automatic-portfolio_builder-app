import 'dart:io'; // Import for File
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/user_model.dart';
import '../services/export_service.dart';

class PreviewPage extends StatefulWidget {
  final UserModel user;
  const PreviewPage({super.key, required this.user});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  bool _isDownloading = false;

  Future<void> _downloadAndSharePortfolio() async {
    setState(() => _isDownloading = true);

    String? zipPath;

    try {
      zipPath = await ExportService.generatePortfolio(widget.user);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error generating portfolio: $e")),
        );
      }
    }

    setState(() => _isDownloading = false);

    if (zipPath != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Portfolio ZIP saved at: $zipPath")),
      );

      try {
        await Share.shareXFiles([XFile(zipPath)], text: "Download your portfolio!");
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error sharing file: $e")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Make it scrollable
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.user.profileImage != null)
                Image.file(File(widget.user.profileImage!), height: 200),
              Text(widget.user.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(widget.user.bio),
              const SizedBox(height: 20),

              // Display Projects
              if (widget.user.projects.isNotEmpty) ...[
                const Text("Projects", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                for (var project in widget.user.projects) ...[
                  Text(project.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(project.description),
                  if (project.link != null)
                    Text("Link: ${project.link}"),
                  const SizedBox(height: 10),
                ],
              ],

              _isDownloading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _downloadAndSharePortfolio,
                child: const Text("Download Portfolio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}