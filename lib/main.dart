import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'firebase_options.dart';
import 'screens/cart_page.dart';
import 'screens/library_page.dart';
import 'screens/store_page.dart';
import 'services/store_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Stripe.publishableKey =
      'pk_test_51ULg24BHjbozvTFWM5P2l0V3pao5YwOtLGkn05SZhYEGjwrholKarQPodJWX0x4IfLM6JIpqbWtmgE3lFYXi2zOc00AwGIEQrb';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ikay Books',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF635BFF)),
        scaffoldBackgroundColor: const Color(0xFFF3F5F9),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(0xFF635BFF).withValues(alpha: 0.12),
          labelTextStyle: WidgetStatePropertyAll(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final _store = StoreController();
  int _index = 0;

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final cartCount = _store.cartBooks.length;
        final pages = [
          StorePage(store: _store),
          CartPage(store: _store),
          LibraryPage(store: _store),
        ];

        return Scaffold(
          body: SafeArea(bottom: false, child: pages[_index]),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: PhosphorIcon(PhosphorIconsRegular.storefront),
                selectedIcon: PhosphorIcon(
                  PhosphorIconsFill.storefront,
                  color: Color(0xFF635BFF),
                ),
                label: 'Store',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const PhosphorIcon(PhosphorIconsRegular.shoppingBag),
                ),
                selectedIcon: Badge(
                  isLabelVisible: cartCount > 0,
                  label: Text('$cartCount'),
                  child: const PhosphorIcon(
                    PhosphorIconsFill.shoppingBag,
                    color: Color(0xFF635BFF),
                  ),
                ),
                label: 'Cart',
              ),
              const NavigationDestination(
                icon: PhosphorIcon(PhosphorIconsRegular.books),
                selectedIcon: PhosphorIcon(
                  PhosphorIconsFill.books,
                  color: Color(0xFF635BFF),
                ),
                label: 'Library',
              ),
            ],
          ),
        );
      },
    );
  }
}
