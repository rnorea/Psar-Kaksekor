import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/farm_model.dart';

class FarmPill extends StatelessWidget {
  final FarmModel farm;
  final VoidCallback onTap;

  const FarmPill({
    super.key,
    required this.farm,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: kFarmAvatarSize,
            height: kFarmAvatarSize,
            decoration: BoxDecoration(
              color: farm.bgColor,
              shape: BoxShape.circle,
              border: Border.all(color: colorG200, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              farm.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 50,
            child: Text(
              farm.name,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                fontSize: 9,
                color: colorG600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            farm.rankLabel,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 8,
              color: farm.rank == 1 ? colorLight : colorG400,
            ),
          ),
        ],
      ),
    );
  }
}