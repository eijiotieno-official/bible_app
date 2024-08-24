enum BibleVersion {
  kjv,
  niv,
}


// Function to convert a string to BibleVersion enum value
BibleVersion stringToBibleVersion(String string) => BibleVersion.values
    .firstWhere((e) => e.toString().split('.').last == string);

// Function to convert a BibleVersion enum value to string
String bibleVersionToString(BibleVersion version) =>
    version.toString().substring(version.toString().indexOf('.') + 1);
