
import 'dart:io';
Future<void> createMapScreenFile(String projectPath) async {
  final filePath = '$projectPath/lib/map_screen.dart';
  final mapScreenFile = File(filePath);

  if (await mapScreenFile.exists()) {
    print('الملف map_screen.dart موجود بالفعل');
    return;
  }

  const mapScreenCode = '''
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _initialPosition = const LatLng(24.7136, 46.6753); // الرياض

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('خريطة Google')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
  ''';

  await mapScreenFile.writeAsString(mapScreenCode);
  print('تم إنشاء ملف map_screen.dart');
}
Future<void> addMapScreenImport(String projectPath) async {
  final mainPath = '$projectPath/lib/main.dart';
  final mainFile = File(mainPath);

  if (!await mainFile.exists()) return;

  String content = await mainFile.readAsString();

  if (!content.contains("import 'map_screen.dart'")) {
    content = "import 'map_screen.dart';\n" + content;
    await mainFile.writeAsString(content);
    print('تمت إضافة import لـ map_screen.dart في main.dart');
  } else {
    print('الـ import موجود بالفعل');
  }
}


// ملاحظة: الكود يفترض أن هناك Scaffold في main.dart.
Future<void> addFloatingButtonToMain(String projectPath) async {
  final mainPath = '$projectPath/lib/main.dart';
  final mainFile = File(mainPath);

  if (!await mainFile.exists()) return;

  String content = await mainFile.readAsString();

  if (content.contains('floatingActionButton')) {
    print('زر عائم موجود مسبقًا');
    return;
  }

  final scaffoldStartIndex = content.indexOf('Scaffold(');
  if (scaffoldStartIndex == -1) {
    print('لم يتم العثور على Scaffold');
    return;
  }

  // نبدأ من بعد Scaffold( ونحسب الأقواس
  int openParens = 1;
  int currentIndex = scaffoldStartIndex + 'Scaffold('.length;

  while (currentIndex < content.length && openParens > 0) {
    if (content[currentIndex] == '(') openParens++;
    if (content[currentIndex] == ')') openParens--;
    currentIndex++;
  }

  if (openParens != 0) {
    print('حدث خلل في تتبع إغلاق الأقواس');
    return;
  }

  // الآن currentIndex هو بعد نهاية Scaffold(...)
  final insertPosition = currentIndex - 1;

  const fabCode = '''
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MapScreen()),
      );
    },
    child: Icon(Icons.map),
  ),
''';

  // نحاول إدخال الكود قبل إغلاق القوس الأخير لـ Scaffold
  final updatedContent = content.substring(0, insertPosition) +
      fabCode +
      content.substring(insertPosition);

  await mainFile.writeAsString(updatedContent);
  print('تمت إضافة الزر العائم بشكل صحيح بعد Scaffold');
}
