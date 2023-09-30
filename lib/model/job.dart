import 'package:project_whss_app/model/item.dart';

class Job {
  final String jobName;
  final List<Item> items;

  Job({required this.jobName, required this.items});

  factory Job.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Item> itemList = itemsList.map((item) => Item.fromJson(item)).toList();

    return Job(
      jobName: json['jobName'],
      items: itemList,
    );
  }
}