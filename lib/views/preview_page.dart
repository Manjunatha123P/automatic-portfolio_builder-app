import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../models/user_model.dart';
import '../services/export_service.dart';

class PreviewPage extends StatefulWidget {
  final UserModel user;
  const PreviewPage({super.key, required this.user});

  @override
  PreviewPageState createState() => PreviewPageState();
}

class PreviewPageState extends State<PreviewPage> {
  bool _isDownloading = false; // ✅ For UI animation

  void downloadPortfolio() async {
    setState(() => _isDownloading = true);

    String zipPath = await ExportService.generatePortfolio(widget.user);
    print("Portfolio ZIP saved at: $zipPath");

    setState(() => _isDownloading = false);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Portfolio ZIP saved at: $zipPath")),
    );

    // ✅ Share the ZIP file
    Share.shareXFiles([XFile(zipPath)], text: "Download your portfolio!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Portfolio Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(widget.user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.user.bio),
            const SizedBox(height: 20),

            // ✅ Download Button with Animation
            _isDownloading
                ? const CircularProgressIndicator() // ✅ Show loading animation
                : ElevatedButton(
              onPressed: downloadPortfolio,
              child: const Text("Download Portfolio"),
            ),
          ],
        ),
      ),
    );
  }
}
