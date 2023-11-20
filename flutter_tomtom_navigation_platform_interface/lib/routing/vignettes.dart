/// Original page: https://developer.tomtom.com/assets/downloads/tomtom-sdks/android/api-reference/0.37.0/routing/model/com.tomtom.sdk.routing.options.calculation/-vignettes/index.html

import 'package:json_annotation/json_annotation.dart';

part 'vignettes.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
abstract class Vignettes {
  const Vignettes({
    this.allowVignettes = const [],
    this.avoidVignettes = const [],
  });

  final List<String> allowVignettes;
  final List<String> avoidVignettes;

  Map<String, dynamic> toJson() => _$VignettesToJson(this);

  factory Vignettes.fromJson(Map<String, dynamic> json) {
    final isAllow = (json["allowVignettes"] as List).isNotEmpty;
    if (isAllow) {
      return Allow(allowVignettes: json["allowVignettes"]);
    }
    return Avoid(avoidVignettes: json["allowVignettes"]);
  }
}

class Allow extends Vignettes {
  const Allow({super.allowVignettes});
}

class Avoid extends Vignettes {
  const Avoid({super.avoidVignettes});
}
