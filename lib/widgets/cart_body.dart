import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyect_movil/screens/checkout_screen.dart';
import '../services/cart_service.dart';
import '../models/cart_item_model.dart';

class CartBody extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onOrder;

  const CartBody({super.key, this.showBack = false, this.onOrder});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);

    return Column(
      children: [
        if (cart.items.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                "Tu carrito está vacío",
                style: TextStyle(color: Color(0xFF8B1E3F)),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final CartItem item = cart.items[index];
                return Card(
                  color: const Color(0xFFFDEAEA), // color claro bordó
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(item.product.image, width: 60, fit: BoxFit.cover),
                    title: Text(item.product.name,
                        style: const TextStyle(color: Color(0xFF8B1E3F))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bs. ${item.product.price.toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.black87),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              color: Color(0xFF8B1E3F),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  item.quantity--;
                                  cart.saveCartToLocalStorage();
                                  cart.notifyListeners();
                                }
                              },
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              color: Color(0xFF8B1E3F),
                              onPressed: () {
                                if (item.quantity < item.product.stock) {
                                  item.quantity++;
                                  cart.saveCartToLocalStorage();
                                  cart.notifyListeners();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red[300], // rojo más suave
                      onPressed: () {
                        cart.removeFromCart(item.product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item.product.name} eliminado")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12)),
            color: Color(0xFFF8E8E8), // fondo más claro
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal:", style: TextStyle(fontSize: 18)),
                  Text(
                    "Bs. ${cart.total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFF8B1E3F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // builder: (context) => const CheckoutScreen(),
                      builder: (context) => CheckoutScreen(totalAmount: cart.total),

                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1E3F),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Realizar pedido"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
