import 'dart:io';

Future<void> insertApiKeyInAndroid(String projectPath, String apiKey) async {
  final manifestPath = '$projectPath/android/app/src/main/AndroidManifest.xml';
  final manifestFile = File(manifestPath);

  if (!await manifestFile.exists()) {
    print('لم يتم العثور على AndroidManifest.xml');
    return;
  }

  String content = await manifestFile.readAsString();

  // إذا تم إدخال المفتاح مسبقًا
  if (content.contains('com.google.android.geo.API_KEY')) {
    print('مفتاح API موجود مسبقًا');
    return;
  }

  final metaTag = '''
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="$apiKey"/>
  ''';

  // إدراج الـ meta داخل وسم <application>
  final updatedContent = content.replaceFirst(
    '<application',
    '<application$metaTag',
  );

  await manifestFile.writeAsString(updatedContent);
  print('تم إدراج مفتاح API في AndroidManifest.xml');
}

Future<void> insertApiKeyInIOS(String projectPath, String apiKey) async {
  final plistPath = '$projectPath/ios/Runner/Info.plist';
  final plistFile = File(plistPath);

  if (!await plistFile.exists()) {
    print('لم يتم العثور على Info.plist');
    return;
  }

  String content = await plistFile.readAsString();

  // تحقق إذا كان المفتاح موجود مسبقًا
  if (content.contains('io.flutter.embedded_views_preview')) {
    print('مفتاح API موجود مسبقًا في Info.plist');
    return;
  }

  final metaEntry = '''
	<key>io.flutter.embedded_views_preview</key>
	<true/>
	<key>GMSApiKey</key>
	<string>$apiKey</string>
  ''';

  final updatedContent = content.replaceFirst(
    '</dict>',
    '$metaEntry\n</dict>',
  );

  await plistFile.writeAsString(updatedContent);
  print('تم إدراج مفتاح API في Info.plist');
}

Future<void> insertAndroidPermissions(String projectPath) async {
  final manifestPath = '$projectPath/android/app/src/main/AndroidManifest.xml';
  final manifestFile = File(manifestPath);

  if (!await manifestFile.exists()) return;

  String content = await manifestFile.readAsString();

  if (!content.contains('ACCESS_FINE_LOCATION')) {
    content = content.replaceFirst(
      '<manifest',
      '''<manifest
    xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>''',
    );

    await manifestFile.writeAsString(content);
    print('تمت إضافة التصاريح في AndroidManifest.xml');
  } else {
    print('تصاريح Android موجودة مسبقًا');
  }
}

Future<void> insertIOSPermissions(String projectPath) async {
  final plistPath = '$projectPath/ios/Runner/Info.plist';
  final plistFile = File(plistPath);

  if (!await plistFile.exists()) return;

  String content = await plistFile.readAsString();

  if (!content.contains('NSLocationWhenInUseUsageDescription')) {
    final permissionText = '''
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>نحتاج للوصول إلى موقعك لعرض الموقع على الخريطة</string>
  <key>NSLocationAlwaysUsageDescription</key>
  <string>نحتاج للوصول إلى موقعك حتى عند تشغيل التطبيق في الخلفية</string>
    ''';

    content = content.replaceFirst('</dict>', '$permissionText\n</dict>');
    await plistFile.writeAsString(content);
    print('تمت إضافة التصاريح في Info.plist');
  } else {
    print('تصاريح iOS موجودة مسبقًا');
  }
}
