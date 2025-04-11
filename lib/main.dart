import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolinitpackage/adddartcodetoproject.dart';
import 'package:toolinitpackage/addpackage.dart';
import 'package:toolinitpackage/initplateformAndroidandios.dart';
import 'package:toolinitpackage/providerState.dart';
import 'package:toolinitpackage/providercontrollerstate.dart';

void main() {
  initshredprefrences();

  runApp(ProviderScope(child: _ProjectSelectorPageState()));
}

class _ProjectSelectorPageState extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainState = ref.watch(mainProvider);
    final mainNotifier = ref.read(mainProvider.notifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اداة اضافة مكتبة خرائط جوجل الى مجلد مشروع فلاتر',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromARGB(255, 110, 152, 199),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: 100, right: 100, left: 100, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '''
                  يجب ان يكون المشروع محتوي على ملف  main.dart 
                  ويحتوي ملف  main.dart  على scaffold
                  وفي داخل ويدجت scaffold لايوجد عنصر floatingactionbutton
                  ''',
                  textDirection: TextDirection.rtl,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                    Color.fromARGB(255, 110, 152, 199),
                  )),
                  onPressed: () async {
                    await pickProjectFolder(mainNotifier);
                  },
                  child: const Text(
                    'اختر مجلد المشروع',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (mainState.selectedPath != null)
                  Text('المجلد المختار:  ${mainState.selectedPath}',
                      textDirection: TextDirection.rtl),
                const SizedBox(height: 20),
                ...buildNotes(mainState),
                if (mainState.isPackageAddedAll == true)
                  buildApiKeyInput(
                    mainState,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> pickProjectFolder(
  MainProviderNotifier mainNotifier,
) async {
  String? path = await FilePicker.platform.getDirectoryPath();

  if (path != null) {
    // التحقق من وجود ملف pubspec.yaml
    File pubspecFile = File('$path/pubspec.yaml');
    bool exists = await pubspecFile.exists();
    mainNotifier.changeIsValiedAndpath(exists, path);
    if (exists) {
      await addGoogleMapsPackage(path, mainNotifier);
    }
  }
}

buildNotes(MainState mainState) {
  return [
    if (mainState.selectedPath != null)
      Text(
        mainState.isValidProject != null && mainState.isValidProject == true
            ? ' مشروع Flutter صالح'
            : ' هذا المجلد لا يحتوي على pubspec.yaml',
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: mainState.isValidProject != null &&
                  mainState.isValidProject == true
              ? Colors.green
              : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    Text(
      mainState.noteOfAddPackage != null ? '${mainState.noteOfAddPackage}' : '',
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: mainState.noteOfAddPackage != null
            ? mainState.noteOfAddPackage!.contains('')
                ? Colors.green
                : Colors.red
            : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    Text(
      mainState.noteOfRunflutterCommomd != null
          ? '${mainState.noteOfRunflutterCommomd}'
          : '',
      textDirection: TextDirection.rtl,
      style: TextStyle(
        color: mainState.noteOfRunflutterCommomd != null
            ? mainState.noteOfRunflutterCommomd!.contains('بنجاح')
                ? Colors.green
                : Colors.red
            : Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
  ];
}

TextEditingController apiKeyController = TextEditingController();
SharedPreferences? shre;
initshredprefrences() async {
  shre = await SharedPreferences.getInstance();
  apiKeyController.text =
      shre!.getString('apikey') == null ? '' : '${shre!.getString('apikey')}';
}

buildApiKeyInput(
  mainState,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (shre!.getString('apikey') == null)
        const Text('أدخل مفتاح Google Maps API',
            textDirection: TextDirection.rtl),
      TextField(
        controller: apiKeyController,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'مثال: AIzaxxxxxxxxxxxxxxx',
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
          Color.fromARGB(255, 110, 152, 199),
        )),
        onPressed: () async {
          String apiKey = apiKeyController.text.trim();

          if (await shre!.getString('apikey') != null) {
            apiKey = await shre!.getString('apikey') ?? '';
          } else {
            await shre!.setString('apikey', apiKey);
          }

          if (apiKey.isNotEmpty && mainState.selectedPath != null) {
            try {
              await insertApiKeyInAndroid(mainState.selectedPath!, apiKey);
              await insertApiKeyInIOS(mainState.selectedPath!, apiKey);
              await insertAndroidPermissions(mainState.selectedPath!);
              await insertIOSPermissions(mainState.selectedPath!);
              await createMapScreenFile(mainState.selectedPath!);
              await addMapScreenImport(mainState.selectedPath!);
              await addFloatingButtonToMain(mainState.selectedPath!);
            } catch (e) {
              print('error in save api key button');
            }
          }
        },
        child: const Text(
          'اضافة المفتاح ودمج جميع الاعدادات اللازمة لعمل مكتبة  جوجل ماب على المشروع',
          style: TextStyle(color: Colors.white),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Text(
        'لعرض الخريطة يجب الضغط على الزر العائم الموجود اسفل يمين الشاشة بداخل الصفحة الرئيسية بعد تنفيذ المشروع عبر محرر فلاتر ',
        textDirection: TextDirection.rtl,
      )
    ],
  );
}
