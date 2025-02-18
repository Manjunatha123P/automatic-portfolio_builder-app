import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';

class ExportService {
  static Future<String?> generatePortfolio(UserModel user) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final htmlFile = File('${directory.path}/portfolio.html');
      final cssFile = File('${directory.path}/styles.css');
      final profileImageFile = user.profileImage != null ? File(user.profileImage!) : null;

      await htmlFile.writeAsString(_generateHtml(user));
      await cssFile.writeAsString(_generateCss());

      if (profileImageFile != null) {
        final lastDotIndex = profileImageFile.path.lastIndexOf('.');
        if (lastDotIndex != -1) {
          final newProfileImagePath =
              '${directory.path}/profile_image${profileImageFile.path.substring(lastDotIndex)}';
          await profileImageFile.copy(newProfileImagePath);
        }
      }

      final zipPath = await _createPortfolioZip(directory.path, user);
      return zipPath;
    } catch (e) {
      debugPrint("Error generating portfolio: $e");
      return null;
    }
  }

  static String _generateHtml(UserModel user) {
    final profileImageTag = user.profileImage != null
        ? '<img src="profile_image${user.profileImage!.substring(user.profileImage!.lastIndexOf('.'))}" alt="Profile Image" width="200">'
        : '';

    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${user.name}'s Portfolio</title>
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <header>
            <h1>${user.name}</h1>
            <p>${user.bio}</p>
        </header>

        <section id="profile">
          $profileImageTag
        </section>

        <section id="skills">
            <h2>Skills</h2>
            <ul>${user.skills.map((skill) => "<li>$skill</li>").join()}</ul>
        </section>

        <section id="projects">
            <h2>Projects</h2>
            <ul>${user.projects.map((project) => "<li><strong>${project.title}</strong>: ${project.description}${project.link != null ? ' (<a href="${project.link}">Link</a>)' : ''}</li>").join()}</ul>
        </section>
    </body>
    </html>
    """;
  }

  static String _generateCss() {
    return """
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f4f4f4;
        color: #333;
        margin: 0;
        padding: 0;
    }

    header {
        background-color: #007bff;
        color: white;
        padding: 20px;
        text-align: center;
    }

    #profile {
      text-align: center;
      margin-bottom: 20px;
    }

    #profile img {
      border-radius: 50%;
      border: 3px solid #fff;
    }

    section {
        background-color: white;
        margin: 20px auto;
        padding: 20px;
        width: 80%;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }

    h2 {
        color: red;
    }

    ul {
        list-style: none;
        padding: 0;
    }

    li {
        margin-bottom: 10px;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    a {
      color: #007bff;
      text-decoration: none;
    }
    """;
  }

  static Future<String> _createPortfolioZip(String dirPath, UserModel user) async {
    final zipEncoder = ZipEncoder();
    final archive = Archive();

    final htmlFile = File('$dirPath/portfolio.html');
    final cssFile = File('$dirPath/styles.css');

    archive.addFile(ArchiveFile('portfolio.html', htmlFile.lengthSync(), htmlFile.readAsBytesSync()));
    archive.addFile(ArchiveFile('styles.css', cssFile.lengthSync(), cssFile.readAsBytesSync()));

    if (user.profileImage != null) {
      final lastDotIndex = user.profileImage!.lastIndexOf('.');
      if (lastDotIndex != -1) {
        final extension = user.profileImage!.substring(lastDotIndex);
        final profileImageFile = File('$dirPath/profile_image$extension');
        if (profileImageFile.existsSync()) {
          archive.addFile(ArchiveFile(
            profileImageFile.path.split('/').last,
            profileImageFile.lengthSync(),
            profileImageFile.readAsBytesSync(),
          ));
        }
      }
    }

    final zipData = zipEncoder.encode(archive);
    final zipFile = File('$dirPath/portfolio.zip');
    await zipFile.writeAsBytes(zipData);

    return zipFile.path;
  }
}
