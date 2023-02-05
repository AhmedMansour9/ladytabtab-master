import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/palette.dart';

import '../components/shared/constants.dart';
import '../screens/search/search_screen.dart';
import 'shared/get_translated_data.dart';

class SearchAndFilter extends StatelessWidget {
  const SearchAndFilter({
    Key? key,
    this.color = const Color(0xFFEFEFF0),
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.92,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              // width: 310,
              height: 40,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                readOnly: true,
                onTap: () {
                  Navigator.pushNamed(context, SearchScreen.route);
                },
                decoration: InputDecoration(
                  hintText: getTranslatedData(context, "productSearch"),
                  prefixIcon: SvgPicture.asset(
                    kSearchIcon,
                    fit: BoxFit.scaleDown,
                    color: Palette.greyColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
