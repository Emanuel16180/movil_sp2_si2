import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/category_model.dart';
import '../services/product_service.dart';
import '../services/category_service.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';

class InitialHomeScreen extends StatefulWidget {
  const InitialHomeScreen({super.key});

  @override
  State<InitialHomeScreen> createState() => _InitialHomeScreenState();
}

class _InitialHomeScreenState extends State<InitialHomeScreen> {
  late Future<List<Category>> _categoriesFuture;
  late Future<List<Product>> _productsFuture;
  String _searchQuery = '';
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = CategoryService().fetchCategories();
    _productsFuture = ProductService().fetchProducts();
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategoryId == null || product.categoryId == _selectedCategoryId;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8E8E8), // Fondo bordó claro
      appBar: AppBar(
        title: const Text('Smart Cart'),
        backgroundColor: const Color(0xFF8B1E3F), // Bordó oscuro
        foregroundColor: Colors.white, // Texto e íconos blancos
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF8B1E3F)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF8B1E3F)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF8B1E3F), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 10),

            FutureBuilder<List<Category>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No se encontraron categorías");
                }

                final categories = snapshot.data!;
                return SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      final isSelected = index == 0
                          ? _selectedCategoryId == null
                          : _selectedCategoryId == categories[index - 1].id;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(index == 0 ? "Todos" : categories[index - 1].name),
                          selected: isSelected,
                          selectedColor: const Color(0xFF8B1E3F),
                          backgroundColor: const Color(0xFFEFD4D5),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                          onSelected: (_) => _onCategorySelected(
                              index == 0 ? null : categories[index - 1].id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Text("Error al cargar productos: ${snapshot.error}"));
                  }

                  final filtered = _filterProducts(snapshot.data ?? []);

                  if (filtered.isEmpty) {
                    return const Center(child: Text("No se encontraron productos"));
                  }

                  return GridView.builder(
                    itemCount: filtered.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: filtered[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
