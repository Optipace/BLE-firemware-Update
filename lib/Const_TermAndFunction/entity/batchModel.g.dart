// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batchModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BatchModelAdapter extends TypeAdapter<BatchModel> {
  @override
  final int typeId = 5;

  @override
  BatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatchModel(
      batchId: fields[0] as String,
      batchName: fields[1] as String,
      batchDescription: fields[2] as String,
      firmware: fields[3] as FirmwareModel,
      profile: fields[4] as ProfileModel,
      battery: fields[5] as BatteryModel,
      saved: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BatchModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.batchId)
      ..writeByte(1)
      ..write(obj.batchName)
      ..writeByte(2)
      ..write(obj.batchDescription)
      ..writeByte(3)
      ..write(obj.firmware)
      ..writeByte(4)
      ..write(obj.profile)
      ..writeByte(5)
      ..write(obj.battery)
      ..writeByte(6)
      ..write(obj.saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
