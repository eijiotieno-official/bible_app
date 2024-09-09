import 'package:share_plus/share_plus.dart';

Future<void> inviteFriend() async {
  final message = "";
  await Share.share(message);
}
