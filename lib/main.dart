import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ProductPage()));
}

class Product {
  String name;
  int price;
  String imageUrl;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

class ProductPage extends StatefulWidget {
  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  List<Product> products = [];

  void addProduct(Product product) {
    setState(() {
      products.add(product);
    });
  }

  void updateProduct(int index, Product product) {
    setState(() {
      products[index] = product;
    });
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void showForm({Product? product, int? index}) {
    TextEditingController nameController =
        TextEditingController(text: product?.name ?? "");
    TextEditingController priceController =
        TextEditingController(text: product?.price.toString() ?? "");
    TextEditingController imageController =
        TextEditingController(text: product?.imageUrl ?? "");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: "Image URL"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                name: nameController.text,
                price: int.parse(priceController.text),
                imageUrl: imageController.text,
              );

              if (product == null) {
                addProduct(newProduct);
              } else {
                updateProduct(index!, newProduct);
              }

              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD App Produk"),
        backgroundColor: const Color.fromARGB(255, 8, 12, 243)     ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (_, index) {
          return ListTile(
            leading: products[index].imageUrl.isNotEmpty
                ? Image.network(
                    products[index].imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.image, size: 50, color: Colors.grey),
            title: Text(products[index].name),
            subtitle: Text("Rp ${products[index].price}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      showForm(product: products[index], index: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteProduct(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}