// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firmwareSeriesModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirmwareSeriesModelAdapter extends TypeAdapter<FirmwareSeriesModel> {
  @override
  final int typeId = 2;

  @override
  FirmwareSeriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirmwareSeriesModel(
      id: fields[0] as String,
      name: fields[1] as String,
      firmware: (fields[2] as List).cast<FirmwareModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, FirmwareSeriesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.firmware);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirmwareSeriesModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
