// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetHistoryAdapter extends TypeAdapter<BudgetHistory> {
  @override
  final int typeId = 0;

  @override
  BudgetHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetHistory(
      month: fields[0] as String,
      revenue: fields[1] as double,
      rent: fields[2] as double,
      food: fields[3] as double,
      transport: fields[4] as double,
      other: fields[5] as double,
      finalBudget: fields[6] as double,
      totalExpense: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.month)
      ..writeByte(1)
      ..write(obj.revenue)
      ..writeByte(2)
      ..write(obj.rent)
      ..writeByte(3)
      ..write(obj.food)
      ..writeByte(4)
      ..write(obj.transport)
      ..writeByte(5)
      ..write(obj.other)
      ..writeByte(6)
      ..write(obj.finalBudget)
      ..writeByte(7)
      ..write(obj.totalExpense);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
