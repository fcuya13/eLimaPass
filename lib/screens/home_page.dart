import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  var _isVisible = false;

  void _changeVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: const Image(
                  image: AssetImage('assets/lima_pass.jpg'),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Saldo(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Viajes Recientes",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 35,
          right: 20,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {},
            child: const Row(
              children: [
                Icon(Icons.wallet),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Recargar',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget Saldo() {
    print(Theme.of(context).colorScheme.primary);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.onSurface,
                spreadRadius: 1,
                blurRadius: 0.5)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                "Saldo Actual:",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(
                width: 12,
              ),
              Visibility(
                visible: _isVisible,
                child: const Text(
                  "S/. 10",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              _changeVisibility();
            },
            child: _isVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
          ),
        ],
      ),
    );
  }
}
