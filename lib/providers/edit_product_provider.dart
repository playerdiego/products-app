import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';

class EditProductProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditProductProvider(Product selectedProduct) {
    product = selectedProduct;
  }

  late Product product;

  bool isValid() {
    return formKey.currentState?.validate() ?? false;
  }

  setAvailability(bool value) {
    product.available = value;
    notifyListeners();
  }

}