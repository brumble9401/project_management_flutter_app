// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      access_token: fields[0] == null ? '' : fields[0] as String?,
      avatar: fields[6] == null ? '' : fields[6] as String?,
      email: fields[5] == null ? '' : fields[5] as String?,
      first_name: fields[3] == null ? '' : fields[3] as String?,
      id: fields[7] == null ? '' : fields[7] as String?,
      last_name: fields[4] == null ? '' : fields[4] as String?,
      refresh_token: fields[1] == null ? '' : fields[1] as String?,
      username: fields[2] == null ? '' : fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.access_token)
      ..writeByte(1)
      ..write(obj.refresh_token)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.first_name)
      ..writeByte(4)
      ..write(obj.last_name)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.avatar)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
