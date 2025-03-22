String getDirection(var angle) {
  var direc;
  if (angle == null) {
    direc = 'Unknown';
  } else if (angle != null) {
    if (angle >= 337.5 || angle <= 22.5) {
      direc = 'N';
    } else if (angle > 22.5 && angle <= 67.5) {
      direc = 'NE';
    } else if (angle > 67.5 && angle <= 112.5) {
      direc = 'E';
    } else if (angle > 112.5 && angle <= 157.5) {
      direc = 'SE';
    } else if (angle > 157.5 && angle <= 202.5) {
      direc = 'S';
    } else if (angle > 202.5 && angle <= 247.5) {
      direc = 'SW';
    } else if (angle > 247.5 && angle <= 292.5) {
      direc = 'W';
    } else if (angle > 292.5 && angle < 337.5) {
      direc = 'NW';
    } else {
      direc = 'Unknown';
    }
  } else {
    direc = 'Unknown';
  }
  return direc;
}
