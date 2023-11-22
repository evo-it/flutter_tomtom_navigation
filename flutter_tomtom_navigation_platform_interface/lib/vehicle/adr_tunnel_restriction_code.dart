import 'package:json_annotation/json_annotation.dart';

part 'adr_tunnel_restriction_code.g.dart';

@JsonEnum(alwaysCreate: true)
enum AdrTunnelRestrictionCode {
  B,
  C,
  D,
  E,
}
