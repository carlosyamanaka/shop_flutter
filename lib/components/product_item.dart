import 'package:flutter/material.dart';
import 'package:shop_flutter/models/product.dart';
import 'package:shop_flutter/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  // ignore: prefer_const_constructors_in_immutables
  ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
