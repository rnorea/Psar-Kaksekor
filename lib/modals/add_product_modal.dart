import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/app_text_styles.dart';
import 'package:phsar_kaksekor_app/widgets/common/custom_button.dart';
import 'package:phsar_kaksekor_app/widgets/common/custom_text_field.dart';
import '../widgets/common/bottom_sheet_handle.dart';

class AddProductModal extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const AddProductModal({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  final _nameController    = TextEditingController();
  final _priceController   = TextEditingController();
  final _stockController   = TextEditingController();
  final _descController    = TextEditingController();
  String _category = '';
  String _unit = 'per kg';
  final Set<String> _certs = {'✓ Organic'};

  final List<String> _categories = [
    '🥦 Vegetables',
    '🌾 Grains & Rice',
    '🍎 Fruits',
    '🌿 Herbs',
    '🥚 Eggs & Dairy',
  ];

  final List<String> _units = [
    'per kg',
    'per piece',
    'per bunch',
    'per bag',
  ];

  final List<String> _certOptions = [
    '✓ Organic',
    'No Pesticide',
    'Local Farm',
  ];

  void _submit() {
    if (_nameController.text.isEmpty || _category.isEmpty || _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill required fields ⚠')),
      );
      return;
    }
    widget.onSubmit({
      'name':     _nameController.text,
      'category': _category,
      'price':    double.tryParse(_priceController.text) ?? 0,
      'unit':     _unit,
      'stock':    int.tryParse(_stockController.text) ?? 0,
      'desc':     _descController.text,
      'certs':    _certs.toList(),
    });
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusModal)),
      ),
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.92),
      child: Column(
        children: [
          const BottomSheetHandle(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('＋ Add New Product',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FormGroup(
                    label: 'Product Name *',
                    child: CustomTextField(controller: _nameController, hint: 'e.g. Organic Carrots'),
                  ),
                  _FormGroup(
                    label: 'Category *',
                    child: DropdownButtonFormField<String>(
                      value: _category.isEmpty ? null : _category,
                      hint: const Text('Select category...', style: TextStyle(color: colorG400, fontSize: 11.5)),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kRadiusInput),
                          borderSide: const BorderSide(color: colorG200, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kRadiusInput),
                          borderSide: const BorderSide(color: colorAccent, width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: inputText))).toList(),
                      onChanged: (v) => setState(() => _category = v ?? ''),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _FormGroup(
                          label: 'Price (\$) *',
                          child: CustomTextField(
                            controller: _priceController,
                            hint: '0.00',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: _FormGroup(
                          label: 'Unit *',
                          child: DropdownButtonFormField<String>(
                            value: _unit,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(kRadiusInput),
                                borderSide: const BorderSide(color: colorG200, width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(kRadiusInput),
                                borderSide: const BorderSide(color: colorAccent, width: 1.5),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u, style: inputText))).toList(),
                            onChanged: (v) => setState(() => _unit = v ?? 'per kg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _FormGroup(
                    label: 'Stock Available *',
                    child: CustomTextField(
                      controller: _stockController,
                      hint: 'e.g. 20',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  _FormGroup(
                    label: 'Description',
                    child: CustomTextField(
                      controller: _descController,
                      hint: 'Tell buyers about your product...',
                      maxLines: 3,
                    ),
                  ),
                  _FormGroup(
                    label: 'Certifications',
                    child: Wrap(
                      spacing: 7,
                      children: _certOptions.map((cert) {
                        final isActive = _certs.contains(cert);
                        return GestureDetector(
                          onTap: () => setState(() => isActive ? _certs.remove(cert) : _certs.add(cert)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                            decoration: BoxDecoration(
                              color: isActive ? colorDark : colorG100,
                              borderRadius: BorderRadius.circular(kRadiusBadge),
                            ),
                            child: Text(cert,
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: 10.5,
                                color: isActive ? Colors.white : colorG600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  _FormGroup(
                    label: 'Product Photo',
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(color: colorG200, width: 2),
                          borderRadius: BorderRadius.circular(kRadiusInput),
                        ),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('📷', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 8),
                            Text('Tap to add photo',
                              style: TextStyle(fontFamily: 'DM Sans', fontSize: 11, color: colorG400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomButton(label: '✓ Submit Product', onPressed: _submit),
                  const SizedBox(height: 7),
                  CustomButton(
                    label: 'Cancel',
                    variant: ButtonVariant.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
          Text(label, style: labelText),
          const SizedBox(height: 5),
          child,
        ],
      ),
    );
  }
}

void showAddProduct(BuildContext context, ValueChanged<Map<String, dynamic>> onSubmit) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => AddProductModal(onSubmit: onSubmit),
  );
}