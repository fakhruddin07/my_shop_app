import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null.toString(),
    title: "",
    description: "",
    imageUrl: "",
    price: 0,
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Title"),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please provide a title";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: value.toString(),
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  id: null.toString(),
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Price"),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  price: double.parse(value!),
                  id: null.toString(),
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text("Descriotion"),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              focusNode: _descriptionFocusNode,
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.description,
                  description: value.toString(),
                  imageUrl: _editedProduct.imageUrl,
                  price: _editedProduct.price,
                  id: null.toString(),
                );
              },
            ),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(top: 10, right: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                ),
                child: _imageUrlController.text.isEmpty
                    ? const Text("Enter a URL")
                    : FittedBox(
                        child: Image.network(
                          _imageUrlController.text,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Image Url"),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  onFieldSubmitted: (_) {
                    _saveForm();
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      imageUrl: value.toString(),
                      price: _editedProduct.price,
                      id: null.toString(),
                    );
                  },
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
