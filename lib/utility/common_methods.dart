import 'package:demo/provider/Model/chatmodel.dart';
import 'package:demo/provider/Model/user.dart';

String createKeyForChatRoom(List<User> usersArray) {
  usersArray.sort((a, b) => a.user_email.compareTo(b.user_email));
  return "${usersArray[0].user_id}_${usersArray[1].user_id}";
}

String nameFromEmail(String email) {
  return email.split("@")[0];
}

String precisionChatText(Chat objChat, User usermine, User userother) {
  return objChat.sender_id == usermine.user_id
      ? "Me:> ${objChat.message}"
      : "${nameFromEmail(userother.user_email)}:> ${objChat.message}";
}

bool isMyMessage(Chat objChat, User usermine, User userother) {
  return objChat.sender_id == usermine.user_id
      ? true : false;
}
