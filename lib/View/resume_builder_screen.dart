import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kishan_test/Controller/resume_manager_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'pdf_view_page.dart';

class ResumeBuilderPage extends StatelessWidget {
  final ResumeController resumeController = Get.put(ResumeController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _addOrUpdateResume() {
    if (_formKey.currentState!.validate()) {
      final newData = {
        'name': nameController.text,
        'email': emailController.text,
        'phoneNumber': phoneNumberController.text,
        'education': educationController.text,
        'experience': experienceController.text,
        'skills': skillsController.text,
      };

      if (resumeController.selectedResumeIndex == -1) {
        resumeController.addResume(newData);
      } else {
        resumeController.updateResume(resumeController.selectedResumeIndex, newData);
      }

      nameController.clear();
      emailController.clear();
      phoneNumberController.clear();
      educationController.clear();
      experienceController.clear();
      skillsController.clear();
    }
  }

  void _deleteResume(int index) {
    resumeController.deleteResume(index);
    resumeController.selectedResumeIndex = -1;
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    educationController.clear();
    experienceController.clear();
    skillsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Builder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(controller: nameController, labelText: 'Name', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              }),
              _buildTextField(controller: emailController, labelText: 'Email', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              }),
              _buildTextField(controller: phoneNumberController, labelText: 'Phone Number', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              }),
              _buildTextField(controller: educationController, labelText: 'Education', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an education';
                }
                return null;
              }),
              _buildTextField(controller: experienceController, labelText: 'Experience', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an experience';
                }
                return null;
              }),
              _buildTextField(controller: skillsController, labelText: 'Skills', validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter skills';
                }
                return null;
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addOrUpdateResume,
                child: Text('Add/Update Resume'),
              ),
              SizedBox(height: 20),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    resumeController.resumes.length,
                        (index) => Card(
                      child: ListTile(
                        title: Text('Resume ${index + 1}'),
                        onTap: () {
                          resumeController.selectedResumeIndex = index;
                          final selectedResume = resumeController.resumes[index];
                          nameController.text = selectedResume['name']!;
                          emailController.text = selectedResume['email']!;
                          phoneNumberController.text = selectedResume['phoneNumber']!;
                          educationController.text = selectedResume['education']!;
                          experienceController.text = selectedResume['experience']!;
                          skillsController.text = selectedResume['skills']!;
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _deleteResume(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.visibility),
                              onPressed: () {
                                final selectedResume = resumeController.resumes[index];
                                resumeController.generatePdf(selectedResume);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }
}
