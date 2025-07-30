// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 3;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as int,
      name: fields[1] as String,
      releaseNote: fields[2] as String,
      uT: fields[3] as String,
      uV: fields[4] as String,
      lT: fields[5] as String,
      lV: fields[6] as String,
      nV: fields[7] as String,
      uTemp: fields[8] as String,
      lTemp: fields[9] as String,
      saved: fields[12] as bool,
      deviceTypeId: fields[11] as String,
      deviceType: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.releaseNote)
      ..writeByte(3)
      ..write(obj.uT)
      ..writeByte(4)
      ..write(obj.uV)
      ..writeByte(5)
      ..write(obj.lT)
      ..writeByte(6)
      ..write(obj.lV)
      ..writeByte(7)
      ..write(obj.nV)
      ..writeByte(8)
      ..write(obj.uTemp)
      ..writeByte(9)
      ..write(obj.lTemp)
      ..writeByte(10)
      ..write(obj.deviceType)
      ..writeByte(11)
      ..write(obj.deviceTypeId)
      ..writeByte(12)
      ..write(obj.saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
