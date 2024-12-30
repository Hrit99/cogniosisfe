class Habit {
  final String name;
  bool isActive;
  String? time;
  List<String>? days;
  DateTime? date;

  Habit({required this.name, this.isActive = false, this.time = 'Anytime', this.days, this.date});
} 