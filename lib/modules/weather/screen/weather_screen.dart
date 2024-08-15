import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:utilitarios/modules/weather/bloc/weather_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  Widget getWeatherIcon(int code) {
    switch (code) {
      case >= 200 && < 300:
        return Image.asset('assets/weather/1.png');
      case >= 300 && < 400:
        return Image.asset('assets/weather/2.png');
      case >= 500 && < 600:
        return Image.asset('assets/weather/3.png');
      case >= 600 && < 700:
        return Image.asset('assets/weather/4.png');
      case >= 700 && < 800:
        return Image.asset('assets/weather/5.png');
      case == 800:
        return Image.asset('assets/weather/6.png');
      case > 800 && <= 804:
        return Image.asset('assets/weather/7.png');
      default:
        return Image.asset('assets/weather/7.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: FutureBuilder(
          future: _determinePosition(),
          builder: (context, snap) {
            if (snap.hasData) {
              return BlocProvider<WeatherBloc>(
                create: (context) =>
                    WeatherBloc()..add(FetchWeather(snap.data!)), // as POSITION
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      40, 1.2 * kToolbarHeight, 40, 20),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(5, -0.3),
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepPurple),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-5, -0.3),
                          child: Container(
                            height: 300,
                            width: 300,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF673AB7)),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, -1.2),
                          child: Container(
                            height: 300,
                            width: 600,
                            decoration:
                                const BoxDecoration(color: Color(0xFFFFAB40)),
                          ),
                        ),
                        BackdropFilter(
                          filter:
                              ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.transparent),
                          ),
                        ),
                        BlocBuilder<WeatherBloc, WeatherState>(
                          builder: (context, state) {
                            if (state is WeatherSuccess) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '📍${state.weather.areaName}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const Text(
                                      'Bom Dia',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    getWeatherIcon(
                                        state.weather.weatherConditionCode!),
                                    Center(
                                      child: Text(
                                          '${state.weather.temperature!.celsius!.round()}°C',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 55,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    Center(
                                      child: Text(
                                          state.weather.weatherDescription!
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                    const SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        DateFormat('EEEE dd •')
                                            .add_jm()
                                            .format(state.weather.date!),
                                        // 'terça feira 14  • 10:00am',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/weather/11.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('SOL',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                const SizedBox(height: 3),
                                                Text(
                                                  DateFormat().add_jm().format(
                                                      state.weather.sunrise!),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/weather/12.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('LUA',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                const SizedBox(height: 3),
                                                Text(
                                                    DateFormat()
                                                        .add_jm()
                                                        .format(state
                                                            .weather.sunset!),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Divider(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/weather/13.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Temp Max',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                const SizedBox(height: 3),
                                                Text(
                                                    '${state.weather.tempMax!.celsius!.round().toString()}°C',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/weather/14.png',
                                              scale: 8,
                                            ),
                                            const SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Temp Min',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    )),
                                                const SizedBox(height: 3),
                                                Text(
                                                    '${state.weather.tempMin!.celsius!.round().toString()}°C',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Text('Error loading weather data');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
