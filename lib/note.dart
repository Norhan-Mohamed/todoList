class Note {
  dynamic _date;
  static late String _task;
  int? _id;
  bool? isChecked = false;

  Note(dynamic obj) {
    _id = obj['id'];
    _date = obj['date'];
    _task = obj['task'];
    isChecked = obj['isChecked'] ?? false;
  }

  Note.fromMap(Map<String, dynamic> data) {
    _id = data['id'];
    _date = data['date'];
    _task = data['task'];
    isChecked = data['isChecked'];
  }

  Map<String, dynamic> toMap() =>
      {'id': _id, 'task': _task, 'date': _date, 'isChecked': isChecked};

  int? get id => _id;

  String get task => _task;

  dynamic get date => _date;
}
