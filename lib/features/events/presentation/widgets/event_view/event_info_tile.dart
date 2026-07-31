import 'package:femcastells/core/configs/assets/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventInfoTile extends StatelessWidget {
  const EventInfoTile({
    super.key,
    required this.svgSrc,
    required this.title,
    this.isShowBottomTop = true,
    required this.press,
  });

  final String svgSrc, title;
  final bool isShowBottomTop;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          if (isShowBottomTop) const Divider(height: 1),
          ListTile(
            onTap: press,
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              svgSrc,
              height: 24,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primaryFixedDim, 
                BlendMode.srcIn,
              ), // Use colorFilter instead of color
            ),
            title: Text(title),
            trailing: SvgPicture.asset(
              AppIcons.miniArrowRight,
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
