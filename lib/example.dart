import 'package:linagora_design_flutter/colors/linagora_state_layer.dart';
import 'package:linagora_design_flutter/colors/linagora_sys_colors.dart';

/// This is example
void main () {
  final color = LinagoraSysColors.material().secondary;
  final stateLayer = LinagoraStateLayer(color);
  final colorLayer1 = stateLayer.opacityLayer1; //Get color opacityLayer1
  final colorLayer2 = stateLayer.opacityLayer2; //Get color opacityLayer2
  final colorLayer3 = stateLayer.opacityLayer3; //Get color opacityLayer3
}

