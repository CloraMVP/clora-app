import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultationHistoryScreen extends StatelessWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Consultation History"),
        backgroundColor: Colors.purple.shade400,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFCDF), Color(0xFFD8CFF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('consultations')
              .where('userId', isEqualTo: userId)
              .orderBy('startedAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No consultation history found.",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final consultations = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: consultations.length,
              itemBuilder: (context, index) {
                final doc = consultations[index];
                final doctor = doc['doctor'] ?? 'Unknown Doctor';
                final topic = doc['topic'] ?? 'General';
                final fee = doc['fee'] ?? '₹--';
                final status = doc['status'] ?? 'unknown';
                final ts = (doc['startedAt'] as Timestamp?)?.toDate();
                final dateStr = ts != null ? DateFormat('dd MMM yyyy').format(ts) : '---';

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Topic: $topic",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Fee: $fee | Status: ${status[0].toUpperCase()}${status.substring(1)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Date: $dateStr",
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                        // Optional: Tap to reopen chat
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(...);
                        //   },
                        //   child: const Text("Open Chat"),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
