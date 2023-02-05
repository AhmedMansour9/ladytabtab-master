import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:ladytabtab/exports_main.dart';
import 'package:ladytabtab/src/view/screens/home/export.dart';
import 'package:ladytabtab/src/view/utils/internet_connection.dart';

class NoInternetConnection extends StatefulWidget {
  const NoInternetConnection({Key? key}) : super(key: key);

  @override
  NoInternetConnectionState createState() => NoInternetConnectionState();
}

class NoInternetConnectionState extends State<NoInternetConnection> {
  late InternetChecker internetChecker;

  @override
  void initState() {
    super.initState();
    internetChecker = InternetChecker.getInstance();

    internetChecker.checker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(255, 250, 243, 243),
            ),
            child: const Icon(
              Icons.wifi_off_outlined,
              size: 150,
              color: Color.fromARGB(192, 222, 25, 25),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Center(
              child: Text(
                getTranslatedData(context, "no_net_connection"),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          // Reload the page
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 10),
              backgroundColor: const Color.fromARGB(255, 235, 244, 236),
              elevation: 0.0,
            ),
            onPressed: () async {
              bool isConnected =
                  await InternetConnectionChecker().hasConnection;

              if (isConnected) {
                if (!mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MainScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            child: Text(
              getTranslatedData(context, "try_again"),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 61, 172, 67),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
