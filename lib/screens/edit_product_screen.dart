import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

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

  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          // "imageUrl": _editedProduct.imageUrl,
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          !_imageUrlController.text.endsWith(".png") &&
              !_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
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
              initialValue: _initValues["title"],
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
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite);
              },
            ),
            TextFormField(
              initialValue: _initValues["price"],
              decoration: const InputDecoration(
                label: Text("Price"),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a price";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a valid number";
                }
                if (double.parse(value) <= 0) {
                  return "Please enter a number greater than zero";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: double.parse(value!),
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite);
              },
            ),
            TextFormField(
              initialValue: _initValues["description"],
              decoration: const InputDecoration(
                label: Text("Descriotion"),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              focusNode: _descriptionFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter a description";
                }
                if (value.length < 10) {
                  return "Should be at least 10 charecters long";
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                    title: _editedProduct.description,
                    description: value.toString(),
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    isFavorite: _editedProduct.isFavorite);
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
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an image URL";
                    }
                    if (!value.startsWith("http") &&
                        !value.startsWith("https")) {
                      return "Please enter a valid Image URl";
                    }
                    if (!value.endsWith(".png") &&
                        !value.endsWith(".jpg") &&
                        !value.endsWith(".jpeg")) {
                      return "Please enter a valid URL";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: value.toString(),
                        price: _editedProduct.price,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite);
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
