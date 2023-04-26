import 'package:flutter/material.dart';
import '../Functions/utils.dart';

class AddRat extends StatefulWidget {
  const AddRat({super.key});

  @override
  State<AddRat> createState() => _AddRatState();
}

class _AddRatState extends State<AddRat> {
  //TextEditControllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registeredNameController = TextEditingController();
  final TextEditingController colourController = TextEditingController();
  final TextEditingController earController = TextEditingController();
  final TextEditingController coatController = TextEditingController();
  final TextEditingController momController = TextEditingController();
  final TextEditingController dadController = TextEditingController();
  final TextEditingController markingsController = TextEditingController();

  String genderValue = 'Male';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyInputText(
                    controller: nameController,
                    hintText: 'Name',
                    validatorMessage: 'Name required'),
                MyInputText(
                    controller: registeredNameController,
                    hintText: 'Regestered Name',
                    validatorMessage: 'Regestered Name Required'),
                MyInputText(
                    controller: coatController,
                    hintText: 'Coat',
                    validatorMessage: 'Coat Required'),
                MyInputText(
                    controller: colourController,
                    hintText: 'Colour',
                    validatorMessage: 'Colour Required'),
                MyInputText(
                    controller: earController,
                    hintText: 'Ears',
                    validatorMessage: 'Ears Required'),
                    MyInputText(controller: momController, hintText: 'Parent: Mother', validatorMessage: 'Parent Required'),
                    MyInputText(controller: dadController, hintText: 'Praent: Father', validatorMessage: 'Parent Required'),
                    MyInputText(controller: markingsController, hintText: 'Markings', validatorMessage: 'Markings Required'),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      const Text('Gender: '),
                      const SizedBox(height: 10),
                      DropdownButton<String>(

                        hint: const Text('Gender'),
                        value: genderValue,
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            genderValue = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 50,),
                      ElevatedButton(onPressed: () {
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now(), );
                      }, child: const Text('Brithday'))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        //TODO: add logic
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          minimumSize: const Size(100, 50),
                          backgroundColor: secondaryThemeColor),
                      child: const Text('Save')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyInputText extends StatelessWidget {
  const MyInputText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validatorMessage,
  });

  final TextEditingController controller;
  final String hintText;
  final String validatorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText, border: const OutlineInputBorder()),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}
