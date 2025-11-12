import 'package:flutter/material.dart';
import 'package:proyect_movil/screens/cart_modal_screen.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF8E8E8), // Fondo bordó claro
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF8B1E3F), // Bordó oscuro
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.5,
              child: Image.network(
                product.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("Marca: ${product.brand}",
                      style: const TextStyle(fontSize: 16, color: Colors.black54)),

                  const SizedBox(height: 12),

                  Text(
                    "Bs. ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF8B1E3F), // Precio en color bordó
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Cantidad:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Color(0xFF8B1E3F),
                      ),
                      Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          if (quantity < product.stock) {
                            setState(() {
                              quantity++;
                            });
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline),
                        color: Color(0xFF8B1E3F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text("Descripción:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(product.description),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final cart = Provider.of<CartService>(context, listen: false);
                        for (int i = 0; i < quantity; i++) {
                          cart.addToCart(product);
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => const CartModalScreen(),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$quantity producto(s) agregado(s) al carrito')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B1E3F),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Agregar al carrito",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
