import 'package:flutter/material.dart';

import '../provider/provider.dart';

class ProductSearchDelegate extends SearchDelegate {
  final ProductProvider provider;

  ProductSearchDelegate({required this.provider});

  @override
  List<Widget>? buildActions(BuildContext context) {
    // أزرار الإجراءات في شريط البحث (مثل زر الحذف).
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // تصفية النص المدخل.
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // زر الرجوع في شريط البحث.
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // إغلاق البحث.
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // عرض النتائج بناءً على الإدخال.
    final results = provider.products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          title: Text(product.name),
          subtitle:
              Text('Quantity: ${product.quantity}, Price: ${product.price}'),
          onTap: () {
            close(context,
                product); // يمكنك تنفيذ الإجراء المطلوب عند اختيار عنصر.
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // اقتراحات أثناء الكتابة.
    final suggestions = provider.products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.location.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion.name),
          subtitle: Text('Location: ${suggestion.location}'),
          onTap: () {
            query = suggestion.name; // عند اختيار اقتراح.
            showResults(context); // عرض النتائج.
          },
        );
      },
    );
  }
}
