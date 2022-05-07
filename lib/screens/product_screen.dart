import 'package:flutter/material.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 40,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 60,
                    right: 40,
                    child: IconButton(
                        onPressed: () {
                          //TODO Cámara o galería
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        ))),
              ],
            ),
            _ProductForm(),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 300,
        decoration: _buildDecoration(),
        child: Form(
            child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecorations.authInputDecoration(hintText: 'Nombre del producto', labelText: 'Nombre:'),
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecorations.authInputDecoration(hintText: '\€25', labelText: 'Precio:'),
            ),
            const SizedBox(
              height: 30,
            ),
            SwitchListTile.adaptive(
              value: true,
              onChanged: (_) {
                //TODO Pendiente
              },
              activeColor: Colors.indigo,
              title: const Text('Disponible'),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: Offset(0, 5), blurRadius: 5)]);
}
