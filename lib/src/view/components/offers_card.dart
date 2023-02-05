import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'custom_progress_indicator.dart';

import 'custom_logo.dart';
import '../theme/palette.dart';
import 'shared/get_translated_data.dart';
import 'shared/screens_size.dart';

class OffersCard extends StatelessWidget {
  const OffersCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.prodDiscountPercentage,
    required this.prodPriceWithDiscount,
    required this.imageUrl,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double price;
  final int prodDiscountPercentage;
  final double prodPriceWithDiscount;
  final String? imageUrl;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    ScreenSize().init(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 180,
            height: ScreenSize.screenHeight! * 0.37,
            // padding: const EdgeInsets.only(left: 7, top: 7, right: 7),
            padding: const EdgeInsets.all(7),
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: Palette.offersCardColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  // color: Colors.grey.shade100,
                  offset: Offset.zero,
                  // offset: Offset(2.0, 5.0),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? const SizedBox(
                          height: 99,
                          child: Center(
                            child: CustomLogo(size: 100),
                          ),
                        )
                      : Center(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl!,
                            width: 135,
                            // height: 100,
                            fit: BoxFit.cover,
                            // placeholder: (context, url) {
                            //   return const CustomProgressIndicator();
                            // },
                            errorWidget: (context, url, error) {
                              return const Center(child: CustomLogo(size: 75));
                            },
                          ),
                        ),
                ),

                // Offer data
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.subtitle2!.copyWith(
                          color: Palette.blackColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: textTheme.subtitle2!.copyWith(
                          color: Palette.greyColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          if (prodPriceWithDiscount > 0.0)
                            Expanded(
                              child: Text(
                                '$prodPriceWithDiscount ${getTranslatedData(context, "egyPrice")}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              '$price ${getTranslatedData(context, "egyPrice")}',
                              style: TextStyle(
                                decoration: prodPriceWithDiscount == 0.0
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                                color: prodPriceWithDiscount == 0.0
                                    ? Colors.orange
                                    : Palette.greyColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Offer label
        Positioned(
          top: 10,
          right: 15,
          child: prodDiscountPercentage == 0.0
              ? const SizedBox()
              : _DiscountPercntageView(
                  prodDiscountPercentage: prodDiscountPercentage,
                ),
        ),
      ],
    );
  }
}

class _DiscountPercntageView extends StatelessWidget {
  const _DiscountPercntageView({
    Key? key,
    required this.prodDiscountPercentage,
  }) : super(key: key);

  final int prodDiscountPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        color: Color(0xFFC61B81),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black12,
          )
        ],
      ),
      child: Center(
        child: Text(
          '$prodDiscountPercentage%',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.subtitle2!.copyWith(
                // fontWeight: FontWeight.bold,
                color: const Color(0xFFFFFFFF),
                fontSize: 13,
              ),
        ),
      ),
    );
  }
}
