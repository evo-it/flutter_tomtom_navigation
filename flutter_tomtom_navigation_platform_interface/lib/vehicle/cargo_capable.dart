import 'package:flutter_tomtom_navigation_platform_interface/vehicle/adr_tunnel_restriction_code.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/vehicle_load_type.dart';

mixin CargoCapable {
  abstract final Set<VehicleLoadType> loadType;
  abstract final AdrTunnelRestrictionCode? adrTunnelRestrictionCode;
}
