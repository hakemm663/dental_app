import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/cubit/doctors_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';

class FindNearbyScreen extends StatefulWidget {
  /// Optional doctor to focus on. When set, the map centers on this
  /// doctor's marker on first load and pre-opens the bottom card.
  final int? focusDoctorId;

  const FindNearbyScreen({super.key, this.focusDoctorId});

  @override
  State<FindNearbyScreen> createState() => _FindNearbyScreenState();
}

class _FindNearbyScreenState extends State<FindNearbyScreen> {
  final MapController _mapController = MapController();
  DoctorModel? _selectedDoctor;

  // Default center (Cairo, Egypt) used when no doctor has coords
  static const LatLng _defaultCenter = LatLng(30.0444, 31.2357);

  @override
  void initState() {
    super.initState();
    context.read<DoctorsCubit>().getAllDoctors();
  }

  DoctorModel? _pickFocus(List<DoctorModel> doctors) {
    final withCoords =
        doctors.where((d) => d.latitude != null && d.longitude != null);
    if (withCoords.isEmpty) return null;
    if (widget.focusDoctorId != null) {
      for (final d in withCoords) {
        if (d.id == widget.focusDoctorId) return d;
      }
    }
    return withCoords.first;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<DoctorsCubit, DoctorsState>(
          listenWhen: (prev, curr) {
            final prevHasCoords = prev.doctors.any((d) => d.latitude != null);
            final currHasCoords = curr.doctors.any((d) => d.latitude != null);
            return !prevHasCoords && currHasCoords;
          },
          listener: (context, state) {
            final focus = _pickFocus(state.doctors);
            if (focus == null) return;
            _mapController.move(
              LatLng(focus.latitude!, focus.longitude!),
              13,
            );
            if (widget.focusDoctorId != null && focus.id == widget.focusDoctorId) {
              setState(() => _selectedDoctor = focus);
            }
          },
          child: Stack(
            children: [
              BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  final doctors = state.doctors
                      .where((d) => d.latitude != null && d.longitude != null)
                      .toList();
                  final focus = _pickFocus(state.doctors);

                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: focus != null
                          ? LatLng(focus.latitude!, focus.longitude!)
                          : _defaultCenter,
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.docdoc.app',
                      ),
                      MarkerLayer(
                        markers: doctors.map((doctor) {
                          final isSelected =
                              _selectedDoctor?.id == doctor.id;
                          final size = isSelected ? 40.r : 28.r;
                          return Marker(
                            point:
                                LatLng(doctor.latitude!, doctor.longitude!),
                            width: size,
                            height: size,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedDoctor = doctor),
                              child: _DoctorMapMarker(
                                doctor: doctor,
                                selected: isSelected,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution('OpenStreetMap contributors'),
                        ],
                      ),
                    ],
                  );
                },
              ),

              // App bar overlay
              Positioned(top: 0, left: 0, right: 0, child: const _MapAppBar()),

              // Bottom doctor card
              if (_selectedDoctor != null)
                Positioned(
                  bottom: 16.h,
                  left: 16.w,
                  right: 16.w,
                  child: _SelectedDoctorCard(
                    doctor: _selectedDoctor!,
                    onTap: () => Navigator.of(context).pushNamed(
                      Routes.doctorDetails,
                      arguments: _selectedDoctor!.id,
                    ),
                  ),
                ),

              // Empty state when no doctors have coords
              BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  final hasCoords = state.doctors.any(
                    (d) => d.latitude != null,
                  );
                  if (!state.isLoading &&
                      !hasCoords &&
                      state.doctors.isNotEmpty) {
                    return Positioned(
                      bottom: 80.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'No nearby doctors yet',
                            style: TextStyles.font14GrayRegular,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapAppBar extends StatelessWidget {
  const _MapAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            elevation: 2,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text('Find Nearby', style: TextStyles.font18DarkBlueBold),
          ),
        ],
      ),
    );
  }
}

class _DoctorMapMarker extends StatelessWidget {
  final DoctorModel doctor;
  final bool selected;

  const _DoctorMapMarker({required this.doctor, this.selected = false});

  @override
  Widget build(BuildContext context) {
    // Small round pin so dense clusters (e.g. doctors in Mansoura) stay
    // readable; the selected marker grows + gets a blue ring.
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? ColorsManager.mainBlue : Colors.white,
          width: selected ? 3 : 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: doctor.image != null && doctor.image!.isNotEmpty
            ? Image.network(
                doctor.image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _InitialAvatar(name: doctor.name),
              )
            : _InitialAvatar(name: doctor.name),
      ),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;

  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.lightBlue,
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyles.font18DarkBlueBold.copyWith(
          color: ColorsManager.mainBlue,
        ),
      ),
    );
  }
}

class _SelectedDoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const _SelectedDoctorCard({required this.doctor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      elevation: 6,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 70.r,
                  height: 70.r,
                  color: ColorsManager.moreLighterGray,
                  child: doctor.image != null && doctor.image!.isNotEmpty
                      ? Image.network(
                          doctor.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              _InitialAvatar(name: doctor.name),
                        )
                      : _InitialAvatar(name: doctor.name),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorDisplayName(doctor.name),
                      style: TextStyles.font18DarkBlueBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${doctor.specializationName ?? 'General'}  |  ${doctor.address ?? ''}',
                      style: TextStyles.font13GrayRegular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 16.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          doctor.rating != null
                              ? doctor.rating!.toStringAsFixed(1)
                              : '—',
                          style: TextStyles.font14DarkBlueMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
