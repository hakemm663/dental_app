import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/presentation/cubit/appointment_cubit.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentCubit>().getAllAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          }
          if (state.appointments.isEmpty) {
            return const Center(child: Text('No appointments found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.appointments.length,
            itemBuilder: (context, index) {
              final appointment = state.appointments[index];
              final doctor = appointment.doctor;
              final price = appointment.price;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: doctor?.image != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(doctor!.image!),
                        )
                      : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(doctor?.name ?? 'Doctor'),
                  subtitle: Text(
                    [
                      appointment.appointmentTime,
                      if (price != null) '\$${price.toStringAsFixed(0)}',
                    ].join('  •  '),
                  ),
                  trailing: Text(appointment.status ?? 'pending'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
