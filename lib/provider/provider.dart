import 'package:flutter/material.dart';

import '../model/data.dart';

class AppData with ChangeNotifier {
  final List<String> data = AppDataModel().itemslist;
  final List<String> data2 = AppDataModel().favouritelist;

  deleteData(int index) {
    data.removeAt(index);
    notifyListeners();
  }

  addData(String inputdata) {
    data.add(inputdata);
    notifyListeners();
  }

  addTofavourites(int index) {
    data2.add(data[index]);
    data.removeAt(index);
    notifyListeners();
  }

  insertToFavorites(String val) {
    data2.add(val);
    notifyListeners();
  }

  int getlength({required bool isFavourite}) {
    if (!isFavourite) {
      return data.length;
    } else {
      return data2.length;
    }
  }

  getData() {
    return data;
  }

  getFavourite() {
    return data2;
  }
}
