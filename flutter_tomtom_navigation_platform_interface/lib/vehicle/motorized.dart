
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_dimensions.dart';

mixin Motorized {
  abstract final bool isCommercial;
  // abstract final ElectricEngine? electricEngine;
  // abstract final CombustionEngine? combustionEngine;
  abstract final VehicleDimensions? dimensions;
  abstract final String? modelId;
}
