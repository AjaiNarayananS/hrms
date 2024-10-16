import 'package:flutter/material.dart';
import 'dart:convert';

class ClientsSheet extends StatefulWidget {
  const ClientsSheet({super.key});

  @override
  _ClientsSheetState createState() => _ClientsSheetState();
}

class _ClientsSheetState extends State<ClientsSheet> {
  List<Client> clients = [];

  @override
  void initState() {
    super.initState();
    _loadInitialClients();
  }

  void _loadInitialClients() {
    final jsonClients = [
      {
        "name": "Acme Corp",
        "address": "123 Main St, Mumbai",
        "state": "Maharashtra",
        "email": "info@acmecorp.com",
        "phone": "+91 9876543210",
        "fax": "+91 22 1234567",
        "pointOfContact": "USER A"
      },
      {
        "name": "TechSolutions Ltd",
        "address": "456 Tech Park, Bangalore",
        "state": "Karnataka",
        "email": "contact@techsolutions.com",
        "phone": "+91 8765432109",
        "fax": "+91 80 9876543",
        "pointOfContact": "User B"
      },
    ];

    clients = jsonClients.map((json) => Client.fromJson(json)).toList();
    _updateAndPrintJson();
  }

  void _updateAndPrintJson() {
    final jsonClients = clients.map((client) => client.toJson()).toList();
    print(json.encode(jsonClients));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [Theme.of(context).primaryColor.withOpacity(0.1), Colors.white],
            // ),
            ),
        child: ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, index) {
            return ClientCard(
              client: clients[index],
              onEdit: () => _editClient(index),
              onDelete: () => _deleteClient(index),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClientForm,
        icon: const Icon(Icons.add),
        label: const Text('Add Client'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _showAddClientForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Client'),
          content: ClientForm(
            onSave: (client) {
              setState(() {
                clients.add(client);
                _updateAndPrintJson();
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _editClient(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Client'),
          content: ClientForm(
            client: clients[index],
            onSave: (updatedClient) {
              setState(() {
                clients[index] = updatedClient;
                _updateAndPrintJson();
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _deleteClient(int index) {
    setState(() {
      clients.removeAt(index);
      _updateAndPrintJson();
    });
  }
}

class ClientForm extends StatefulWidget {
  final Client? client;
  final Function(Client) onSave;

  const ClientForm({super.key, this.client, required this.onSave});

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String address;
  String? state;
  late String email;
  late String phone;
  late String fax;
  late String pointOfContact;

  final List<String> indianStates = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      name = widget.client!.name;
      address = widget.client!.address;
      state = widget.client!.state;
      email = widget.client!.email;
      phone = widget.client!.phone;
      fax = widget.client!.fax;
      pointOfContact = widget.client!.pointOfContact;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.client?.name,
              decoration: _inputDecoration('Client Name', Icons.business),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
              onSaved: (value) => name = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.client?.address,
              decoration: _inputDecoration('Address', Icons.location_on),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an address' : null,
              onSaved: (value) => address = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: state,
              decoration: _inputDecoration('State', Icons.location_city),
              items: indianStates.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  state = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a state' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.client?.email,
              decoration: _inputDecoration('Email', Icons.email),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
              onSaved: (value) => email = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.client?.phone,
              decoration: _inputDecoration('Phone Number', Icons.phone),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a phone number';
                }
                if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
              onSaved: (value) => phone = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.client?.fax,
              decoration: _inputDecoration('Fax', Icons.fax),
              onSaved: (value) => fax = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.client?.pointOfContact,
              decoration: _inputDecoration('Point of Contact', Icons.person),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a point of contact' : null,
              onSaved: (value) => pointOfContact = value!,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSave(Client(
                    name: name,
                    address: address,
                    state: state!,
                    email: email,
                    phone: phone,
                    fax: fax,
                    pointOfContact: pointOfContact,
                  ));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text('Save Client',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
    );
  }
}

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ClientCard({
    super.key,
    required this.client,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          client.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          client.email,
          style: const TextStyle(fontSize: 13), 
        ),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            client.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    context, Icons.location_on, 'Address', client.address),
                _buildDetailRow(
                    context, Icons.location_city, 'State', client.state),
                _buildDetailRow(context, Icons.email, 'Email', client.email),
                _buildDetailRow(context, Icons.phone, 'Phone', client.phone),
                _buildDetailRow(context, Icons.fax, 'Fax', client.fax),
                _buildDetailRow(context, Icons.person, 'Point of Contact',
                    client.pointOfContact),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Client {
  final String name;
  final String address;
  final String state;
  final String email;
  final String phone;
  final String fax;
  final String pointOfContact;

  Client({
    required this.name,
    required this.address,
    required this.state,
    required this.email,
    required this.phone,
    required this.fax,
    required this.pointOfContact,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      name: json['name'],
      address: json['address'],
      state: json['state'],
      email: json['email'],
      phone: json['phone'],
      fax: json['fax'],
      pointOfContact: json['pointOfContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'state': state,
      'email': email,
      'phone': phone,
      'fax': fax,
      'pointOfContact': pointOfContact,
    };
  }
}
