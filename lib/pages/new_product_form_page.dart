import 'package:PBStore/components/responsive.dart';
import 'package:PBStore/utils/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import '../providers/product_repository.dart';
import '../utils/constants.dart';

class NewProductFormPage extends StatefulWidget {
  const NewProductFormPage({Key? key}) : super(key: key);

  @override
  State<NewProductFormPage> createState() => _NewProductFormPageState();
}

class _NewProductFormPageState extends State<NewProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _urlFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
  }

  bool isValidImageUrl(String url) {
    bool isValidURL = Uri.parse(url).hasAbsolutePath;
    bool endsWithExtension = url.toLowerCase().endsWith('png') ||
        url.toLowerCase().endsWith('jpg') ||
        url.toLowerCase().endsWith('jpeg') ||
        url.toLowerCase().endsWith('webp');
    return isValidURL && endsWithExtension;
  }

  @override
  Widget build(BuildContext context) {
    final ProductRepository productList = Provider.of(context);
    return Responsive.isXTest(context)
        ? const Scaffold()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Novo Produto'),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : SingleChildScrollView(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: maxWidth),
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Nome é obrigatório'),
                                  Validatorless.max(20, 'Máximo de 20 caracteres')
                                ]),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_priceFocus);
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Nome do Item',
                                    prefixIcon: Icon(FontAwesomeIcons.tag, size: 22)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: TextFormField(
                                  focusNode: _priceFocus,
                                  controller: _priceController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true),
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Preço é obrigatório'),
                                    Validatorless.number('Apenas números'),
                                    Validatorless.numbersBetweenInterval(
                                        0.01, double.infinity, 'Valor não pode ser Zero')
                                  ]),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_descriptionFocus);
                                  },
                                  decoration: const InputDecoration(
                                      labelText: 'Preço do Item',
                                      prefixIcon:
                                          Icon(FontAwesomeIcons.dollarSign, size: 22)),
                                ),
                              ),
                              TextFormField(
                                focusNode: _descriptionFocus,
                                controller: _descriptionController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Descrição é obrigatória'),
                                  Validatorless.max(90, 'Máximo de 90 caracteres'),
                                  Validatorless.min(15, 'Mínimo de 15 caracteres')
                                ]),
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).requestFocus(_urlFocus);
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Descrição do Item',
                                    prefixIcon: Icon(FontAwesomeIcons.filePen, size: 22)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                child: Center(
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _urlController.text,
                                          fit: BoxFit.cover,
                                          errorBuilder: (BuildContext context,
                                              Object exception, StackTrace? stackTrace) {
                                            return const Center(
                                                child: Text(
                                              'Insira URL da imagem',
                                              textAlign: TextAlign.center,
                                            ));
                                          },
                                        )),
                                  ),
                                ),
                              ),
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {});
                                },
                                focusNode: _urlFocus,
                                controller: _urlController,
                                textInputAction: TextInputAction.done,
                                validator: (url) {
                                  if (!isValidImageUrl(_urlController.text)) {
                                    return 'Informe a URL da imagem';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Url da Imagem',
                                    prefixIcon: Icon(FontAwesomeIcons.link, size: 22)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      var formValid =
                                          _formKey.currentState?.validate() ?? false;
                                      if (formValid) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        productList
                                            .saveProduct(
                                                _nameController,
                                                _descriptionController,
                                                _priceController,
                                                _urlController)
                                            .catchError((error) {
                                          return showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                    title: const Text('Erro'),
                                                    content: const Text('Verifique a '
                                                        'conexão '
                                                        'com a Internet ou tente '
                                                        'novamente mais tarde.'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              _isLoading = false;
                                                            });
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text(
                                                            'Voltar',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight.bold),
                                                          ))
                                                    ],
                                                  ));
                                        }).then((response) {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Produto criado com sucesso')));
                                          Navigator.of(context).pop();
                                        });
                                      }
                                    },
                                    style: ButtonStyle(
                                        surfaceTintColor:
                                            MaterialStateProperty.all(stanColor)),
                                    child: const Text(
                                      'Cadastrar',
                                      style: TextStyle(fontSize: 20),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          );
  }
}
