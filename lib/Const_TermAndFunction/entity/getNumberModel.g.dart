// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getNumberModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetNumberModelAdapter extends TypeAdapter<GetNumberModel> {
  @override
  final int typeId = 6;

  @override
  GetNumberModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetNumberModel(
      id: fields[0] as int,
      productId: fields[1] as int,
      discription: fields[2] as String,
      createdOn: fields[3] as String,
      active: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GetNumberModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.discription)
      ..writeByte(3)
      ..write(obj.createdOn)
      ..writeByte(4)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetNumberModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
