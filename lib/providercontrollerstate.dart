import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toolinitpackage/providerState.dart';


class MainProviderNotifier extends StateNotifier<MainState> {
  MainProviderNotifier() : super(MainState(isValidProject: false));

  void changeIsValiedAndpath(bool isvalied, String path) {
    state = state.copyWith(isValidProject: isvalied, selectedPath: path);
  }

  void changeNotesAddPackage(String note) {
    state = state.copyWith(noteOfAddPackage: note);
  }

  void changeNotesRunflutterCommomd(String note, bool isPackageAdded) {
    state = state.copyWith(
        noteOfRunflutterCommomd: note, isPackageAddedAll: isPackageAdded);
  }

  void changeIsAddedAll(bool isAdded, String path) {
    state = state.copyWith(isPackageAddedAll: isAdded, selectedPath: path);
  }
}

// مزود للحالة
final mainProvider =
    StateNotifierProvider<MainProviderNotifier, MainState>((ref) {
  return MainProviderNotifier();
});
