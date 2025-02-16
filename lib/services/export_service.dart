import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart'; // ✅ For creating ZIP files
import '../models/user_model.dart';

class ExportService {
  static Future<String> generatePortfolio(UserModel user) async {
    String htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>${user.name}'s Portfolio</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
    </head>
    <body>
        <header>
            <h1>${user.name}</h1>
            <p>${user.bio}</p>
        </header>
        <section>
            <h2>Skills</h2>
            <ul>${user.skills.map((s) => "<li>$s</li>").join()}</ul>
        </section>
        <section>
            <h2>Projects</h2>
            <ul>${user.projects.map((p) => "<li><strong>${p["title"]}</strong>: ${p["description"]}</li>").join()}</ul>
        </section>
    </body>
    </html>
    """;

    String cssContent = """
    body {
        font-family: 'Arial', sans-serif;
        background: #f4f4f4;
        text-align: center;
    }
    header {
        background: #007bff;
        color: white;
        padding: 20px;
    }
    section {
        background: white;
        margin: 20px auto;
        padding: 20px;
        width: 80%;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
    }
    h1, h2 {
        color: #333;
    }
    ul {
        list-style-type: none;
        padding: 0;
    }
    ul li {
        background: #e9ecef;
        margin: 5px;
        padding: 10px;
        border-radius: 5px;
    }
    """;

    final directory = await getApplicationDocumentsDirectory();
    final htmlFile = File('${directory.path}/portfolio.html');
    final cssFile = File('${directory.path}/styles.css');

    await htmlFile.writeAsString(htmlContent);
    await cssFile.writeAsString(cssContent);

    // ✅ Create ZIP File
    final zipPath = await createPortfolioZip(directory.path);
    return zipPath;
  }

  static Future<String> createPortfolioZip(String dirPath) async {
    final zipEncoder = ZipEncoder();
    final archive = Archive();

    // Add files to ZIP
    archive.addFile(ArchiveFile('portfolio.html', File('$dirPath/portfolio.html').lengthSync(),
        File('$dirPath/portfolio.html').readAsBytesSync()));
    archive.addFile(ArchiveFile('styles.css', File('$dirPath/styles.css').lengthSync(),
        File('$dirPath/styles.css').readAsBytesSync()));

    // Encode archive
    final zipData = zipEncoder.encode(archive);
    final zipFile = File('$dirPath/portfolio.zip');
    await zipFile.writeAsBytes(zipData!);

    return zipFile.path;
  }
}
