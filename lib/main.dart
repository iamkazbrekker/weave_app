import 'package:flutter/material.dart';

void main() {
  runApp(const WeaveApp());
}

class WeaveApp extends StatelessWidget {
  const WeaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weave Background App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BackgroundMapPage(),
    );
  }
}

class BackgroundMapPage extends StatelessWidget {
  const BackgroundMapPage({super.key});

  final List<Map<String, dynamic>> regions = const [
    {"box_2d": [75, 532, 921, 1000], "name": "Heatmap Region"},
    {"box_2d": [435, 608, 977, 992], "name": "Conduct Survey Region"},
    {"box_2d": [712, 198, 977, 650], "name": "Tasks Region"},
    {"box_2d": [447, 540, 917, 994], "name": "Hand holding Survey sphere"},
    {"box_2d": [735, 545, 968, 991], "name": "Bottom Right Tasks Hand"},
    {"box_2d": [538, 22, 989, 442], "name": "Impact Region"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.blueGrey[50],
                      child: const Center(
                        child: Text(
                          'Background Image Missing\nPlease place the image at:\nassets/background.png',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Clickable Regions
              ...regions.map((region) {
                final box = region['box_2d'] as List<int>;
                // Coordinates format: [ymin, xmin, ymax, xmax] scaled by 1000
                final top = (box[0] / 1000.0) * height;
                final left = (box[1] / 1000.0) * width;
                final bottom = (box[2] / 1000.0) * height;
                final right = (box[3] / 1000.0) * width;
                
                final w = right - left;
                final h = bottom - top;

                return Positioned(
                  top: top,
                  left: left,
                  width: w,
                  height: h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(title: region['name']),
                        ),
                      );
                    },
                    child: Container(
                      // Uncomment below color to display bounding boxes for debugging
                      // color: Colors.red.withOpacity(0.3), 
                      color: Colors.transparent, 
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String title;

  const DetailsPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Welcome to the $title!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
