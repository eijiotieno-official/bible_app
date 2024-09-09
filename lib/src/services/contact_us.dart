import 'package:url_launcher/url_launcher.dart';

Future<void> contactUs() async {
  const emailAddress = "otienowatanabeeiji@gmail.com";
  const subject = "Inquiry Regarding Bible App";

  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: emailAddress,
    query: 'subject=$subject',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  }
}
