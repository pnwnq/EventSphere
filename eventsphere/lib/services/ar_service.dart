import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/services.dart';
import 'dart:math';

class ARService {
  static Future<void> addSeaObject(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load('assets/sea_texture.png');

    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      textureBytes: textureBytes.buffer.asUint8List(),
    );

    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );

    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1),
    );

    controller.addArCoreNode(node);
  }

  static Future<void> addSkyObject(ArCoreController controller) async {
    final ByteData textureBytes = await rootBundle.load('assets/sky_texture.png');

    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 255, 255, 255),
      textureBytes: textureBytes.buffer.asUint8List(),
    );

    final cylinder = ArCoreCylinder(
      materials: [material],
      radius: 0.05,
      height: 0.3,
    );

    final node = ArCoreNode(
      shape: cylinder,
      position: vector.Vector3(0, 0.5, -1),
    );

    controller.addArCoreNode(node);
  }

  static Future<void> addFish(ArCoreController controller) async {
    final material = ArCoreMaterial(color: Color.fromARGB(120, 255, 165, 0));

    final fish = ArCoreSphere(
      materials: [material],
      radius: 0.03,
    );

    final node = ArCoreNode(
      shape: fish,
      position: vector.Vector3(Random().nextDouble() - 0.5, Random().nextDouble() - 0.5, -1),
    );

    controller.addArCoreNode(node);
  }

  static Future<void> addCloud(ArCoreController controller) async {
    final material = ArCoreMaterial(color: Color.fromARGB(200, 255, 255, 255));

    final cloud = ArCoreSpheroid(
      materials: [material],
      radius: vector.Vector2(0.1, 0.06),
    );

    final node = ArCoreNode(
      shape: cloud,
      position: vector.Vector3(Random().nextDouble() - 0.5, 0.5 + Random().nextDouble(), -1),
    );

    controller.addArCoreNode(node);
  }
}
