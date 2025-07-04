import 'package:flutter/material.dart';
import '../api.dart';
import 'cart_screen.dart';
import 'commande_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<Map<String, dynamic>> meals = [];
  List<Map<String, dynamic>> selectedMeals = [];

  @override
  void initState() {
    super.initState();
    loadMeals();
  }

  Future<void> loadMeals() async {
    try {
      final result = await apiService.fetchMeals();
      final List<Map<String, dynamic>> mealsList =
          List<Map<String, dynamic>>.from(result);
      if (mealsList.isEmpty) {
        print('Aucun menu reçu');
      }
      setState(() {
        meals = mealsList;
      });
    } catch (e) {
      print('Erreur lors du chargement des menus: $e');
    }
  }

  void addToCart(meal) {
    setState(() {
      // Cherche si le plat est déjà dans le panier
      final index = selectedMeals.indexWhere((m) => m['name'] == meal['name']);
      if (index != -1) {
        // Si déjà présent, augmente la quantité
        selectedMeals[index]['quantity'] =
            (selectedMeals[index]['quantity'] ?? 1) + 1;
      } else {
        // Sinon, ajoute avec quantité 1
        final mealWithQuantity = Map<String, dynamic>.from(meal);
        mealWithQuantity['quantity'] = 1;
        selectedMeals.add(mealWithQuantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = meals.map((m) => m['category']).toSet();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('HAPPY HOUR'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CartScreen(
                        meals: selectedMeals,
                        onValidate: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CommandeScreen(selectedMeals),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              if (selectedMeals.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text('${selectedMeals.length}',
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white))),
                ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: categories.map((cat) {
          final filtered = meals.where((m) => m['category'] == cat).toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(cat,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final meal = filtered[i];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Text(meal['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text('${meal['price']} FCFA'),
                          if (meal['imageUrl'] != null)
                            Image.network(meal['imageUrl'],
                                width: 150, height: 150, fit: BoxFit.cover),
                          ElevatedButton(
                              onPressed: () => addToCart(meal),
                              child: const Text('Ajouter')),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}
