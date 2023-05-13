import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = 'NGICON';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              appTitle,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.redAccent,
        ),
        body: const SingleChildScrollView(
          child: MyCustomForm(title: appTitle),
        ),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key, required this.title});

  final String title;

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

List<String> _religions = [
  'Islam',
  'Hinduism',
  'Buddhism',
  'Christianity',
  'Other'
];

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();

  String _fullName = '';
  String _email = '';
  String _gender = 'Male';
  String _birthdate = '';
  String _religion = _religions.first;
  bool _isAgreed = false;
  bool _isButtonEnabled = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing Data'),
          backgroundColor: Colors.deepPurple,
        ),
      );
      print('Full Name: $_fullName');
      print('Email: $_email');
      print('Gender: $_gender');
      print('Birthdate: $_birthdate');
      print('Religion: $_religion');
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name.';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address.';
    }
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? _validateBirthdate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your birthdate.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: _validateFullName,
              onSaved: (value) => _fullName = value!,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
              onSaved: (value) => _email = value!,
            ),
            const SizedBox(height: 16.0),
            const Text('Select your gender:'),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const Text('Female'),
              ],
            ),
            const SizedBox(height: 16.0),
            const Text('Select your religion:'),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Religion'),
              value: _religion,
              onChanged: (value) {
                setState(() {
                  _religion = value!;
                });
              },
              items: _religions.map((religion) {
                return DropdownMenuItem<String>(
                  value: religion,
                  child: Text(religion),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text('Select your birthdate:'),
            TextFormField(
              controller: dateInput,
              decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
              validator: _validateBirthdate,
              onSaved: (value) => _birthdate = value!,
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1971),
                    lastDate: DateTime.now());

                if (pickedDate != null) {
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                  setState(() {
                    dateInput.text = formattedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isAgreed,
                    onChanged: (bool value) {
                      setState(() {
                        _isAgreed = value;
                        _isButtonEnabled = value;
                      });
                    },
                  ),
                ),
                const Text('I agree to the terms & conditions'),
              ],
            ),
            const SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _isButtonEnabled ? _submitForm : null,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
