import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-4a4a1-default-rtdb.europe-west1.firebasedatabase.app';

  final List<Product> products = [];

  late Product? selectedProduct;

  File? newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });

    isLoading = false;
    notifyListeners();

    return products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      //Es necesario crear
      await createProduct(product);
    } else {
      // Necesito actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products/${product.id}.json');
    final resp = await http.put(url, body: product.toJson());
    if (resp.statusCode == 200) {
      // products.forEach((element) {
      //   if (element.id == product.id) {
      //     products[products.indexOf(element)] = product;
      //   }
      // });
      final index = products.indexWhere((element) => element.id == product.id);
      products[index] = product;
    }
    return product.id!;
  }

  Future createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'products.json');
    final resp = await http.post(url, body: product.toJson());
    //Cuando hacemos un POST, firebase crea un id para el registro.
    final idFirebase = json.decode(resp.body);
    if (resp.statusCode == 200) {
      product.id = idFirebase['name'];
      products.add(product);
    }
    // return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct!.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;

    isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/k1mbowx/image/upload?upload_preset=ajkxalvs');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamReponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream(streamReponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      return null;
    }

    final decodedData = json.decode(resp.body);

    newPictureFile = null;

    return decodedData['secure_url'];
  }
}
