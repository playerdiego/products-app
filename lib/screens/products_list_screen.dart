import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:products_app/providers/products_provider.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class ProductsListScreen extends StatelessWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

  void displayDialogAndroid(BuildContext context, Product product) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    showDialog(
        context: context,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
                title: const Text('Do you want to delete this product?'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No',
                          style: TextStyle(color: AppTheme.primaryColor))),
                  TextButton(
                      onPressed: () {
                        productsProvider.deleteProduct(product.id!);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes',
                          style: TextStyle(color: AppTheme.primaryColor))),
                ],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.black.withOpacity(.6))));
  }

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);
    final AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: productsProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: productsProvider.products.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product product = productsProvider.products[index];

                  return GestureDetector(
                    child: ProductCard(product: product),
                    onLongPress: () async {
                      displayDialogAndroid(context, product);

                      bool canVibrate = await Vibrate.canVibrate;
                      if (canVibrate) {
                        Vibrate.vibrate();
                      }
                    },
                    onTap: () {
                      productsProvider.selectedProduct = product.copy();
                      Navigator.pushNamed(context, 'edit_product');
                    },
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        onPressed: () async {
          final Product product = Product(available: false, name: '', price: 0);
          productsProvider.selectedProduct = product;
          Navigator.pushNamed(context, 'edit_product');
        },
      ),
    );
  }
}
