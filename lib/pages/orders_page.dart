import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/components/app_drawer.dart';
import 'package:shop_flutter/components/order.dart';
import 'package:shop_flutter/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder( //O goat!
          future: Provider.of<OrderList>(
            context,
            listen: false,
          ).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // ignore: prefer_const_constructors
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return const Center(
                child: Text('Ocorreu um erro!'),
              );
            } else {
              return Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, i) => OrderWidget(order: orders.items[i]),
                ),
              );
            }
          }),
    );
  }
}
