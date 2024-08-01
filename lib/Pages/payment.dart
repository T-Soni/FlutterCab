import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cab/Pages/add_payment_method_screen.dart';
import 'package:flutter_cab/new_card/components/card_type.dart';
import 'package:flutter_cab/new_card/components/card_utilis.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void selectPaymentMethod(String paymentMethod, Widget? paymentIcon) {
    Map finalPaymentMode = {
      "paymentMethod": paymentMethod,
      "paymentIcon": paymentIcon
    };
    Navigator.pop(
      context,
      finalPaymentMode,
    );
  }

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
        title: const Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: Text(
              'Payment options',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Payment method',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const Divider(),
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddPaymentMethod())),
                tileColor: Colors.grey[200],
                leading: const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                title: const Text(
                  'Add payment method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                tileColor: Colors.grey[200],
                onTap: () => selectPaymentMethod(
                  'Cash',
                  const Icon(
                    Icons.currency_rupee,
                    color: Colors.green,
                  ),
                ),
                leading: const Icon(
                  Icons.currency_rupee,
                  color: Colors.green,
                ),
                title: const Text(
                  'Cash',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const Divider(),
              ListTile(
                onTap: () => selectPaymentMethod(
                  'Paytm',
                  const Image(
                      image: AssetImage('images/paytm_icon.png'),
                      height: 40,
                      width: 40),
                ),
                tileColor: Colors.grey[200],
                leading: const Image(
                    image: AssetImage('images/paytm_icon.png'),
                    height: 40,
                    width: 40),
                title: const Text(
                  'Paytm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
              const Divider(),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('card details')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text(' '));
                  }
                  return Column(
                    children: snapshot.data!.docs.map((document) {
                      return Column(
                        children: [
                          ListTile(
                              tileColor: Colors.grey[200],
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CardUtils.getCardIcon(
                                    CardType.values[document['cardType']]),
                              ),
                              title: Text(
                                '**** **** **** ${document['last4Digits']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () => selectPaymentMethod(
                                  '**** **** **** ${document['last4Digits']}',
                                  CardUtils.getCardIcon(
                                      CardType.values[document['cardType']]))),
                          const Divider(),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       backgroundColor: Colors.grey[200],
  //       appBar: AppBar(
  //         leading: IconButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           icon: const Icon(Icons.arrow_back),
  //         ),
  //         title: const Center(
  //           child: Padding(
  //             padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
  //             child: Text(
  //               'Payment options',
  //               style: TextStyle(
  //                 fontSize: 30,
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         backgroundColor: Colors.amber,
  //       ),
  //       body: SingleChildScrollView(
  //         child: Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               const Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Text(
  //                   'Payment method',
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                 ),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 onTap: () => Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => const AddPaymentMethod())),
  //                 tileColor: Colors.grey[200],
  //                 leading: const Icon(
  //                   Icons.add,
  //                   color: Colors.black,
  //                 ),
  //                 title: const Text(
  //                   'Add payment method',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 tileColor: Colors.grey[200],
  //                 onTap: () => selectPaymentMethod(
  //                   'Cash',
  //                   const Icon(
  //                     Icons.currency_rupee,
  //                     color: Colors.green,
  //                   ),
  //                 ),
  //                 leading: const Icon(
  //                   Icons.currency_rupee,
  //                   color: Colors.green,
  //                 ),
  //                 title: const Text(
  //                   'Cash',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 trailing: const Icon(Icons.arrow_forward_ios),
  //               ),
  //               const Divider(),
  //               ListTile(
  //                 onTap: () => selectPaymentMethod(
  //                   'Paytm',
  //                   const Image(
  //                       image: AssetImage('images/paytm_icon.png'),
  //                       height: 40,
  //                       width: 40),
  //                 ),
  //                 tileColor: Colors.grey[200],
  //                 leading: const Image(
  //                     image: AssetImage('images/paytm_icon.png'),
  //                     height: 40,
  //                     width: 40),
  //                 title: const Text(
  //                   'Paytm',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //                 trailing: const Icon(Icons.arrow_forward_ios),
  //               ),
  //               const Divider(),
  //               Expanded(
  //                 child: StreamBuilder(
  //                   stream: FirebaseFirestore.instance
  //                       .collection('users')
  //                       .doc(FirebaseAuth.instance.currentUser!.uid)
  //                       .collection('card details')
  //                       .snapshots(),
  //                   builder: (context, snapshot) {
  //                     if (!snapshot.hasData) {
  //                       return const Center(child: CircularProgressIndicator());
  //                     }
  //                     return ListView(
  //                       children: snapshot.data!.docs.map((document) {
  //                         return Column(
  //                           children: [
  //                             ListTile(
  //                                 tileColor: Colors.grey[200],
  //                                 leading: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: CardUtils.getCardIcon(
  //                                       CardType.values[document['cardType']]),
  //                                 ),
  //                                 title: Text(
  //                                   '**** **** **** ${document['last4Digits']}',
  //                                   style: const TextStyle(
  //                                     fontSize: 18,
  //                                     fontWeight: FontWeight.w500,
  //                                   ),
  //                                 ),
  //                                 trailing: const Icon(Icons.arrow_forward_ios),
  //                                 onTap: () => selectPaymentMethod(
  //                                     '**** **** **** ${document['last4Digits']}',
  //                                     CardUtils.getCardIcon(CardType
  //                                         .values[document['cardType']]))),
  //                             const Divider(),
  //                           ],
  //                         );
  //                       }).toList(),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ));
  //}
}
