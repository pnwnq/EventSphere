import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import '../services/ar_service.dart';

class ARViewPage extends StatefulWidget {
  @override
  _ARViewPageState createState() => _ARViewPageState();
}

class _ARViewPageState extends State<ARViewPage> {
  ArCoreController? arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR 视图'),
      ),
      body: ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.waves),
            onPressed: () => ARService.addSeaObject(arCoreController!),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.cloud),
            onPressed: () => ARService.addSkyObject(arCoreController!),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.pets),
            onPressed: () => ARService.addFish(arCoreController!),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            child: Icon(Icons.wb_cloudy),
            onPressed: () => ARService.addCloud(arCoreController!),
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    ARService.addSeaObject(controller);
    ARService.addSkyObject(controller);
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
