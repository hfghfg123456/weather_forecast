import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UvIndex {
  static String mapUviValueToString({required dynamic uvi}) {
    String uvIndex;
    if (uvi <= 2) {
      return uvIndex = 'Low';
    } else if (uvi <= 5) {
      return uvIndex = 'Medium';
    } else if (uvi <= 7) {
      return uvIndex = 'High';
    } else if (uvi <= 10) {
      return uvIndex = 'Very High';
    } else if (uvi >= 11) {
      return uvIndex = 'Extreme';
    } else {
      uvIndex = 'Unknown';
    }
    return uvIndex;
  }
}

class MapString {
  static IconData mapStringToIcon(String input) {
    IconData icon;
    switch (input) {
      case 'Patchy rain possible':
        icon = MdiIcons.weatherPartlyRainy;
        break;
      case 'Light rain':
        icon = MdiIcons.weatherLightningRainy;
        break;
      case 'Light drizzle':
        icon = MdiIcons.weatherHazy;
        break;
      case 'Snow':
        icon = MdiIcons.weatherSnowy;
        break;
      case 'Clear':
        icon = MdiIcons.weatherSunny;
        break;
      case 'Clouds':
        icon = MdiIcons.weatherCloudy;
        break;
      case 'Mist':
        icon = MdiIcons.weatherFog;
        break;
      case 'fog':
        icon = MdiIcons.weatherFog;
        break;
      case 'Light rain shower':
        icon = MdiIcons.weatherNightPartlyCloudy;
        break;
      case 'Overcast':
        icon = MdiIcons.weatherDust;
        break;
      case 'Dust':
      case 'Sand':
      case 'Ash':
        icon = MdiIcons.weatherDust;
        break;
      case 'Squall':
      case 'Tornado':
        icon = MdiIcons.weatherTornado;
        break;
      default:
        icon = MdiIcons.weatherCloudy;
    }
    return icon;
  }
}