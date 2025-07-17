import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import 'weather_repository.dart';
import 'package:bloc_app/weather_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => WeatherBloc(WeatherRepository()),
        child: WeatherPage(),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text('Weather App'),backgroundColor:  Colors.grey[300],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                prefixIcon: Icon(Icons.location_city),
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.black38,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.yellow,
                  backgroundColor: Colors.orangeAccent),
                  onPressed: () {
                    final city = _controller.text;
                    if (city.isNotEmpty) {
                      context.read<WeatherBloc>().add(FetchWeather(city));
                    }
                  },
                  child: Text('Get Weather',style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.yellow,
                      backgroundColor: Colors.redAccent),
                  onPressed: () {
                    context.read<WeatherBloc>().add(ResetWeather());
                    _controller.clear();
                  },
                  child: Text('Reset',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
            SizedBox(height: 32),
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return Text('Enter a city to get the weather');
                } else if (state is WeatherLoading) {
                  return CircularProgressIndicator();
                } else if (state is WeatherLoaded) {
                  final weather = state.weather;
                  return Column(
                    children: [
                      Text(
                        weather.cityName,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Image.network(
                        'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${weather.temperature} °C',
                        style: TextStyle(fontSize: 32),
                      ),
                      SizedBox(height: 8),
                      Text(
                        weather.description,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  );
                } else if (state is WeatherError) {
                  return Text(state.message, style: TextStyle(color: Colors.red));
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
} 