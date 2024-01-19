import 'package:flutter_tomtom_navigation_platform_interface/vehicle/adr_tunnel_restriction_code.dart';
import 'package:flutter_tomtom_navigation_platform_interface/vehicle/hazmat_class.dart';

/// Trait interface for vehicles that may have restrictions due to load.
mixin CargoCapable {
  abstract final Set<HazmatClass> hazmatClasses;
  abstract final AdrTunnelRestrictionCode? adrTunnelRestrictionCode;
}
