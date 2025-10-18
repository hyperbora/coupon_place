// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CouponAdapter extends TypeAdapter<Coupon> {
  @override
  final int typeId = 0;

  @override
  Coupon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coupon(
      id: fields[0] as String,
      name: fields[1] as String,
      code: fields[2] as String?,
      memo: fields[3] as String?,
      validDate: fields[4] as DateTime?,
      imagePath: fields[5] as String?,
      folderId: fields[6] as String,
      enableAlarm: fields[7] as bool,
      isUsed: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Coupon obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.memo)
      ..writeByte(4)
      ..write(obj.validDate)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.folderId)
      ..writeByte(7)
      ..write(obj.enableAlarm)
      ..writeByte(8)
      ..write(obj.isUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CouponAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
