import 'package:pdf/widgets.dart' as pdfLib;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

import 'package:get/get.dart';

import '../View/pdf_view_page.dart';


class ResumeController extends GetxController {
  RxList<Map<String, String>> resumes = <Map<String, String>>[].obs;
  int selectedResumeIndex = -1;


  void addResume(Map<String, String> resumeData) {
    resumes.add(resumeData);
  }

  void updateResume(int index, Map<String, String> resumeData) {
    resumes[index] = resumeData;
  }

  void deleteResume(int index) {
    resumes.removeAt(index);
  }

  Future<void> generateResume(Map<String, String> newData) async {
    final pdfPath = await generatePdf(newData);
    addResume(newData);
  }


  Future<String> generatePdf(Map<String, String> resumeData) async {
    final pdf = pdfLib.Document();

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Text('Name: ${resumeData['name']}', style: pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text('Email: ${resumeData['email']}', style: pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text('Phone Number: ${resumeData['phoneNumber']}', style: pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text('Education: ${resumeData['education']}', style: pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text('Experience: ${resumeData['experience']}', style: pdfLib.TextStyle(fontSize: 20)),
              pdfLib.SizedBox(height: 10),
              pdfLib.Text('Skills: ${resumeData['skills']}', style: pdfLib.TextStyle(fontSize: 20)),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/resume_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    Get.to(() => PdfViewPage(pdfPath: file.path));
    return file.path;
  }
}
