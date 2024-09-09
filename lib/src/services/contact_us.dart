import 'package:url_launcher/url_launcher.dart';

Future<void> contactUs() async {
  const emailAddress = "otienowatanabeeiji@gmail.com";
  const subject = "Inquiry Regarding Bible App";

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
