// To parse this JSON data, do
//
//     final customHomeScreen = customHomeScreenFromJson(jsonString);

import 'dart:convert';

CustomHomeScreen customHomeScreenFromJson(String str) => CustomHomeScreen.fromJson(json.decode(str));

String customHomeScreenToJson(CustomHomeScreen data) => json.encode(data.toJson());

class CustomHomeScreen {
    CustomHomeScreen({
        this.id,
        this.title,
        this.description,
        this.startTime,
        this.endTime,
        this.createdAt,
        this.updatedAt,
        this.formattedDate,
        this.formattedUpdatedDate,
        this.photo,
    });

    int id;
    String title;
    String description;
    String startTime;
    String endTime;
    DateTime createdAt;
    DateTime updatedAt;
    String formattedDate;
    String formattedUpdatedDate;
    String photo;

    factory CustomHomeScreen.fromJson(Map<String, dynamic> json) => CustomHomeScreen(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        formattedDate: json["formatted_date"],
        formattedUpdatedDate: json["formatted_updated_date"],
        photo: json["photo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "formatted_date": formattedDate,
        "formatted_updated_date": formattedUpdatedDate,
        "photo": photo,
    };
}
