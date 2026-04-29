import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/logic/cubit/doctor_details_cubit.dart';
import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/routes.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final int doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  @override
  void initState() {
    super.initState();
    getIt<DoctorDetailsCubit>().getDoctorDetails(widget.doctorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          final doctor = state.doctor;
          if (doctor == null) {
            return const Center(child: Text('No doctor found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Text(doctor.name[0]),
                  ),
                ),
                const SizedBox(height: 16),
                Text(doctor.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(doctor.address ?? 'No address',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 16),
                if (doctor.fees != null)
                  Text('Fees: \$${doctor.fees}',
                      style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                if (doctor.rating != null)
                  Text('Rating: ${doctor.rating}/5',
                      style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                if (doctor.bio != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bio',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(doctor.bio!),
                      const SizedBox(height: 16),
                    ],
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        Routes.bookAppointment,
                        arguments: doctor,
                      );
                    },
                    child: const Text('Book Appointment'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
