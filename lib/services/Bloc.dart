import 'package:frideos_core/frideos_core.dart';

class DynamicFieldsBloc {
  DynamicFieldsBloc() {
    nameFields.addAll([
      StreamedValue<String>(initialData: ' '),
    ]);
    for (var item in nameFields.value) {
      item.onChange(checkForm);
    }
  }

  final  nameFields = StreamedList<StreamedValue<String>>(initialData: []);
  final isFormValid = StreamedValue<bool>();
  void newFields() {
    nameFields.addElement(StreamedValue<String>());
  }


  void newFieldsEdit(String name) {
    nameFields.addElement(StreamedValue<String>(initialData: name));
  }


  void checkForm(String _) {
    bool isValidFieldsTypeName = true;
    for (var item in nameFields.value) {
      if (item.value != null) {
        if (item.value.isEmpty) {
          item.stream.sink.addError('The text must not be empty.');
          isValidFieldsTypeName = false;
        }
      } else {
        isValidFieldsTypeName = false;
      }
    }

    if (isValidFieldsTypeName) {
      isFormValid.value = true;
    } else {
      isFormValid.value = null;
    }
  }

  Map submit() {
    final users = {};
    for (int i = 0; i < nameFields.length; i++) {
      users[i] = {
        'name': nameFields.value[i].value,
      };
    }
    return users;
  }

  void removeFields(int index) {
    nameFields.removeAt(index);
  }

  void dispose() {
    for (var item in nameFields.value) {
      item.dispose();
    }
    nameFields.dispose();
    isFormValid.dispose();
  }
}

final bloc = DynamicFieldsBloc();