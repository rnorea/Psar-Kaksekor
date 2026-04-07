import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:phsar_kaksekor_app/core/constants/app_colors.dart';
import 'package:phsar_kaksekor_app/core/constants/app_constants.dart';
import 'package:phsar_kaksekor_app/models/product_model.dart';
import 'package:phsar_kaksekor_app/providers/product_provider.dart';
import 'package:phsar_kaksekor_app/widgets/common/bottom_sheet_handle.dart';

class AddProductModal extends StatefulWidget {
  final ProductModel? editProduct;

  const AddProductModal({super.key, this.editProduct});

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _descCtrl;

  String? _selectedCategory;
  String? _selectedUnit;
  final Set<String> _selectedCerts = {};
  bool _hasPhoto = false;

  bool get isEditing => widget.editProduct != null;

  static const _categories = [
    '🥦 Vegetables',
    '🌾 Grains & Rice',
    '🍎 Fruits',
    '🌿 Herbs',
    '🥚 Eggs & Dairy',
  ];

  static const _units = [
    'per kg',
    'per piece',
    'per bunch',
    'per bag',
  ];

  static const _certOptions = ['✓ Organic', 'No Pesticide', 'Local Farm'];

  @override
  void initState() {
    super.initState();
    final p = widget.editProduct;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(
        text: p != null ? p.basePrice.toStringAsFixed(2) : '');
    _stockCtrl = TextEditingController(
        text: p != null ? p.stock.toString() : '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _selectedCategory = p?.category;
    _selectedUnit = p != null ? 'per ${p.unit}' : null;
    if (p?.isOrganic == true) _selectedCerts.add('✓ Organic');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      _showError('Please select a category.');
      return;
    }
    if (_selectedUnit == null) {
      _showError('Please select a unit.');
      return;
    }

    final provider = context.read<ProductProvider>();

    // Map category label to key
    final catMap = {
      '🥦 Vegetables': 'veg',
      '🌾 Grains & Rice': 'grain',
      '🍎 Fruits': 'fruit',
      '🌿 Herbs': 'herb',
      '🥚 Eggs & Dairy': 'dairy',
    };

    final unitMap = {
      'per kg': 'kg',
      'per piece': 'pc',
      'per bunch': 'bunch',
      'per bag': 'bag',
    };

    // Emoji + bg color by category
    const emojiMap = {
      'veg': ('🥦', Color(0xFFE8F5EC)),
      'grain': ('🌾', Color(0xFFFFF8E1)),
      'fruit': ('🍎', Color(0xFFFFEBEE)),
      'herb': ('🌿', Color(0xFFE8F5EC)),
      'dairy': ('🥚', Color(0xFFFFF9C4)),
    };

    final catKey = catMap[_selectedCategory] ?? 'veg';
    final (emoji, bgColor) = emojiMap[catKey] ?? ('🌿', const Color(0xFFE8F5EC));

    final newProduct = ProductModel(
      id: isEditing
          ? widget.editProduct!.id
          : 'prod_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameCtrl.text.trim(),
      farmName: 'My Farm',
      emoji: emoji,
      bgColor: bgColor,
      basePrice: double.tryParse(_priceCtrl.text) ?? 0,
      unit: unitMap[_selectedUnit] ?? 'kg',
      stock: int.tryParse(_stockCtrl.text) ?? 0,
      category: catKey,
      description: _descCtrl.text.trim(),
      isOrganic: _selectedCerts.contains('✓ Organic'),
      rating: isEditing ? widget.editProduct!.rating : 0,
      reviewCount: isEditing ? widget.editProduct!.reviewCount : 0,
    );

    if (isEditing) {
      provider.updateProduct(newProduct);
    } else {
      provider.addProduct(newProduct);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Product updated!' : 'Product added!'),
        backgroundColor: colorDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: colorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──────────────────────────────────────────────────────
            const BottomSheetHandle(),

            // ── Header ──────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditing ? '✏️ Edit Product' : '＋ Add New Product',
                    style: const TextStyle(
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

            // ── Form body ────────────────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      _FormGroup(
                        label: 'Product Name *',
                        child: TextFormField(
                          controller: _nameCtrl,
                          style: _inputStyle,
                          decoration: _inputDecoration('e.g. Fresh Broccoli'),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                      ),

                      // Category
                      _FormGroup(
                        label: 'Category *',
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          style: _inputStyle,
                          decoration: _inputDecoration('Select category'),
                          items: _categories
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c, style: _inputStyle),
                                  ))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedCategory = v),
                        ),
                      ),

                      // Price + Unit row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _FormGroup(
                              label: 'Price (\$) *',
                              child: TextFormField(
                                controller: _priceCtrl,
                                style: _inputStyle,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}')),
                                ],
                                decoration: _inputDecoration('0.00'),
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Required';
                                  if (double.tryParse(v) == null) {
                                    return 'Invalid';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _FormGroup(
                              label: 'Unit *',
                              child: DropdownButtonFormField<String>(
                                value: _selectedUnit,
                                style: _inputStyle,
                                decoration: _inputDecoration('Select'),
                                isExpanded: true,
                                items: _units
                                    .map((u) => DropdownMenuItem(
                                          value: u,
                                          child: Text(u, style: _inputStyle),
                                        ))
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedUnit = v),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Stock
                      _FormGroup(
                        label: 'Stock Available *',
                        child: TextFormField(
                          controller: _stockCtrl,
                          style: _inputStyle,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _inputDecoration('e.g. 50'),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (int.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ),

                      // Description
                      _FormGroup(
                        label: 'Description',
                        child: TextFormField(
                          controller: _descCtrl,
                          style: _inputStyle,
                          maxLines: 3,
                          decoration: _inputDecoration(
                            'Tell buyers about your product...',
                          ),
                        ),
                      ),

                      // Certifications
                      _FormGroup(
                        label: 'Certifications',
                        child: Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: _certOptions.map((cert) {
                            final selected = _selectedCerts.contains(cert);
                            return GestureDetector(
                              onTap: () => setState(() {
                                if (selected) {
                                  _selectedCerts.remove(cert);
                                } else {
                                  _selectedCerts.add(cert);
                                }
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 6),
                                decoration: BoxDecoration(
                                  color: selected ? colorPale : colorG100,
                                  border: Border.all(
                                    color:
                                        selected ? colorAccent : colorG200,
                                    width: 1.5,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(kRadiusChip),
                                ),
                                child: Text(
                                  cert,
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10.5,
                                    color: selected ? colorAccent : colorG600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      // Photo upload
                      _FormGroup(
                        label: 'Product Photo',
                        child: GestureDetector(
                          onTap: () => setState(() => _hasPhoto = !_hasPhoto),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 70,
                            decoration: BoxDecoration(
                              color: _hasPhoto ? colorPale : Colors.white,
                              borderRadius:
                                  BorderRadius.circular(kRadiusInput),
                              border: Border.all(
                                color: _hasPhoto ? colorAccent : colorG200,
                                width: 2,
                                style: _hasPhoto
                                    ? BorderStyle.solid
                                    : BorderStyle.solid,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _hasPhoto
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('✅',
                                          style: TextStyle(fontSize: 22)),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Photo added',
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: 10,
                                          color: colorAccent,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('📷',
                                          style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 7),
                                      Text(
                                        'Tap to add photo',
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: 11,
                                          color: colorG400,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 4),

                      // Submit
                      GestureDetector(
                        onTap: _submit,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            color: colorDark,
                            borderRadius: BorderRadius.circular(kRadiusBtn),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isEditing
                                ? '✓ Update Product'
                                : '✓ Submit Product',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w900,
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Cancel
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kRadiusBtn),
                            border:
                                Border.all(color: colorG200, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: colorAccent,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _inputStyle = TextStyle(
    fontFamily: 'DM Sans',
    fontWeight: FontWeight.w400,
    fontSize: 11.5,
    color: colorTextDark,
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w400,
          fontSize: 11.5,
          color: colorG400,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: const BorderSide(color: colorG200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: const BorderSide(color: colorAccent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: const BorderSide(color: colorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: const BorderSide(color: colorRed, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
      );
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _FormGroup extends StatelessWidget {
  final String label;
  final Widget child;

  const _FormGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: colorTextMid,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
