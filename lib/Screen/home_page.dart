import 'package:diacritic/diacritic.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_forecast/API/weatherProvider.dart';
import 'package:weather_forecast/Screen/search_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../Helper/utils.dart';
import 'package:weather_forecast/Screen/weekly_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "";

  void getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
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
    final Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double latitude = 21.028511;
    double longitude = 105.804817;
    final coordinates = Coordinates(latitude, longitude);
    List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    Address first = addresses.first;
    location = removeDiacritics(first.adminArea!);
  }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final weather = provider.state.currentWeather; 
    final hourlyForecasts = provider.state.currentWeather?.hourlyForecasts;

    if (weather == null) {
      provider.fetchWeather(location);
    }

    if (weather != null) {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                        Icons.settings,
                        size: 30,
                      color: Colors.black,
                    ),
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SearchCity()),
                        );
                      },
                      child: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MapString.mapStringToIcon(weather.weatherCondition),
                    size: 65,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${weather.temperature}°C',
                    style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'H: ${weather.maxTemp}°C',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'L: ${weather.minTemp}°C',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                weather.weatherCondition,
                style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 160),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Forecast 24 Hours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeeklyPage()),
                        );
                      },
                      child: const Text(
                        'Weekly Forecast',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: SizedBox(
                  height: 160,
                  child: ListView.builder(
                      itemCount: hourlyForecasts?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: ((context, index) {
                        int forecastTemperature = hourlyForecasts![index]['temp_c'].toInt();
                        String forecastTime = hourlyForecasts[index]['time'].substring(11, 16);
                        String forecastHour = forecastTime.substring(0, 2);
                        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
                        String currentHour = currentTime.substring(0, 2);
                        String forecastWeatherName = hourlyForecasts[index]['condition']['text'];

                        return Container(
                          width: 80,
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: currentHour == forecastHour ? Colors.blue[300] : Colors.white,
                            border: Border.all(color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                forecastTime,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                MapString.mapStringToIcon(forecastWeatherName),
                                size: 50,
                                color: Colors.blue,
                              ),
                              Text(
                                '$forecastTemperature°C',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        );
                      } )
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: MediaQuery.of(context).size.width * .04,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.weatherRainy,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Precipitation',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  '${weather.precipitation} mn',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          height: 65,
                        ),
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.sunWireless,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'UV Index',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  UvIndex.mapUviValueToString(uvi: weather.uvIndex),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.weatherWindy,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Wind',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  '${weather.windSpeed} km/h ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          height: 65,

                        ),
                        Row(
                          children: [
                            const Icon(
                              MdiIcons.waterPercent,
                              color: Colors.blue,
                              size: 40,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Humidity',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17
                                  ),
                                ),
                                Text(
                                  '${weather.humidity}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SizedBox(
                height: 320,
                child: SizedBox(
                  child: SfRadialGauge(
                    title: const GaugeTitle(
                      text: 'Air Quality Index',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22
                      )
                    ),
                    axes: <RadialAxis> [
                      RadialAxis(
                        showTicks: false,
                        showAxisLine: false,
                        showLastLabel: true,
                        labelsPosition: ElementsPosition.outside,
                        startAngle: 180,
                        endAngle: 0,
                        minimum: 0,
                        maximum: 500,
                        axisLabelStyle: const GaugeTextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        ranges: <GaugeRange> [
                          GaugeRange(
                            startValue: 0, 
                            endValue: 50,
                            color: Colors.green,
                            startWidth: 50,
                            endWidth: 50,
                          ),
                          GaugeRange(
                            startValue: 50, 
                            endValue: 100,
                            color: Colors.yellow,
                            startWidth: 50,
                            endWidth: 50,
                          ),
                          GaugeRange(
                            startValue: 100, 
                            endValue: 150,
                            color: Colors.orange,
                            startWidth: 50,
                            endWidth: 50,
                          ),
                          GaugeRange(
                            startValue: 150, 
                            endValue: 200,
                            color: Colors.red,
                            startWidth: 50,
                            endWidth: 50,
                          ),
                          GaugeRange(
                            startValue: 200, 
                            endValue: 300,
                            color: Colors.pink[900],
                            startWidth: 50,
                            endWidth: 50,
                          ),
                          GaugeRange(
                            startValue: 300, 
                            endValue: 500,
                            color: const Color.fromRGBO(128, 0, 0, 1),
                            startWidth: 50,
                            endWidth: 50,
                          )
                        ],
                        pointers: <GaugePointer> [
                          NeedlePointer(
                            value: weather.aqi.toDouble(),
                          )
                        ],
                        annotations: <GaugeAnnotation> [
                          GaugeAnnotation(
                            widget: Text(
                              weather.aqi.toString(),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ) ,
                            angle: 90,
                            positionFactor: 0.2,
                          ),
                          GaugeAnnotation(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.green,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Good",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.yellow,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Moderate",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.orange,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Unhealthy\nfor\nSensitive\nGroups",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.red,
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Unhealthy",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: Colors.pink[900],
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Very\nUnhealthy",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        color: const Color.fromRGBO(128, 0, 0, 1),
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                    const Text(
                                      "Hazardeous",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    )
                                  ],
                                ),
                              ]
                            ) ,
                            angle: 90,
                            positionFactor: 1.4,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}