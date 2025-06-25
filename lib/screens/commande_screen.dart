import 'package:flutter/material.dart';
import '../api.dart';

class CommandeScreen extends StatefulWidget {
  final List meals;

  const CommandeScreen(this.meals, {super.key});

  @override
  _CommandeScreenState createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  double get total => widget.meals.fold(0, (sum, m) => sum + (m['price'] ?? 0));

  void sendOrder() async {
    if (nameCtrl.text.isEmpty ||
        phoneCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tous les champs sont requis.')));
      return;
    }

    final order = {
      'customerName': nameCtrl.text,
      'phoneNumber': phoneCtrl.text,
      'address': addressCtrl.text,
      'note': noteCtrl.text,
      'totalPrice': total,
      'meals': widget.meals,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      await apiService.sendOrder(order);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Commande envoyée !')));
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      print('Erreur envoi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'envoi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Votre commande'),
        backgroundColor: Colors.amber,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Icon(Icons.shopping_bag,
                        size: 60, color: Colors.amber[700]),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'Total: $total FCFA',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person, color: Colors.amber),
                      labelText: 'Nom',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: phoneCtrl,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: Colors.amber),
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: addressCtrl,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.location_on, color: Colors.amber),
                      labelText: 'Adresse de livraison',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: noteCtrl,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.comment, color: Colors.amber),
                      labelText: 'Commentaires',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: sendOrder,
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      'Commander',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
