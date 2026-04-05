import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../models/product_model.dart';
import '../widgets/seller/product_list_tile.dart';
import 'package:phsar_kaksekor_app/widgets/common/custom_button.dart';
import '../widgets/common/bottom_sheet_handle.dart';

class MyProductsModal extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback onAddProduct;
  final ValueChanged<ProductModel> onEdit;
  final ValueChanged<ProductModel> onDelete;

  const MyProductsModal({
    super.key,
    required this.products,
    required this.onAddProduct,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
      child: Column(
        children: [
          const BottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('📦 My Products',
                  style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w900, fontSize: 15, color: colorTextDark),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(color: colorG100, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: const Text('✕', style: TextStyle(fontSize: 13, color: colorG600)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: colorG100, height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  CustomButton(
                    label: '＋ Add New Product',
                    onPressed: () {
                      Navigator.pop(context);
                      onAddProduct();
                    },
                  ),
                  const SizedBox(height: 12),
                  ...products.map((product) => ProductListTile(
                    product: product,
                    onEdit: () => onEdit(product),
                    onDelete: () => onDelete(product),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showMyProducts(
    BuildContext context,
    List<ProductModel> products, {
      required VoidCallback onAddProduct,
      required ValueChanged<ProductModel> onEdit,
      required ValueChanged<ProductModel> onDelete,
    }) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => MyProductsModal(
      products: products,
      onAddProduct: onAddProduct,
      onEdit: onEdit,
      onDelete: onDelete,
    ),
  );
}