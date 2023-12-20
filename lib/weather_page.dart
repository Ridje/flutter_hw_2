import 'package:flutter/material.dart';
import 'package:flutter_hw_2/main.dart';

import 'weather_shot.dart';

class WeatherPage extends StatefulWidget {
  final String city;

  WeatherPage({super.key, required WeatherPageArguments arguments})
      : city = arguments.city;

  @override
  State<StatefulWidget> createState() {
    return _WeatherPageState();
  }
}

class _WeatherPageState extends State<WeatherPage> {
  late Future<WeatherResponse> weatherState;

  @override
  void initState() {
    super.initState();
    weatherState = WeatherLoader(city: widget.city).fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(MyApp.myApplicationTitle),
      ),
      body: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(
              start: 24.0, end: 24.0, top: 24.0),
          child: Column(
            children: [
              Text("Location: ${widget.city}",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 28),
              FutureBuilder(
                  future: weatherState,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return WeatherPageLoadedContent(
                          weatherData: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  })
            ],
          )),
    );
  }
}

class WeatherPageLoadedContent extends StatelessWidget {
  final WeatherResponse weatherData;
  const WeatherPageLoadedContent({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          if (weatherData.weather.isNotEmpty) Expanded(
            child: FadeInImage.assetNetwork(
                placeholder: "assets/images/transparent_image.png",
                image: "http://openweathermap.org/img/wn/${weatherData.weather[0].icon}@2x.png",
              ),
          ),
          Expanded(child: WeatherInfoWidget(weatherResponse: weatherData))
        ],
      )
    ]);
  }
}

class WeatherPageArguments {
  final String city;

  WeatherPageArguments({required this.city});
}

class WeatherInfoWidget extends StatelessWidget {
  final WeatherResponse weatherResponse;

  const WeatherInfoWidget({super.key, required this.weatherResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temperature: ${weatherResponse.main.temp.toString()}°C',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Description: ${weatherResponse.weather.isNotEmpty ? weatherResponse.weather[0].description : ""}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Wind Speed: ${weatherResponse.wind.speed} m/s',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Humidity: ${weatherResponse.main.humidity}%',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        // Add more information below
        const SizedBox(height: 8.0),
        Text(
          'Pressure: ${weatherResponse.main.pressure} hPa',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8.0),
        Text(
          'Visibility: ${weatherResponse.visibility} meters',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        // Add more information as needed
      ],
    );
  }
}
