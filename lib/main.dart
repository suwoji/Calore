import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Mixer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColorMixerScreen(),
    );
  }
}

class ColorMixerScreen extends StatefulWidget {
  @override
  _ColorMixerScreenState createState() => _ColorMixerScreenState();
}

class _ColorMixerScreenState extends State<ColorMixerScreen> {
  Color _color1 = Colors.red;
  Color _color2 = Colors.blue;
  Color _mixedColor = Colors.white;

  Future<void> _pickColor(Color initialColor) async {
    final Color? result = await showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: initialColor,
              onColorChanged: (color) {
                setState(() {
                  if (initialColor == _color1) {
                    _color2 = color;
                  } else {
                    _color1 = color;
                  }
                  _mixedColor = _mixColors(_color1, _color2);
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        if (initialColor == Colors.red) {
          _color1 = result;
        } else {
          _color2 = result;
        }
        _mixedColor = _mixColors(_color1, _color2);
      });
    }
  }

  Color _mixColors(Color color1, Color color2) {
    int red = (color1.red + color2.red) ~/ 2;
    int green = (color1.green + color2.green) ~/ 2;
    int blue = (color1.blue + color2.blue) ~/ 2;
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  Color _getContrastColor(Color color) {
    // Calculate the relative luminance (https://www.w3.org/TR/WCAG20/#relativeluminancedef)
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    // Return black for bright colors, white for dark colors
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  void _resetColors() {
    setState(() {
      _color1 = Colors.red;
      _color2 = Colors.blue;
      _mixedColor = _mixColors(_color1, _color2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Mixer'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _pickColor(_color2),
                  child: Container(
                    width: 720,
                    height: 400,
                    color: _color1,
                  ),
                ),
                GestureDetector(
                  onTap: () => _pickColor(_color1),
                  child: Container(
                    width: 720,
                    height: 400,
                    color: _color2,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: _mixedColor,
              child: Center(
                child: Text(
                  'Mixed Color',
                  style: TextStyle(
                    color: _getContrastColor(_mixedColor),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _resetColors,
              child: Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}