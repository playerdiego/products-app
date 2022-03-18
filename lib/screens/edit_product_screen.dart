import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:products_app/models/product.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/theme/app_theme.dart';
import 'package:products_app/ui/input_login_decoration.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
   
  const EditProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final EditProductProvider editProductProvider = Provider.of<EditProductProvider>(context);
    final ProductsProvider productsProvider = Provider.of<ProductsProvider>(context);


    return  Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: const [
            _ProductImage(),
            _ProductForm()

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(

        child: productsProvider.isSavig
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(Icons.save, color: Colors.white),
        backgroundColor: AppTheme.primaryColor,

        onPressed: productsProvider.isSavig ? null : () async {
          if(editProductProvider.isValid()) {

            if(productsProvider.newImage != null) {

              final String? imgUrl = await productsProvider.uploadImage();
              if(imgUrl != null) editProductProvider.product.picture = imgUrl;
            }

            await productsProvider.updateOrCreateProduct(editProductProvider.product);

            Navigator.pop(context);
          }
        },

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final ProductsProvider productsService = Provider.of<ProductsProvider>(context);
    final Product selectedProduct = productsService.selectedProduct;
    


    return Container(
      width: double.infinity,
      height: size.height * .4,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        )
      ),

      child: Stack(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: getImage(productsService.selectedProduct.picture)
          ),

          Positioned(
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.navigate_before, size: 30),
                onPressed: () async {

                  Navigator.pop(context);

                },
              ),
            ),
            top: 15,
          ),

          Positioned(
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.camera, size: 25),
                onPressed: () async {
                  
                  final picker = ImagePicker();
                  final XFile? pickedFile = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 100
                  );

                  if(pickedFile == null) return;

                  productsService.updateSelectedProductImage(pickedFile.path);

                },
              ),
            ),
            top: 15,
            right: 20,
          )
        ],
      ),
    );
  }

  Widget getImage(String? picture) {

    if(picture == null) {
      return const FadeInImage(
        width: double.infinity,
        height: double.infinity,
        placeholder: AssetImage('assets/loading.gif'),
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
        
      );
    }

    if(picture.startsWith('http')) {
      return FadeInImage(
        width: double.infinity,
        height: double.infinity,
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(picture),
        fit: BoxFit.cover,
        
      );
    }

    return Image.file(
      File(picture),
      fit: BoxFit.cover,
      width: double.infinity,
    );

  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final EditProductProvider editProductProvider = Provider.of<EditProductProvider>(context);
    final Product product = editProductProvider.product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: editProductProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [

            const SizedBox(height: 10),
            
            TextFormField(
              initialValue: product.name,
              onChanged: (value) {
                product.name = value;
              },
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return 'Name is required';
                }

                return null;
              },
              decoration: InputLoginDecoration.inputDecoration(
                hintText: 'PS5 Dualshock',
                labelText: 'Name',
                icon: Icons.input,
                color: Colors.white
              ),
            ),


            TextFormField(
              initialValue: product.price.toString(),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
              onChanged: (value) {
                if(double.tryParse(value) == null) {
                  product.price = 0;
                } else {
                  product.price = double.parse(value);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputLoginDecoration.inputDecoration(
                hintText: '75.99',
                labelText: 'Price',
                icon: Icons.money,
                color: Colors.white
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile.adaptive(
              value: product.available,
              activeColor: AppTheme.primaryColor, 
              onChanged: (value) {
                editProductProvider.setAvailability(value);
              },
              title: const Text('Available'),
            ),

            const SizedBox(height: 150),

          ],
        ),
        
      ),
    );
  }
}