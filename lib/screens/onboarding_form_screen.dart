import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class OnboardingFormScreen extends StatefulWidget {
  const OnboardingFormScreen({super.key});

  @override
  State<OnboardingFormScreen> createState() => _OnboardingFormScreenState();
}

class _OnboardingFormScreenState extends State<OnboardingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String dob = '';
  String city = '';
  String medicalHistory = '';
  String lastPeriodDate = '';
  int cycleLength = 28;
  bool _isSaving = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isSaving = true);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final updatedData = {
          'dob': dob,
          'city': city,
          'medicalHistory': medicalHistory,
          'lastPeriodDate': lastPeriodDate.isEmpty ? '01-06-2024' : lastPeriodDate,
          'cycleLength': cycleLength,
        };

        await FirestoreService.saveUserProfile(uid, updatedData);

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Date of Birth (DD-MM-YYYY)", hint: "e.g. 10-09-1995", onSaved: (val) => dob = val!),
              _buildTextField("City / Zip", onSaved: (val) => city = val!),
              _buildTextField("Medical History", onSaved: (val) => medicalHistory = val ?? ''),
              _buildTextField("Last Period Date (DD-MM-YYYY)", hint: "Optional", optional: true, onSaved: (val) => lastPeriodDate = val ?? ''),
              _buildTextField("Cycle Length (days)", hint: "Default is 28", optional: true, isNumber: true, onSaved: (val) => cycleLength = int.tryParse(val ?? '28') ?? 28),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Save & Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, {
        String? hint,
        bool optional = false,
        bool isNumber = false,
        required void Function(String?) onSaved,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: optional ? null : (val) => val == null || val.isEmpty ? 'Required' : null,
        onSaved: onSaved,
      ),
    );
  }
}
