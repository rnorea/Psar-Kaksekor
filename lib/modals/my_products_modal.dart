import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/product_model.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/widgets/common/bottom_sheet_handle.dart';
import 'package:phsar_kaksekor_app/widgets/seller/product_list_tile.dart';
import 'add_product_modal.dart';

class MyProductsModal extends StatelessWidget {
  const MyProductsModal({super.key});

  void _openAddProduct(BuildContext context) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddProductModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>().allProducts;

    return Container(
      decoration: const BoxDecoration(
        color: colorOff,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ────────────────────────────────────────────────────────
          const BottomSheetHandle(),

          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📦 My Products',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: colorTextDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: colorG100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '✕',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: colorG600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Add button ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: GestureDetector(
              onTap: () => _openAddProduct(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(
                  color: colorDark,
                  borderRadius: BorderRadius.circular(kRadiusBtn),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '＋ Add New Product',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                    fontSize: 12.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // ── Product list ──────────────────────────────────────────────────
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🌱', style: TextStyle(fontSize: 36)),
                        const SizedBox(height: 10),
                        const Text(
                          'No products yet',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: colorTextDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap "Add New Product" to list your first item',
                          style: TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 11,
                            color: colorG400,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductListTile(
                        product: product,
                        onEdit: () => _onEdit(context, product),
                        onDelete: () => _onDelete(context, product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _onEdit(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddProductModal(editProduct: product),
    );
  }

  void _onDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusCard),
        ),
        title: const Text(
          'Delete Product?',
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: colorTextDark,
          ),
        ),
        content: Text(
          'Remove "${product.name}" from your listings?',
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 12,
            color: colorG600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                color: colorG600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductProvider>().removeProduct(product.id);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                color: colorRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
