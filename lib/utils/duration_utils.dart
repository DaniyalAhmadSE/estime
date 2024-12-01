class DurationUtils {
  double convertDurationToSeconds(double duration, String unit) {
    switch (unit) {
      case "seconds":
        return duration;
      case "minutes":
        return getMinutesInSeconds(duration);
      case "hours":
        return getHoursInSeconds(duration);
      default:
        throw Exception("Invalid Unit");
    }
  }

  double getMinutesInSeconds(double minutes) => minutes * 60;
  double getHoursInSeconds(double hours) => hours * 60 * 60;
}
