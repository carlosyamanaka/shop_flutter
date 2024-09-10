import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter/models/product.dart';
import 'package:shop_flutter/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final priceFocus = FocusNode();
  final descriptionFocus = FocusNode();

  final imageUrlFocus = FocusNode();
  final imageUrlController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  // ignore: prefer_collection_literals
  final formData = Map<String, Object>();

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFile;
  }

  @override
  void initState() {
    super.initState();
    imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments; //Tendi nada

      if (arg != null) {
        final product = arg as Product;
        formData['id'] = product.id;
        formData['name'] = product.name;
        formData['price'] = product.price;
        formData['description'] = product.description;
        formData['imageUrl'] = product.imageUrl;

        imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    priceFocus.dispose();
    descriptionFocus.dispose();

    imageUrlFocus.removeListener(updateImage);
    imageUrlFocus.dispose();
  }

  void submitForm() {
    formKey.currentState?.save();

    final isValid = formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    formKey.currentState?.save();

    Provider.of<ProductList>(
      context,
      listen: false,
    ).saveProduct(formData);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            onPressed: submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              TextFormField(
                initialValue: formData['name']?.toString(),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(priceFocus);
                },
                onSaved: (name) => formData['name'] = name ?? '',
                validator: (name) {
                  final newName = name ?? '';

                  if (newName.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }

                  if (newName.trim().length < 3) {
                    return 'Nome precisa de no mínimo 3 letras';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: formData['price']?.toString(),
                decoration: const InputDecoration(labelText: 'Preço'),
                textInputAction: TextInputAction.next,
                focusNode: priceFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(descriptionFocus);
                },
                onSaved: (price) =>
                    formData['price'] = double.parse(price ?? '0'),
                validator: (price) {
                  final priceString = price ?? '-1';
                  final newPrice = double.tryParse(priceString) ?? -1;

                  if (newPrice <= 0) {
                    return 'Informe um preço válido.';
                  }

                  return null;
                },
              ),
              TextFormField(
                initialValue: formData['description']?.toString(),
                decoration: const InputDecoration(labelText: 'Descrição'),
                textInputAction: TextInputAction.next,
                focusNode: descriptionFocus,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) =>
                    formData['description'] = description ?? '',
                validator: (description) {
                  final newDescription = description ?? '';

                  if (newDescription.trim().isEmpty) {
                    return 'Descrição é obrigatória';
                  }

                  if (newDescription.trim().length < 10) {
                    return 'Descrição precisa de no mínimo 10 letras';
                  }

                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Url da Imagem'),
                      focusNode: imageUrlFocus,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: imageUrlController,
                      onFieldSubmitted: (_) => submitForm(),
                      onSaved: (imageUrl) =>
                          formData['imageUrl'] = imageUrl ?? '',
                      validator: (imageUrl) {
                        final newImageUrl = imageUrl ?? '';

                        if (!isValidImageUrl(newImageUrl)) {
                          return 'Informe uma Url válida';
                        }

                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: imageUrlController.text.isEmpty
                        ? const Text('Informe a Url')
                        : FittedBox(
                            fit: BoxFit.cover,
                            child: Image.network(imageUrlController.text),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
