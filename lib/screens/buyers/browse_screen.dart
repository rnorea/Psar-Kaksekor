import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/product_provider.dart';
import '../../../widgets/buyer/farm_pill.dart';
import '../../../widgets/buyer/product_search_item.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _isSearching = false;

  final List<String> _categories = [
    'All', '🥦 Vegetables', '🌾 Grains', '🍎 Fruits', '🌿 Herbs', '🥚 Eggs',
  ];
  String _selectedCategory = 'All';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorOff,
      body: Column(
        children: [
          _buildHeader(),
          _buildCategoryChips(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: kScreenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kSectionGap),
                  if (!_isSearching) ...[
                    _buildFarmsSection(),
                    const SizedBox(height: kSectionGap),
                    _buildTrendingSection(),
                  ] else ...[
                    _buildSearchResults(),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: colorDark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(kRadiusHeader),
          bottomRight: Radius.circular(kRadiusHeader),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(15, kHeaderPaddingTop, 15, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Browse', style: titleLarge),
          const SizedBox(height: 10),
          TextField(
            controller: _searchCtrl,
            style: inputText.copyWith(color: Colors.white),
            autofocus: false,
            onChanged: (v) {
              setState(() => _isSearching = v.isNotEmpty);
              context.read<ProductProvider>().setQuery(v);
            },
            decoration: InputDecoration(
              hintText: 'Search fresh produce…',
              hintStyle: hintText,
              prefixIcon: const Icon(Icons.search, color: colorG400, size: 16),
              suffixIcon: _isSearching
                  ? GestureDetector(
                      onTap: () {
                        _searchCtrl.clear();
                        context.read<ProductProvider>().setQuery('');
                        setState(() => _isSearching = false);
                      },
                      child: const Icon(Icons.close, color: colorG400, size: 16),
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kRadiusInput),
                borderSide: const BorderSide(color: Colors.white24, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kRadiusInput),
                borderSide: const BorderSide(color: colorLight, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(kScreenPadding, 9, kScreenPadding, 0),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isActive = cat == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              context.read<ProductProvider>().setCategory(cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
              decoration: BoxDecoration(
                color: isActive ? colorDark : colorG100,
                borderRadius: BorderRadius.circular(kRadiusChip),
              ),
              child: Text(
                cat,
                style: chipLabel.copyWith(
                  color: isActive ? Colors.white : colorG600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFarmsSection() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        // farms come from your FarmModel list (inject via provider or pass as mock)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🌾 Top Farms', style: sectionTitle),
            const SizedBox(height: 9),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: provider.farms.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => FarmPill(farm: provider.farms[i]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrendingSection() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final trending = provider.trendingProducts;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🔥 Trending Products', style: sectionTitle),
            const SizedBox(height: 9),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trending.length,
              separatorBuilder: (_, __) => const SizedBox(height: kListGap),
              itemBuilder: (_, i) => ProductSearchItem(
                product: trending[i],
                rank: i + 1,
                showRank: true,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final results = provider.filteredProducts;
        if (results.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  const Text('🔍', style: TextStyle(fontSize: 36)),
                  const SizedBox(height: 10),
                  Text('No results found', style: titleMed),
                  const SizedBox(height: 4),
                  Text('Try a different keyword', style: metaText),
                ],
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${results.length} results', style: metaText),
            const SizedBox(height: 9),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: results.length,
              separatorBuilder: (_, __) => const SizedBox(height: kListGap),
              itemBuilder: (_, i) => ProductSearchItem(
                product: results[i],
                showRank: false,
              ),
            ),
          ],
        );
      },
    );
  }
}
