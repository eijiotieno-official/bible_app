import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UserActionServices {
  static Future<void> contactUs() async {
    const emailAddress = "otienowatanabeeiji@gmail.com";
    const subject = "Inquiry Regarding The Word";

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
      }),
    );

    await launchUrl(emailUri);
  }

  static Future<void> inviteFriend() async {
    const String appLink = 'https://example.com/download';
    const String message = '''
                      Hey! 🙌
                      I’ve been using this amazing The Word and thought you might love it too! It’s a great way to dive deeper into God’s word and stay connected. 📖✨
                      You can download it here: $appLink
                      Blessings!
                        ''';

    await Share.share(message);
  }

  static Future<void> privacyPolicy() async {
    const url =
        "https://docs.google.com/document/d/e/2PACX-1vTQf43End-1qpuWrkHCDZzWEB4Y8IAcy0bJs-fP7WAymUqDsxGH4gvkd9Yfsgf8hoiHuwUxDulx8Hyn/pub";

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
