import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/add_card_screen.dart';

class AddPaymentMethod extends StatefulWidget {
  const AddPaymentMethod({super.key});

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: Text(
                  'Add payment method',
                  style: TextStyle(
                    fontSize: 34,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              ListTile(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AddCardForm())),
                tileColor: Colors.grey[200],
                leading: const Icon(
                  Icons.credit_card,
                  color: Colors.grey,
                  size: 40,
                ),
                title: const Text(
                  'Credit or debit card',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
