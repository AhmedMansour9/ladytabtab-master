import 'package:ladytabtab/src/constants/routes/custom_navigator.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.categoryName,
    this.categoryImageUrl,
    this.color = const Color.fromARGB(130, 33, 149, 243),
  }) : super(key: key);

  final String categoryName;
  final String? categoryImageUrl;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(20));
    return SizedBox(
      // width: 200,
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Material(
          color: const Color.fromARGB(30, 248, 101, 38),
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: () {
              debugPrint("Presseeeed");
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const ViewProductsByCategoryScreen(
              //       categoryName: "",
              //     ),
              //   ),
              //   (route) => false,
              // );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ViewProductsByCategoryScreen(
                    categoryName: categoryName,
                  ),
                ),
              ).then((value) => debugPrint("Nav done!"));
            },
            child: categoryImageUrl == null
                ? const Center(
                    child: CustomLogo(
                      size: 77,
                      color: Palette.primaryColor,
                    ),
                  )
                : CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: categoryImageUrl!,
                    errorWidget: (context, url, error) {
                      return const Center(
                        child: CustomLogo(
                          size: 77,
                          color: Palette.primaryColor,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
    // return Column(
    //   children: [
    //     Material(
    //       color: Colors.yellowAccent.shade700,
    //       child: InkWell(
    //         onTap: () {
    //           Navigator.push(
    //             context,
    //             CustomRouteBuilder(
    //               child: ViewProductsByCategoryScreen(
    //                 categoryName: categoryName,
    //               ),
    //             ),
    //           );
    //         },
    //         child: categoryImageUrl == null
    //             ? const Center(
    //                 child: CustomLogo(
    //                   size: 30,
    //                   color: Colors.cyan,
    //                 ),
    //               )
    //             : CachedNetworkImage(
    //                 fit: BoxFit.cover,
    //                 imageUrl: categoryImageUrl!,
    //                 errorWidget: (context, url, error) {
    //                   return const CustomLogo();
    //                 },
    //               ),
    //       ),
    //     ),
    //     const SizedBox(height: 10),
    //     Text(
    //       categoryName.toUpperCase(),
    //       style: Theme.of(context).textTheme.subtitle1!.copyWith(
    //             letterSpacing: 4.3,
    //           ),
    //     ),
    //   ],
    // );
  }
}
