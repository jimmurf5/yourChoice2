// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageCardAdapter extends TypeAdapter<MessageCard> {
  @override
  final int typeId = 0;

  @override
  MessageCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageCard(
      messageCardId: fields[3] as String?,
      title: fields[0] as String,
      imageUrl: fields[1] as String,
      categoryId: fields[2] as int,
      selectionCount: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MessageCard obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.messageCardId)
      ..writeByte(4)
      ..write(obj.selectionCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
