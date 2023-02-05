import 'package:flutter/material.dart';

import 'shared/get_translated_data.dart';

class OrLine extends StatelessWidget {
  const OrLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.39,
          height: 1.3,
          color: Colors.grey.shade200,
        ),
        const SizedBox(width: 7),
        Text(getTranslatedData(context, "or")),
        const SizedBox(width: 7),
        Container(
          width: MediaQuery.of(context).size.width * 0.39,
          height: 1.3,
          color: Colors.grey.shade200,
        ),
      ],
    );
  }
}
