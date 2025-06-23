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
      appBar: AppBar(title: const Text('Votre commande')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text('Total: $total FCFA', style: const TextStyle(fontSize: 18)),
            TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Commentaires')),
            TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom')),
            TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone),
            TextField(
                controller: addressCtrl,
                decoration:
                    const InputDecoration(labelText: 'Adresse de livraison')),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: sendOrder, child: const Text('Commander')),
          ],
        ),
      ),
    );
  }
}
