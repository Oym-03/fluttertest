import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDSC Form',
      debugShowCheckedModeBanner: false, // This line removes the debug banner
      home: FeedbackForm(),
      theme: ThemeData(primarySwatch: Colors.green,
      brightness: Brightness.dark),


    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingControllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telegramUsernameController = TextEditingController();

  String? _department;
  String? _stage;
  String? _rate;
  List<Map<String, String?>> feedbacks = [];
  final String _password = "GDSC123";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _telegramUsernameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      feedbacks.add({
        'Name': _nameController.text,
        'Department': _department,
        'Stage': _stage,
        'Rating': _rate,
        'Email': _emailController.text,
        'Telegram Username': _telegramUsernameController.text,
      });

      _nameController.clear();
      _emailController.clear();
      _telegramUsernameController.clear();

      setState(() {
        _department = null;
        _stage = null;
        _rate=null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback submitted successfully!')),
      );
    }
  }

  void _showFeedbacks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String enteredPassword = "";
        return AlertDialog(
          title: Text('Enter Password'),
          content: TextField(
            onChanged: (value) => enteredPassword = value,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (enteredPassword == _password) {
                  Navigator.pop(context);
                  _showSavedFeedbacks(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Wrong password!')),
                  );
                }
              },

              child: Text('Enter'),

            ),
          ],
        );
      },
    );
  }

  void _showSavedFeedbacks(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Saved Feedbacks'),
          content: SingleChildScrollView(
            child: ListBody(
              children: feedbacks.map((feedback) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Name: ${feedback['Name']}'),
                    Text('Department: ${feedback['Department']}'),
                    Text('Stage: ${feedback['Stage']}'),
                    Text('Rating: ${feedback['Rating']}'),
                    Text('Email: ${feedback['Email']}'),
                    Text('Telegram Username: ${feedback['Telegram Username']}'),
SizedBox(height: 10,),
                    Container(height:1,color: Colors.black,),
                  SizedBox(height: 10,)
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workshop Feedback')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children:
          <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.green,
              ),
            ),
            ListTile(
              title: Text('View Feedbacks'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                _showFeedbacks(context);
              },
            ),
            // Add other menu items if needed
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'الاسم'),
              validator: (value) {
                if (value!.isEmpty) return 'ادخل اسمك رجاءاً';
                return null;
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _department,
                    decoration: InputDecoration(labelText: 'القسم'),
                    items: <String>['هندسة حاسوب', 'هندسة شبكات', 'هندسة مدني', 'هندسة كهرباء']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _department = newValue;
                      });

                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'اختر القسم رجاءاً'; // Error message when not selected
                      }
                      return null; // Return null to indicate the input is valid
                    },
                  ),
                ),
                SizedBox(width: 8.0), // Provides spacing between the dropdowns
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _stage,
                    decoration: InputDecoration(labelText: 'المرحلة'),
                    items: <String>['مرحلة اولى', 'مرحلة ثانية', 'مرحلة ثالثة', 'مرحلة رابعة']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _stage = newValue;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'اختر المرحلة رجاءاً'; // Error message when not selected
                      }
                      return null; // Return null to indicate the input is valid
                    },
                  ),
                ),
              ],
            ),


              DropdownButtonFormField<String>(
              value: _rate,
              decoration: InputDecoration(labelText: 'تقييمك للورشة'),
              items: <String>['ممتاز', 'جيد', 'متوسط', 'سئ']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _rate = newValue;
                });
              },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'اختر التقييم رجاءاً'; // Error message when not selected
                  }
                  return null; // Return null to indicate the input is valid
                },
            ),
             TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')||!value.contains('.')) return 'ادخل بريدك الالكتروني رجاءاً';
                return null;
              },
            ),
            TextFormField(
              controller: _telegramUsernameController,
              decoration: InputDecoration(labelText: 'Telegram Username   (optiopnal)'),

              validator: (value) {
                return null;
              },
            ),
            ElevatedButton(

              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
