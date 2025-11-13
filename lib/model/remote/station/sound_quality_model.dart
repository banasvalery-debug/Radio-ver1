/// flutter pub run build_runner build --delete-conflicting-outputs
import 'package:json_annotation/json_annotation.dart';

part 'sound_quality_model.g.dart';

@JsonSerializable()
class SoundQualityModel{
  final String bit;
  final String name;

  SoundQualityModel({required this.bit, required this.name});

  factory SoundQualityModel.fromJson(Map<String, dynamic> json) => _$SoundQualityModelFromJson(json);

  Map<String, dynamic> toJson() => _$SoundQualityModelToJson(this);
}