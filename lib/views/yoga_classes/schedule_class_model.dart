class ScheduleClassModel {
  final String image;
  final String title;
  final String description;
  final String speaker;
  final DateTime classDate;
  final String time;
  final String type;
  final String id;
  final int availableTicket;
  final int listIndex;

  ScheduleClassModel({
    required this.image,
    required this.title,
    required this.description,
    required this.speaker,
    required this.classDate,
    required this.time,
    required this.type,
    required this.id,
    required this.availableTicket,
    required this.listIndex
  });
}