// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firmwareModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirmwareModelAdapter extends TypeAdapter<FirmwareModel> {
  @override
  final int typeId = 1;

  @override
  FirmwareModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirmwareModel(
      id: fields[0] as int,
      version: fields[1] as String,
      releaseNote: fields[2] as String,
      versionName: fields[3] as String,
      deviceTypeId: fields[4] as String,
      file: fields[5] as String,
      saved: fields[6] as bool,
      deviceType: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FirmwareModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.releaseNote)
      ..writeByte(3)
      ..write(obj.versionName)
      ..writeByte(4)
      ..write(obj.deviceTypeId)
      ..writeByte(5)
      ..write(obj.file)
      ..writeByte(6)
      ..write(obj.saved)
      ..writeByte(7)
      ..write(obj.deviceType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirmwareModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
