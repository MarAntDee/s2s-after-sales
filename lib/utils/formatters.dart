class TimeFormatter {
  String timeLeft(int time) {
    int minutes = (time / 60).truncate();
    String minStr = (minutes % 60).toString().padLeft(2, '0');
    String secStr = (time % 60).toString().padLeft(2, '0');
    return "$minStr:$secStr";
  }
}
