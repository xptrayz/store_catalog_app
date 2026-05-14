class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String createdAt;
  final String updatedAt;
  final Store store;
  final ClassInfo classInfo;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
    required this.classInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      store: Store.fromJson(json['store'] ?? {}),
      classInfo: ClassInfo.fromJson(json['class'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': int.tryParse(price.replaceAll('.', '').replaceAll(',', '')) ?? 0,
      'description': description,
    };
  }
}

class Store {
  final int id;
  final String name;
  final String username;

  Store({required this.id, required this.name, required this.username});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
    );
  }
}

class ClassInfo {
  final int id;
  final String name;

  ClassInfo({required this.id, required this.name});

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class ProductResponse {
  final bool success;
  final String message;
  final List<Product> products;

  ProductResponse({
    required this.success,
    required this.message,
    required this.products,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data']['products'] as List? ?? [];
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products: productList,
    );
  }
}
