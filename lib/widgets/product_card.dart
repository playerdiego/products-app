import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:products_app/theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      height: 300,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      child: Stack(
        children: [

          _ProductImage(picture: product.picture),
          Positioned(child: _ProductDeatils(name: product.name, id: product.id!), left: 0, bottom: 0),
          Positioned(child: _ProductPrice(price: product.price), right: 0, top: 0),
          if (!product.available)
            const Positioned(child: _ProductNotAvailable(), left: 0, top: 0)


        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    Key? key,
    this.picture
  }) : super(key: key);

  final String? picture;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: picture == null 
      ? const FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
      : FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(picture!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
      )
    );
  }
}

class _ProductDeatils extends StatelessWidget {
  const _ProductDeatils({
    Key? key,
    required this.id,
    required this.name,
  }) : super(key: key);

  final String name;
  final String id;


  @override
  Widget build(BuildContext context) {

  final Size size = MediaQuery.of(context).size;

    return Container(
      height: 60,
      width: size.width * .7,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), topRight: Radius.circular(20)) 
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

class _ProductPrice extends StatelessWidget {
  const _ProductPrice({
    Key? key,
    required this.price

  }) : super(key: key);

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      width: 80,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20))
      ),
      child: FittedBox(
        child: Text(
          '\$$price',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}


class _ProductNotAvailable extends StatelessWidget {
  const _ProductNotAvailable({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      width: 100,
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomRight: Radius.circular(20))
      ),
      child: const FittedBox(
        child: Text(
          'Not Available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}