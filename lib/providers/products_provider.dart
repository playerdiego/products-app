import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier {

  final List<Product> products = [];
  late Product selectedProduct;
  File? newImage;

  final String _baseUrl = 'https://flutter-varios-fa0e0-default-rtdb.firebaseio.com';

  bool isLoading = true;
  bool isSavig = false;

  ProductsProvider() {
    loadProducts();
  }

  Future loadProducts() async {

    isLoading = true;
    notifyListeners();

    final Uri url = Uri.parse('$_baseUrl/products.json');
    final http.Response res = await http.get(url);
    if (json.decode(res.body) != null) {
      final Map<String, dynamic> data = json.decode(res.body);
        if(data.isNotEmpty) {
        data.forEach((key, value) {
          
          final Product tempProduct = Product.fromJson(value);
          tempProduct.id = key;

          products.add(tempProduct);      

        });
      }
    }


    isLoading = false;
    notifyListeners();

  }

  Future updateOrCreateProduct(Product newProduct) async {

    isSavig = true;
    notifyListeners();

    if(newProduct.id == null) {

      final Uri url = Uri.parse('$_baseUrl/products.json');
      final http.Response res = await http.post(url, body: json.encode(newProduct.toJson()));
      final decodedData = json.decode(res.body);
      newProduct.id = decodedData['name'];

      products.add(newProduct);

      isSavig = false;
      notifyListeners();

    } else {
      final Uri url = Uri.parse('$_baseUrl/products/${newProduct.id}.json');
      await http.put(url, body: json.encode(newProduct.toJson()));


      final index = products.indexWhere((element) => element.id == newProduct.id);
      products[index] = newProduct;
      isSavig = false;
      notifyListeners();
    }

  }

  Future deleteProduct(String id) async {

    final Uri url = Uri.parse('$_baseUrl/products/$id.json');
    final http.Response res = await http.delete(url);

    products.removeWhere((element) => element.id == id);
    notifyListeners();

  }

  void updateSelectedProductImage(String path) {

    newImage = File.fromUri(Uri(path: path));
    selectedProduct.picture = path;
    notifyListeners();

  }

  Future<String?> uploadImage() async {

    isSavig = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/do45arvs1/image/upload?upload_preset=twk2juah');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', newImage!.path);

    imageUploadRequest.files.add((file));
    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);

    if(res.statusCode != 200 && res.statusCode == 201) {
      return null;
    }

    isSavig = false;
    notifyListeners();

    final decodeData = json.decode(res.body);
    return decodeData['secure_url'];

  }

}