class MessageData {
  String username;
  String message;
  String profile;
  String time_stamp;

  MessageData(
      {required this.profile,
        required this.username,
        required this.message,
        required this.time_stamp});
}

class UserGroupData {
  String image;
  String username;
  String top_message;
  String status;
  var chat_page_id;

  UserGroupData(
      {required this.image,
        required this.username,
        required this.top_message,
        required this.chat_page_id,
        required this.status});
}

Map clientUserDataGlobal = {};