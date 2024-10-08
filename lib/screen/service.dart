import 'package:flutter/material.dart';
import 'package:hrms/components/servicecard.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<Map<String, String>> serviceRequests = [
    {
      'Ticket#': '12345',
      'Request For': 'IT Support',
      'Category': 'Hardware',
      'Request Type/Asset Name': 'Laptop',
      'Priority': 'High',
      'Description': 'Need a new laptop for work',
      'Raised By': 'John Doe',
      'Raised On': '2023-04-15',
      'Status': 'Pending',
    }
  ];

  void _showAddRequestBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return NewRequestForm(onSubmit: _addNewRequest);
      },
    );
  }

  void _addNewRequest(Map<String, String> newRequest) {
    setState(() {
      serviceRequests.add({
        'Ticket#': '${10000 + serviceRequests.length}',
        'Raised On': DateTime.now().toString().split(' ')[0],
         ...newRequest,
        'Status': 'pending',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddRequestBottomSheet,
            tooltip: 'New Request',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: serviceRequests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Servicecard(
              title: 'Service Request #${index + 1}',
              details: serviceRequests[index],
              onEdit: (editedDetails) {
                setState(() {
                  serviceRequests[index] = editedDetails;
                });
              },
            ),
          );
        },
      ),
    );
  }
}

class NewRequestForm extends StatefulWidget {
  final Function(Map<String, String>) onSubmit;

  const NewRequestForm({super.key, required this.onSubmit});

  @override
  // ignore: library_private_types_in_public_api
  _NewRequestFormState createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        
        padding: const EdgeInsets.all(21.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Request For'),
                onSaved: (value) => _formData['Request For'] = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onSaved: (value) => _formData['Category'] = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Request Type/Asset Name'),
                onSaved: (value) => _formData['Request Type/Asset Name'] = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Priority'),
                onSaved: (value) => _formData['Priority'] = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => _formData['Description'] = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Raised By'),
                onSaved: (value) => _formData['Raised By'] = value ?? '',
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSubmit(_formData);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
