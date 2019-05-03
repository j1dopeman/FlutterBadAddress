// To parse this JSON data, do
//
//     final session = sessionFromJson(jsonString);

import 'dart:convert';

Session sessionFromJson(String str) => Session.fromMap(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toMap());

class Session {
  int sessionId;
  int serverId;
  String userId;
  String date;
  bool complete;
  bool uploaded;

  Session({
    this.sessionId,
    this.serverId,
    this.userId,
    this.date,
    this.complete,
    this.uploaded,
  });

  factory Session.fromMap(Map<String, dynamic> json) => new Session(
        sessionId: json["session_id"],
        serverId: json["server_id"],
        userId: json["user_id"],
        date: json["date"],
        complete: json["complete"] == 1 ? true : false,
        uploaded: json["uploaded"] == 1 ? true : false,
      );

  Map<String, dynamic> toMap() => {
        "session_id": sessionId,
        "server_id": serverId,
        "user_id": userId,
        "date": date,
        "complete": complete,
        "uploaded": uploaded,
      };
}
