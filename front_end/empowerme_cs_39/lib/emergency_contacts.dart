import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchContactsFromBackend();
  }

  Future<void> fetchContactsFromBackend() async {
    try {
      /*final response = await http.get(Uri.parse('http://10.0.2.2:3000/getContacts'));*/
      final response = await http.get(
          Uri.parse('https://sdgp-cs-39-empower-me.vercel.app/getContacts'));

      if (response.statusCode == 200) {
        List<dynamic> jsonContacts = json.decode(response.body);
        List<Contact> fetchedContacts =
            jsonContacts.map((json) => Contact.fromJson(json)).toList();

        setState(() {
          contacts = fetchedContacts;
        });
      } else {
        print('Failed to fetch contacts. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching contacts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(contacts[index].name),
                    subtitle: Text(contacts[index].number),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call),
                          onPressed: () {
                            _makePhoneCall(contacts[index].number);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditContactDialog(context, index);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete Contact'),
                                  content: const Text(
                                      'Are you sure you want to delete this contact?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteContact(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddContactDialog(context);
              },
              child: const Text('Add Contact'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          content: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z]')), // Only letters allowed
                  ],
                  maxLength: 15,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    counterText: '',
                  ),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Only numbers allowed
                  ],
                  maxLength: 10,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: numberController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Number',
                    counterText: '',
                  ),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    numberController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Validation Error'),
                        content: const Text('Please enter all fields'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  addContact();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addContact() {
    String name = nameController.text;
    String number = numberController.text;

    if (name.isNotEmpty && number.isNotEmpty) {
      // Check if a contact with the same name or number already exists
      bool isDuplicate = contacts
          .any((contact) => contact.name == name || contact.number == number);

      if (isDuplicate) {
        // Show a message indicating that the contact already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This contact already exists.'),
            backgroundColor: Colors.blue,
          ),
        );
      } else {
        // Add the contact if it's not a duplicate
        Contact newContact = Contact(name, number);
        setState(() {
          contacts.add(newContact);
        });
        sendDataToBackend(newContact);
        nameController.clear();
        numberController.clear();
      }
    }
  }

  //delete the contacts number
  void deleteContact(int index) async {
    Contact contactToDelete = contacts[index];
    setState(() {
      contacts.removeAt(index);
    });
    try {
      final response = await http.delete(
        /*Uri.parse('http://10.0.2.2:3000/deleteContact/${contactToDelete.name}'),*/
        Uri.parse(
            'https://sdgp-cs-39-empower-me.vercel.app/deleteContact/${contactToDelete.name}'),
      );
      if (response.statusCode == 200) {
        print('Contact deleted successfully');
      } else {
        print('Failed to delete contact. Status code: ${response.statusCode}');
        setState(() {
          contacts.insert(index, contactToDelete);
        });
      }
    } catch (error) {
      print('Error deleting contact: $error');
      setState(() {
        contacts.insert(index, contactToDelete);
      });
    }
  }

  void sendDataToBackend(Contact contact) async {
    final response = await http.post(
      /*Uri.parse('http://10.0.2.2:3000/addContact'),*/
      Uri.parse('https://sdgp-cs-39-empower-me.vercel.app/addContact'),
      body: {
        'name': contact.name,
        'number': contact.number,
      },
    );
    print('Response from backend: ${response.body}');
  }

  //Edit contacts
  void _showEditContactDialog(BuildContext context, int index) {
    nameController.text = contacts[index].name;
    numberController.text = contacts[index].number;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Contact'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          content: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z]')), // Only letters allowed
                  ],
                  maxLength: 15,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    counterText: '',
                  ),
                  style: const TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Only numbers allowed
                  ],
                  maxLength: 10,
                  textInputAction: TextInputAction.done,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: numberController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a number';
                    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Number',
                    counterText: '',
                  ),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    numberController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Validation Error'),
                        content: const Text('Please enter all fields'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  updateContact(index);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void updateContact(int index) async {
    Contact oldContact = contacts[index];
    String newName = nameController.text;
    String newNumber = numberController.text;

    if (newName.isNotEmpty && newNumber.isNotEmpty) {
      Contact updatedContact = Contact(newName, newNumber);

      setState(() {
        contacts[index] = updatedContact;
      });

      try {
        final response = await http.put(
          /*Uri.parse('http://10.0.2.2:3000/updateContact/${oldContact.name}'),*/
          Uri.parse(
              'https://sdgp-cs-39-empower-me.vercel.app/updateContact/${oldContact.name}'),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"newName": newName, "newNumber": newNumber}),
        );
        if (response.statusCode == 200) {
          print('Contact updated successfully');
        } else {
          print(
              'Failed to update contact. Status code: ${response.statusCode}');
          setState(() {
            contacts[index] =
                oldContact; // Revert back to the old contact on failure
          });
        }
      } catch (error) {
        print('Error updating contact: $error');
        setState(() {
          contacts[index] =
              oldContact; // Revert back to the old contact on error
        });
      }
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await launch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Contact {
  final String name;
  final String number;

  Contact(this.name, this.number);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      json['name'] as String,
      json['number'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
    };
  }
}
