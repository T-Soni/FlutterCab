import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cab/new_card/components/card_strings.dart';
import 'package:flutter_cab/new_card/components/card_type.dart';
import 'package:flutter_cab/new_card/components/card_utilis.dart';
import 'package:flutter_cab/new_card/components/input_formatters.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddCardForm extends StatefulWidget {
  const AddCardForm({super.key});

  @override
  State<AddCardForm> createState() => _AddCardFormState();
}

class _AddCardFormState extends State<AddCardForm> {
  // Text editing controllers
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final cvvController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum() {
    // Identify the card with first 6 digits (IIN / BIN)
    if (cardNumberController.text.length <= 6) {
      String cardNum = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
      if (type != cardType) {
        setState(() {
          cardType = type;
          print('card type: $cardType');
        });
      }
    }
  }

  Future<void> storeCardDetails(String last4Digits) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('card details')
        .add({
      'last4Digits': last4Digits,
      'cardType': cardType.index,
    });
  }

  void validateForm() async {
    if (formKey.currentState?.validate() ?? false) {
      print('Form is valid');
      String last4Digits = cardNumberController.text
          .substring(cardNumberController.text.length - 4);
      await storeCardDetails(last4Digits);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Success!',
              style: TextStyle(color: Colors.green, fontSize: 25),
            ),
            content: const Text(
              'The card is added...',
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Form is invalid');
    }
  }

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(() {
      getCardTypeFrmNum();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Add card',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Spacer(),
                TextFormField(
                  controller: cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                    CardNumberInputFormatter(),
                  ],
                  decoration: InputDecoration(
                    hintText: "Card number",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CardUtils.getCardIcon(cardType),
                    ),
                    prefixIcon: cardType == CardType.Invalid
                        ? null
                        : const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Icon(Icons.credit_card),
                          ),
                  ),
                  validator: (value) => CardUtils.validateCardNum(value),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      hintText: "Full name",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SvgPicture.asset("assets/icons/user.svg"),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.fieldReq;
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: cvvController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          hintText: "CVV",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.asset("assets/icons/Cvv.svg"),
                          ),
                        ),
                        validator: (value) => CardUtils.validateCVV(value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: expDateController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5),
                          CardMonthInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          hintText: "MM/YY",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child:
                                SvgPicture.asset("assets/icons/calender.svg"),
                          ),
                        ),
                        validator: (value) => CardUtils.validateDate(value),
                      ),
                    ),
                  ],
                ),
                const Spacer(flex: 2),
                OutlinedButton.icon(
                  icon: SvgPicture.asset("assets/icons/scan.svg"),
                  label: Text("Scan"),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                      ),
                      child: const Text(
                        "Add card",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      onPressed: validateForm,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.toString().length,
      ),
    );
  }
}
