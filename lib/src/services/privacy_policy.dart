import 'package:url_launcher/url_launcher.dart';

Future<void> privacyPolicy() async {
  const url =
      "https://github.com/eijiotieno-official/bible-app-privacy-policy/blob/main/privacy_policy";

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
