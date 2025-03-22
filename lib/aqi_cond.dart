String get_aqi_cond(var aqi) {
  var now_aqi;
  if (aqi == null) {
    now_aqi = 'Unknown';
  } else if (aqi >= 0 && aqi <= 50) {
    now_aqi = 'Good';
  } else if (aqi >= 51 && aqi <= 100) {
    now_aqi = 'Moderate';
  } else if (aqi >= 101 && aqi <= 150) {
    now_aqi = 'Unhealthy for sensitive groups';
  } else if (aqi >= 151 && aqi <= 200) {
    now_aqi = 'Unhealthy';
  } else if (aqi >= 201 && aqi <= 300) {
    now_aqi = 'Very Unhealthy';
  } else {
    now_aqi = 'Hazardous';
  }
  return now_aqi;
}
