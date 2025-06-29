import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GynecologistListScreen extends StatelessWidget {
const GynecologistListScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("Available Gynecologists"),
backgroundColor: Colors.purple.shade400,
),
body: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
colors: [Color(0xFFFFFCD0), Color(0xFFD8CFF7)],
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
),
),
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
child: StreamBuilder<QuerySnapshot>(
stream: FirebaseFirestore.instance.collection('gynecologists').snapshots(),
builder: (context, snapshot) {
if (snapshot.connectionState == ConnectionState.waiting) {
return const Center(child: CircularProgressIndicator());
}
if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
return const Center(child: Text("No gynecologists available right now."));
}

final doctors = snapshot.data!.docs;

return ListView.separated(
itemCount: doctors.length,
separatorBuilder: (_, __) => const SizedBox(height: 12),
itemBuilder: (context, index) {
final doc = doctors[index];
return Container(
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: Colors.white.withOpacity(0.9),
borderRadius: BorderRadius.circular(16),
boxShadow: const [
BoxShadow(
color: Colors.black12,
blurRadius: 6,
offset: Offset(1, 2),
),
],
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
children: [
ClipRRect(
borderRadius: BorderRadius.circular(12),
child: Image.network(
doc['image'] ?? 'https://via.placeholder.com/70',
height: 70,
width: 70,
fit: BoxFit.cover,
),
),
const SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(doc['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
Text(doc['qualification']),
Text(doc['specialization']),
Text("Experience: ${doc['experience']}"),
],
),
)
],
),
const SizedBox(height: 8),
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text("Consultation Fee: ₹${doc['fee']}",
style: const TextStyle(fontWeight: FontWeight.bold)),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.purple.shade400,
),
onPressed: () {
// TODO: Navigate to ConsultationChatScreen or trigger payment
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(content: Text("Feature coming soon for ${doc['name']}")),
);
},
child: const Text('Consult Now'),
),
],
)
],
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
