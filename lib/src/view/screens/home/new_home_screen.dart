import 'package:ladytabtab/src/view/screens/home/export.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: Colors.orange,
            actions: [
              Icon(Icons.home),
              Icon(Icons.search),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(5),
            sliver: // List
                SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return const CategoriesCard();
                },
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesCard extends StatelessWidget {
  const CategoriesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return Center(
      child: SizedBox(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Material(
            color: Colors.blue.withOpacity(0.07),
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
            child: InkWell(
              onTap: () {},
              borderRadius: const BorderRadius.all(
                Radius.circular(3),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "BODY PRODUCTS",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 12, 113, 222),
                      ),
                    ),
                    Text(
                      "منتجات العناية بالجسم",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.blue,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
