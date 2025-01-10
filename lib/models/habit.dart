class Habit {
  int id;
  final String name;
  String? time;
  List<String>? days;

  Habit({  this.id = 0, required this.name, this.time = 'Anytime', this.days});
} 