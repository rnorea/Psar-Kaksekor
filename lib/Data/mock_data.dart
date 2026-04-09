import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/farm_model.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/user_model.dart';
import '../providers/product_provider.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PRODUCTS
// ─────────────────────────────────────────────────────────────────────────────

final List<ProductModel> mockProducts = [
  ProductModel(
    id: 'p1',
    name: 'Fresh Broccoli',
    farmName: 'Green Valley Farm',
    emoji: '🥦',
    bgColor: const Color(0xFFE8F5EC),
    basePrice: 2.50,
    unit: 'kg',
    stock: 45,
    category: 'veg',
    description: 'Crispy fresh broccoli harvested this morning. Rich in vitamins C and K. Grown without pesticides in our highland farm.',
    isOrganic: true,
    rating: 4.8,
    reviewCount: 124,
  ),
  ProductModel(
    id: 'p2',
    name: 'Jasmine Rice 5kg',
    farmName: 'Mekong Rice Co.',
    emoji: '🌾',
    bgColor: const Color(0xFFFFF8E1),
    basePrice: 8.00,
    unit: 'bag',
    stock: 30,
    category: 'grain',
    description: 'Premium Thai jasmine rice sourced directly from Kampong Thom province. Fragrant, soft, and perfect for every meal.',
    isOrganic: false,
    rating: 4.9,
    reviewCount: 312,
  ),
  ProductModel(
    id: 'p3',
    name: 'Red Tomatoes',
    farmName: 'Sunrise Organics',
    emoji: '🍅',
    bgColor: const Color(0xFFFFEBEE),
    basePrice: 1.80,
    unit: 'kg',
    stock: 60,
    category: 'veg',
    description: 'Sun-ripened red tomatoes bursting with flavor. Great for cooking and fresh salads. 100% organic certified.',
    isOrganic: true,
    rating: 4.6,
    reviewCount: 88,
  ),
  ProductModel(
    id: 'p4',
    name: 'Fresh Mangoes',
    farmName: 'Kampot Orchards',
    emoji: '🥭',
    bgColor: const Color(0xFFFFF3E0),
    basePrice: 3.20,
    unit: 'kg',
    stock: 25,
    category: 'fruit',
    description: 'Sweet Kampot mangoes at peak ripeness. Naturally grown in the famous mango belts of southern Cambodia.',
    isOrganic: false,
    rating: 4.7,
    reviewCount: 201,
  ),
  ProductModel(
    id: 'p5',
    name: 'Lemongrass Bundle',
    farmName: 'Herb Haven',
    emoji: '🌿',
    bgColor: const Color(0xFFE8F5EC),
    basePrice: 0.80,
    unit: 'bunch',
    stock: 80,
    category: 'herb',
    description: 'Fresh lemongrass cut daily. Essential for Khmer cooking. Aromatic, tender stalks packed with citrusy fragrance.',
    isOrganic: true,
    rating: 4.5,
    reviewCount: 56,
  ),
  ProductModel(
    id: 'p6',
    name: 'Free-Range Eggs',
    farmName: 'Happy Hen Farm',
    emoji: '🥚',
    bgColor: const Color(0xFFFFF9C4),
    basePrice: 4.50,
    unit: 'bag',
    stock: 50,
    category: 'dairy',
    description: 'Farm-fresh free-range eggs from hens raised in open fields. Rich golden yolks. Sold per tray of 30.',
    isOrganic: false,
    rating: 4.9,
    reviewCount: 445,
  ),
  ProductModel(
    id: 'p7',
    name: 'Sweet Corn',
    farmName: 'Green Valley Farm',
    emoji: '🌽',
    bgColor: const Color(0xFFFFFDE7),
    basePrice: 1.20,
    unit: 'pc',
    stock: 100,
    category: 'veg',
    description: 'Sweet and juicy corn cobs freshly picked. Perfect for grilling, boiling, or eating straight off the cob.',
    isOrganic: true,
    rating: 4.4,
    reviewCount: 73,
  ),
  ProductModel(
    id: 'p8',
    name: 'Dragon Fruit',
    farmName: 'Kampot Orchards',
    emoji: '🐉',
    bgColor: const Color(0xFFFCE4EC),
    basePrice: 5.00,
    unit: 'kg',
    stock: 20,
    category: 'fruit',
    description: 'Vibrant pink dragon fruit from Kampot. Sweet white flesh with tiny crunchy seeds. Packed with antioxidants.',
    isOrganic: false,
    rating: 4.6,
    reviewCount: 92,
  ),
  ProductModel(
    id: 'p9',
    name: 'Morning Glory',
    farmName: 'Sunrise Organics',
    emoji: '🌱',
    bgColor: const Color(0xFFE8F5EC),
    basePrice: 0.60,
    unit: 'bunch',
    stock: 7,
    category: 'veg',
    description: 'Fresh morning glory (water spinach) — a staple in Cambodian cuisine. Stir-fry with garlic for a classic dish.',
    isOrganic: true,
    rating: 4.3,
    reviewCount: 34,
  ),
  ProductModel(
    id: 'p10',
    name: 'Black Pepper 500g',
    farmName: 'Kampot Spice Co.',
    emoji: '🫙',
    bgColor: const Color(0xFFF3E5F5),
    basePrice: 6.50,
    unit: 'bag',
    stock: 40,
    category: 'herb',
    description: 'Authentic Kampot black pepper — world-renowned for its complex aroma. Hand-picked and sun-dried. No additives.',
    isOrganic: true,
    rating: 5.0,
    reviewCount: 530,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// FARMS
// ─────────────────────────────────────────────────────────────────────────────

final List<FarmModel> mockFarms = [
  FarmModel(
    id: 'f1',
    name: 'Green Valley',
    emoji: '🌿',
    bgColor: const Color(0xFFE8F5EC),
    rank: 1,
    rankLabel: '↑ #1',
    featuredProduct: mockProducts[0], // Broccoli
  ),
  FarmModel(
    id: 'f2',
    name: 'Mekong Rice',
    emoji: '🌾',
    bgColor: const Color(0xFFFFF8E1),
    rank: 2,
    rankLabel: '— #2',
    featuredProduct: mockProducts[1], // Jasmine Rice
  ),
  FarmModel(
    id: 'f3',
    name: 'Kampot Orchards',
    emoji: '🥭',
    bgColor: const Color(0xFFFFF3E0),
    rank: 3,
    rankLabel: '↑ #3',
    featuredProduct: mockProducts[3], // Mangoes
  ),
  FarmModel(
    id: 'f4',
    name: 'Sunrise Organics',
    emoji: '🍅',
    bgColor: const Color(0xFFFFEBEE),
    rank: 4,
    rankLabel: '↓ #4',
    featuredProduct: mockProducts[2], // Tomatoes
  ),
  FarmModel(
    id: 'f5',
    name: 'Happy Hen',
    emoji: '🥚',
    bgColor: const Color(0xFFFFF9C4),
    rank: 5,
    rankLabel: '— #5',
    featuredProduct: mockProducts[5], // Eggs
  ),
  FarmModel(
    id: 'f6',
    name: 'Kampot Spice',
    emoji: '🫙',
    bgColor: const Color(0xFFF3E5F5),
    rank: 6,
    rankLabel: '↑ #6',
    featuredProduct: mockProducts[9], // Black Pepper
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// ORDERS
// ─────────────────────────────────────────────────────────────────────────────

final List<OrderModel> mockBuyerOrders = [
  OrderModel(
    id: 'ORD-1001',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p1',
        name: 'Fresh Broccoli',
        emoji: '🥦',
        price: 2.50,
        quantity: 2,
        unit: 'kg',
      ),
      CartItemModel(
        productId: 'p5',
        name: 'Lemongrass Bundle',
        emoji: '🌿',
        price: 0.80,
        quantity: 3,
        unit: 'bunch',
      ),
    ],
    total: 7.40,
    status: OrderStatus.onWay,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    buyerName: 'Vanuth',
    deliveryAddress: 'Toul Kork, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-1002',
    farmName: 'Mekong Rice Co.',
    items: [
      CartItemModel(
        productId: 'p2',
        name: 'Jasmine Rice 5kg',
        emoji: '🌾',
        price: 8.00,
        quantity: 1,
        unit: 'bag',
      ),
    ],
    total: 8.00,
    status: OrderStatus.delivered,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    buyerName: 'Vanuth',
    deliveryAddress: 'Toul Kork, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-1003',
    farmName: 'Kampot Orchards',
    items: [
      CartItemModel(
        productId: 'p4',
        name: 'Fresh Mangoes',
        emoji: '🥭',
        price: 3.20,
        quantity: 2,
        unit: 'kg',
      ),
      CartItemModel(
        productId: 'p8',
        name: 'Dragon Fruit',
        emoji: '🐉',
        price: 5.00,
        quantity: 1,
        unit: 'kg',
      ),
    ],
    total: 11.40,
    status: OrderStatus.confirmed,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    buyerName: 'Vanuth',
    deliveryAddress: 'Toul Kork, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-1004',
    farmName: 'Happy Hen Farm',
    items: [
      CartItemModel(
        productId: 'p6',
        name: 'Free-Range Eggs',
        emoji: '🥚',
        price: 4.50,
        quantity: 2,
        unit: 'bag',
      ),
    ],
    total: 9.00,
    status: OrderStatus.delivered,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    buyerName: 'Vanuth',
    deliveryAddress: 'Toul Kork, Phnom Penh',
  ),
];

final List<OrderModel> mockSellerOrders = [
  OrderModel(
    id: 'ORD-2001',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p1',
        name: 'Fresh Broccoli',
        emoji: '🥦',
        price: 2.50,
        quantity: 3,
        unit: 'kg',
      ),
    ],
    total: 7.50,
    status: OrderStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    buyerName: 'Sophea Keo',
    deliveryAddress: 'BKK1, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-2002',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p7',
        name: 'Sweet Corn',
        emoji: '🌽',
        price: 1.20,
        quantity: 6,
        unit: 'pc',
      ),
      CartItemModel(
        productId: 'p9',
        name: 'Morning Glory',
        emoji: '🌱',
        price: 0.60,
        quantity: 2,
        unit: 'bunch',
      ),
    ],
    total: 8.40,
    status: OrderStatus.confirmed,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    buyerName: 'Dara Meng',
    deliveryAddress: 'Daun Penh, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-2003',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p1',
        name: 'Fresh Broccoli',
        emoji: '🥦',
        price: 2.50,
        quantity: 5,
        unit: 'kg',
      ),
    ],
    total: 12.50,
    status: OrderStatus.onWay,
    createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    buyerName: 'Pisey Chan',
    deliveryAddress: 'Sen Sok, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-2004',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p3',
        name: 'Red Tomatoes',
        emoji: '🍅',
        price: 1.80,
        quantity: 4,
        unit: 'kg',
      ),
    ],
    total: 7.20,
    status: OrderStatus.delivered,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    buyerName: 'Ratha Nhem',
    deliveryAddress: 'Chamkarmon, Phnom Penh',
  ),
  OrderModel(
    id: 'ORD-2005',
    farmName: 'Green Valley Farm',
    items: [
      CartItemModel(
        productId: 'p5',
        name: 'Lemongrass Bundle',
        emoji: '🌿',
        price: 0.80,
        quantity: 10,
        unit: 'bunch',
      ),
    ],
    total: 8.00,
    status: OrderStatus.delivered,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    buyerName: 'Kosal Lim',
    deliveryAddress: 'Meanchey, Phnom Penh',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// USER
// ─────────────────────────────────────────────────────────────────────────────

final UserModel mockBuyerUser = UserModel(
  id: 'u1',
  name: 'Vanuth',
  email: 'vanuth@example.com',
  phone: '+855 12 345 678',
  location: 'Toul Kork, Phnom Penh',
  role: UserRole.buyer,
  avatarInitial: 'V',
);

final UserModel mockSellerUser = UserModel(
  id: 'u2',
  name: 'Sophea Keo',
  email: 'sophea@greenvalley.kh',
  phone: '+855 17 654 321',
  location: 'Kampong Speu',
  role: UserRole.seller,
  avatarInitial: 'S',
  farmName: 'Green Valley Farm',
  produceType: 'Vegetables & Herbs',
  province: 'Kampong Speu',
  isOrganic: true,
);

// ─────────────────────────────────────────────────────────────────────────────
// SEED FUNCTION — call this once in main.dart after providers are ready
// ─────────────────────────────────────────────────────────────────────────────

void seedMockData({
  required ProductProvider productProvider,
  required OrderProvider orderProvider,
  required AuthProvider authProvider,
  required UserProvider userProvider,
}) {
  // Products + trending (top 5 by rating)
  productProvider.setProducts(mockProducts);
  final trending = [...mockProducts]
    ..sort((a, b) => b.rating.compareTo(a.rating));
  productProvider.setTrendingProducts(trending.take(5).toList());
  productProvider.setFarms(mockFarms);

  // Orders
  orderProvider.setBuyerOrders(mockBuyerOrders);
  orderProvider.setSellerOrders(mockSellerOrders);

  // Logged-in user (buyer by default)
  authProvider.setUser(mockBuyerUser);
  userProvider.setProfile(mockBuyerUser);
}
