import 'package:humankind/src/enums/FactionsEnum.dart';

import 'dart:convert';

List<Avatar> avatarModelFromJson(String str) =>
    List<Avatar>.from(json.decode(str).map((x) => Avatar.fromJson(x)));

String avatarModelToJson(List<Avatar> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Avatar {
  String illustrator;
  Gender gender;
  Factions faction;
  String name;
  String source;

  Avatar({
    this.illustrator,
    this.gender,
    this.faction,
    this.name,
    this.source,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) => Avatar(
        illustrator: json["illustrator"],
        gender: genderValues.map[json["gender"]],
        faction: factionsValues.map[json["faction"]],
        name: json["name"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "illustrator": illustrator,
        "gender": genderValues.reverse[gender],
        "faction": factionsValues.reverse[faction],
        "name": name,
        "source": source,
      };
}

enum Gender { FEMENINO, MASCULINO }

final genderValues =
    EnumValues({"Femenino": Gender.FEMENINO, "Masculino": Gender.MASCULINO});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
