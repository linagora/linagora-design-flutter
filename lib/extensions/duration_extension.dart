extension DurationExtension on Duration {
  String mediaTimeLength() {
    const String separator = ':';
    final String minute = inMinutes.toString().padLeft(1, '0');
    final String second =
        (this - Duration(minutes: inMinutes)).inSeconds
            .toString()
            .padLeft(2, '0');
    return '$minute$separator$second';
  }
}