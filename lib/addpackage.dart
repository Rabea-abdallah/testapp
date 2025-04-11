import 'dart:io';

import 'package:toolinitpackage/providercontrollerstate.dart';

Future<void> addGoogleMapsPackage(
    String projectPath, MainProviderNotifier mainNotifier) async {
  final pubspecPath = '$projectPath/pubspec.yaml';
  final pubspecFile = File(pubspecPath);

  if (!await pubspecFile.exists()) {
    print('ملف pubspec.yaml غير موجود');

    mainNotifier.changeNotesAddPackage('ملف pubspec.yaml غير موجود');

    return;
  }

  List<String> lines = await pubspecFile.readAsLines();
  bool alreadyAdded = lines.any((line) => line.contains('google_maps_flutter'));

  if (alreadyAdded) {
    print('الحزمة مضافة مسبقًا');
    mainNotifier.changeNotesAddPackage(' الحزمة مضافة مسبقًا');
    mainNotifier.changeIsAddedAll(true, projectPath);
    // mainNotifier.changeIsValiedAndpath(true, projectPath);

    return;
  }

  // إضافة الحزمة داخل قسم dependencies
  final updatedLines = <String>[];
  bool dependenciesFound = false;

  for (var line in lines) {
    updatedLines.add(line);
    if (line.trim() == 'dependencies:') {
      dependenciesFound = true;
      updatedLines.add('  google_maps_flutter: ^2.5.0'); // يمكنك تعديل الرقم
    }
  }

  if (!dependenciesFound) {
    updatedLines.add('dependencies:');
    updatedLines.add('  google_maps_flutter: ^2.5.0');
  }

  await pubspecFile.writeAsString(updatedLines.join('\n'));
  mainNotifier.changeNotesAddPackage('تمت إضافة الحزمة بنجاح');
  runFlutterPubGet(projectPath, mainNotifier);
  print('تمت إضافة الحزمة بنجاح');
}
// ---

// 2. تنفيذ flutter pub get تلقائيًا:

Future<void> runFlutterPubGet(
    String projectPath, MainProviderNotifier mainNotifier) async {
  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: projectPath,
    runInShell: true,
  );

  if (result.exitCode == 0) {
    print('تم تنفيذ flutter pub get بنجاح');
    mainNotifier.changeNotesRunflutterCommomd(
        'تم تنفيذ flutter pub get بنجاح', true);
    mainNotifier.changeIsAddedAll(true, projectPath);
  } else {
    print('فشل تنفيذ flutter pub get');
    mainNotifier.changeNotesRunflutterCommomd(
        'فشل تنفيذ flutter pub get', false);

    print(result.stderr);
  }
}


// ---

// 3. ربط الخطوتين:

// بعد اختيار المجلد والتحقق أنه مشروع صحيح، نستدعي:

// await addGoogleMapsPackage(selectedPath!);
// await runFlutterPubGet(selectedPath!);


// ---

// ملاحظات مهمة:

// تأكد أن التطبيق لديك يعمل بصلاحيات كافية للوصول للملفات.

// استخدم runInShell: true حتى يعمل flutter داخل Process.



// ---

// هل تود أن أدمج هذا الكود مع الخطوة الأولى ونبني صفحة كاملة تظهر للمستخدم أنه تم الدمج؟ أم ننتقل مباشرة للخطوة الثالثة (إدخال مفتاح Google Maps API)؟

