class MainState {
  final String? selectedPath;
  final bool? isValidProject;
  final String? noteOfAddPackage;
  final String? noteOfRunflutterCommomd;
  final bool? isPackageAddedAll;

  MainState({
    this.isValidProject,
    this.selectedPath,
    this.noteOfAddPackage,
    this.noteOfRunflutterCommomd,
    this.isPackageAddedAll,
  });

  MainState copyWith({
    String? selectedPath,
    bool? isValidProject,
    String? noteOfAddPackage,
    String? noteOfRunflutterCommomd,
    bool? isPackageAddedAll,
  }) {
    return MainState(
      selectedPath: selectedPath ?? this.selectedPath,
      isValidProject: isValidProject ?? this.isValidProject,
      noteOfAddPackage: noteOfAddPackage ?? this.noteOfAddPackage,
      noteOfRunflutterCommomd:
          noteOfRunflutterCommomd ?? this.noteOfRunflutterCommomd,
      isPackageAddedAll: isPackageAddedAll ?? this.isPackageAddedAll,
    );
  }
}
