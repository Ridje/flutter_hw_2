import 'package:flutter/material.dart';
import 'package:flutter_hw_2/weather_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsetsDirectional.only(start: 12.0, end: 12.0),
        child: const MainBody());
  }
}

class MainBody extends StatefulWidget {
  const MainBody({super.key});

  @override
  State<StatefulWidget> createState() {
    return MainBodyState();
  }
}

class MainBodyState extends State<MainBody> {
  late Future<String> cachedCity;

  Future<String> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("city") ?? '';
  }

  @override
  void initState() {
    super.initState();
    cachedCity = getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: cachedCity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeContent(preselectedCity: snapshot.data);
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class HomeContent extends StatelessWidget {
  final TextEditingController _cityController;

  HomeContent({Key? key, required String? preselectedCity})
      : _cityController = TextEditingController(text: preselectedCity),
        super(key: key);

  Future<void> _saveToPreferences(String selectedCity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.setString("city", selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: _cityController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Введите город',
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () {
            final selectedCity = _cityController.text;
            if (selectedCity.isEmpty) {
              const snackBar = SnackBar(
                content: Text('Выберите город пожалуйста!'),
                duration: Durations.long1,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            _saveToPreferences(selectedCity);
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WeatherPage(
                      arguments:
                          WeatherPageArguments(city: selectedCity)),
                ));
          },
          child: const Text('Узнать погоду в городе!'),
        )
      ],
    );
  }
}
