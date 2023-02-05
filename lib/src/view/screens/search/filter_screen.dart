import '../../../../exports_main.dart';
import '../../../models/collection/app_collections.dart';
import '../../components/shared/get_translated_data.dart';
import '../../components/shared/screens_size.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);
  static const route = '/filterScreen';
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController priceFrom, priceTo;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedCategory = "Category";

  @override
  void initState() {
    super.initState();

    priceFrom = TextEditingController();
    priceTo = TextEditingController();
  }

  @override
  void dispose() {
    priceFrom.dispose();
    priceTo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    var kBorder = const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black12,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(3),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  // SfRangeSlider(
                  //   onChanged: (val) {},
                  //   values: const SfRangeValues(0.5, 1.0),
                  // ),
                  Form(
                    key: _formKey,
                    child: SizedBox(
                      width: ScreenSize.screenWidth! * 0.90,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'السعر',
                            style: textTheme.subtitle1,
                          ),
                          SizedBox(
                            width: 100,
                            // height: 30,
                            child: TextFormField(
                              controller: priceFrom,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return getTranslatedData(context, "required");
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: "من",
                                border: kBorder,
                                enabledBorder: kBorder,
                                focusedBorder: kBorder,
                                errorBorder: kBorder,
                                focusedErrorBorder: kBorder,
                                disabledBorder: kBorder,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 100,
                            // height: 30,
                            child: TextFormField(
                              controller: priceTo,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return getTranslatedData(context, "required");
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: "إلى",
                                border: kBorder,
                                enabledBorder: kBorder,
                                focusedBorder: kBorder,
                                errorBorder: kBorder,
                                focusedErrorBorder: kBorder,
                                disabledBorder: kBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // End filter by price

                  const SizedBox(height: 20),

                  // Filter by category
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: AppCollections.categories.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return DropdownButtonFormField<String>(
                          // decoration: InputDecoration(),
                          // underline: const SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down),

                          hint: Text(selectedCategory),
                          // selectedCity == null || selectedCity == ''
                          // ?
                          //     Text(
                          //   "Category",
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .subtitle2!
                          //       .copyWith(
                          //         color: Colors.black,
                          //       ),
                          // ),
                          // : Text(
                          //     selectedCity.toString(),
                          //     style: const TextStyle(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          onChanged: (val) {
                            setState(() {
                              selectedCategory = val!;
                            });
                          },
                          onTap: () {},

                          items: snapshot.data?.docs.map((doc) {
                            String categoryName = doc.data()['categoryName'];
                            return DropdownMenuItem<String>(
                              value: categoryName,
                              child: Text(categoryName),
                            );
                          }).toList(),
                          // items: [
                          //   DropdownMenuItem<String>(
                          //     value: 'aaaa',
                          //     child: Row(
                          //       children: [],
                          //     ),
                          //   ),
                          //   DropdownMenuItem<String>(
                          //     value: 'dfffdddd',
                          //     child: Row(
                          //       children: [],
                          //     ),
                          //   ),
                          // ],
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),

            // TODO: APPLY FILTER BUTTON
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: SizedBox(
                width: ScreenSize.screenWidth! * 0.90,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xFFD74364),
                  ),
                  onPressed: () {
                    // TODO: SHOW FILTTERED DATA IN NEW PAGE
                    if (_formKey.currentState!.validate()) {
                      // Navigator.pushNamed(
                      //   context,
                      //   FilterResultScreen.filterResultRoute,
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FilterResultScreen(
                              priceFrom: priceFrom.text,
                              priceTo: priceTo.text,
                              category: selectedCategory,
                            );
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Apply filter".toUpperCase(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
