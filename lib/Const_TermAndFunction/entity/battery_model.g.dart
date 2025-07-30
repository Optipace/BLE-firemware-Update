// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'battery_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatteryModelAdapter extends TypeAdapter<BatteryModel> {
  @override
  final int typeId = 7;

  @override
  BatteryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatteryModel(
      id: fields[0] as String,
      batteryName: fields[1] as String,
      batteryCode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BatteryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.batteryName)
      ..writeByte(2)
      ..write(obj.batteryCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatteryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
