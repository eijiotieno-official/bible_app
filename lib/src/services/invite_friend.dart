import 'package:share_plus/share_plus.dart';

Future<void> inviteFriend() async {
  const String appLink = 'https://example.com/download';
  const String message = '''
Hey! 🙌
I’ve been using this amazing Bible app and thought you might love it too! It’s a great way to dive deeper into God’s word and stay connected. 📖✨
You can download it here: $appLink
Blessings!
  ''';

  await Share.share(message);
}
