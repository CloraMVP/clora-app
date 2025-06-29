import 'package:flutter/material.dart';

class Gynecologist {
  final String name;
  final String qualification;
  final String specialization;
  final int experience;
  final String image;
  final int fee;

  Gynecologist({
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.image,
    required this.fee,
  });
}

class GynecologistCarousel extends StatelessWidget {
  final List<Gynecologist> doctors;
  final void Function(Gynecologist doctor) onConsultNow;

  const GynecologistCarousel({
    super.key,
    required this.doctors,
    required this.onConsultNow,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            "Recommended Gynecologists",
            style: TextStyle(
              fontFamily: 'ComicNeue',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCDF),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        doctor.image,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicNeue',
                      ),
                    ),
                    Text(
                      doctor.qualification,
                      style: const TextStyle(fontFamily: 'ComicNeue'),
                    ),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(fontFamily: 'ComicNeue'),
                    ),
                    Text(
                      "${doctor.experience} yrs exp",
                      style: const TextStyle(fontFamily: 'ComicNeue'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => onConsultNow(doctor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        minimumSize: const Size(double.infinity, 30),
                      ),
                      child: Text("Consult ₹${doctor.fee}"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
