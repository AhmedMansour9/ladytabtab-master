import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/custom_progress_indicator.dart';
import '../../theme/palette.dart';
import '../../components/shared/constants.dart';
import '../../components/shared/get_translated_data.dart';
import '../../widgets/cart_counter_quantilty.dart';

class CustomCartCard extends StatefulWidget {
  const CustomCartCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.prodPriceWithDiscount,
    required this.productId,
    required this.cartQty,
    required this.cartItemId,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final double price;
  final double? prodPriceWithDiscount;
  final String productId;
  final String cartItemId;
  final int cartQty;
  final String imageUrl;

  @override
  State<CustomCartCard> createState() => _CustomCartCardState();
}

class _CustomCartCardState extends State<CustomCartCard> {
  late double prodPrice = widget.prodPriceWithDiscount!.toDouble();
  @override
  void initState() {
    super.initState();
    prodPrice = widget.prodPriceWithDiscount == 0.0 ||
            widget.prodPriceWithDiscount == null
        ? widget.price
        : widget.prodPriceWithDiscount!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 90,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xFFEDEDED),
        //     offset: Offset(1, 0),
        //     blurRadius: 10,
        //   ),
        // ],
        color: Palette.cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    // color: Color(0xFFF6F6F7),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(7),
                    ),
                    border: Border.all(
                      width: 1.0,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: widget.imageUrl.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            kLogoIcon,
                            width: 35,
                            height: 35,
                            color: Colors.black12,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            // placeholder: (context, url) {
                            //   return const CustomProgressIndicator();
                            // },
                            errorWidget: (context, url, error) {
                              return Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  kLogoIcon,
                                  width: 35,
                                  height: 35,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                ),

                const SizedBox(width: 10),
                // Item content
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title.toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            // overflow: TextOverflow.ellipsis,
                            ),
                      ),
                      widget.subtitle.isEmpty
                          ? const SizedBox()
                          : const SizedBox(height: 5),
                      widget.subtitle.isEmpty
                          ? const SizedBox()
                          : Text(
                              widget.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            ),
                      const SizedBox(height: 3),
                      Text(
                        '$prodPrice ${getTranslatedData(context, "egyPrice")}',
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          CartCounterQuantity(
            productId: widget.productId,
            cartQty: widget.cartQty,
            cartItemId: widget.cartItemId,
            isProductDetailsModal: false,
          ),
        ],
      ),
    );
  }
}
