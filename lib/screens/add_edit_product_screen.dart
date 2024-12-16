import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  late double _price;
  late String _location;
  late String _expiryDate;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.product?.name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter product name' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: widget.product?.quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
                onSaved: (value) => _quantity = int.parse(value!),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: widget.product?.price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
                onSaved: (value) => _price = double.parse(value!),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: widget.product?.location,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Enter location' : null,
                onSaved: (value) => _location = value!,
              ),
              TextFormField(
                initialValue: widget.product?.expiryDate,
                decoration: const InputDecoration(
                    labelText: 'Expiry Date (YYYY-MM-DD)'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter expiry date' : null,
                onSaved: (value) => _expiryDate = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newProduct = Product(
                      id: widget.product?.id,
                      name: _name,
                      quantity: _quantity,
                      price: _price,
                      location: _location,
                      expiryDate: _expiryDate,
                    );

                    if (widget.product == null) {
                      // Adding new product
                      provider.addProduct(newProduct);
                    } else {
                      // Updating existing product
                      provider.updateProduct(newProduct);
                    }

                    Navigator.of(context)
                        .pop(); // Return to product list screen
                  }
                },
                child: Text(
                    widget.product == null ? 'Add Product' : 'Save Changes'),
              ),
              const SizedBox(height: 10),
              if (widget.product != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    provider.deleteProduct(widget.product!.id!);
                    Navigator.of(context)
                        .pop(); // Return to product list screen
                  },
                  child: const Text('Delete Product'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
