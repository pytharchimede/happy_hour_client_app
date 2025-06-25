import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> meals;
  final VoidCallback onValidate;

  const CartScreen({super.key, required this.meals, required this.onValidate});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<Map<String, dynamic>> cart;

  @override
  void initState() {
    super.initState();
    // On clone la liste pour éviter de modifier la source
    cart = widget.meals.map((m) => Map<String, dynamic>.from(m)).toList();
  }

  double get total =>
      cart.fold(0, (sum, m) => sum + (m['price'] ?? 0) * (m['quantity'] ?? 1));

  void updateQuantity(int index, int delta) {
    setState(() {
      cart[index]['quantity'] = (cart[index]['quantity'] ?? 1) + delta;
      if (cart[index]['quantity'] <= 0) {
        cart.removeAt(index);
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cart.removeAt(index);
    });
  }

  void clearCart() {
    setState(() {
      cart.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mon Panier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Vider le panier',
            onPressed: cart.isEmpty
                ? null
                : () {
                    clearCart();
                  },
          ),
        ],
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Votre panier est vide.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (_, i) {
                final meal = cart[i];
                return ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      meal['imageUrl'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                meal['imageUrl'],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(width: 40, height: 40),
                      const SizedBox(width: 8),
                      const Icon(Icons.fastfood, color: Colors.amber),
                    ],
                  ),
                  title: Text(meal['name'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Prix: ${meal['price'] ?? 0} FCFA'),
                      Row(
                        children: [
                          const Text('Qté:'),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => updateQuantity(i, -1),
                          ),
                          Text('${meal['quantity'] ?? 1}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => updateQuantity(i, 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => removeItem(i),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total : $total FCFA',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Valider la commande'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      // Met à jour la liste d'origine avant validation
                      widget.meals
                        ..clear()
                        ..addAll(cart);
                      widget.onValidate();
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
