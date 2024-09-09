import 'package:url_launcher/url_launcher.dart';

Future<void> contactUs() async {
  final emailAddress = "";
  final subject = "";

  final url =
      "https://mail.google.com/mail/?view=cm&fs=1&to=$emailAddress&su=$subject";

  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
