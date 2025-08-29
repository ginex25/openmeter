// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Meter extends Table with TableInfo<Meter, MeterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Meter(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> typ = GeneratedColumn<String>(
      'typ', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, typ, note, number, unit, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MeterData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      typ: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}typ'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  Meter createAlias(String alias) {
    return Meter(attachedDatabase, alias);
  }
}

class MeterData extends DataClass implements Insertable<MeterData> {
  final int id;
  final String typ;
  final String note;
  final String number;
  final String unit;
  final bool isArchived;
  const MeterData(
      {required this.id,
      required this.typ,
      required this.note,
      required this.number,
      required this.unit,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['typ'] = Variable<String>(typ);
    map['note'] = Variable<String>(note);
    map['number'] = Variable<String>(number);
    map['unit'] = Variable<String>(unit);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  MeterCompanion toCompanion(bool nullToAbsent) {
    return MeterCompanion(
      id: Value(id),
      typ: Value(typ),
      note: Value(note),
      number: Value(number),
      unit: Value(unit),
      isArchived: Value(isArchived),
    );
  }

  factory MeterData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterData(
      id: serializer.fromJson<int>(json['id']),
      typ: serializer.fromJson<String>(json['typ']),
      note: serializer.fromJson<String>(json['note']),
      number: serializer.fromJson<String>(json['number']),
      unit: serializer.fromJson<String>(json['unit']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'typ': serializer.toJson<String>(typ),
      'note': serializer.toJson<String>(note),
      'number': serializer.toJson<String>(number),
      'unit': serializer.toJson<String>(unit),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  MeterData copyWith(
          {int? id,
          String? typ,
          String? note,
          String? number,
          String? unit,
          bool? isArchived}) =>
      MeterData(
        id: id ?? this.id,
        typ: typ ?? this.typ,
        note: note ?? this.note,
        number: number ?? this.number,
        unit: unit ?? this.unit,
        isArchived: isArchived ?? this.isArchived,
      );
  MeterData copyWithCompanion(MeterCompanion data) {
    return MeterData(
      id: data.id.present ? data.id.value : this.id,
      typ: data.typ.present ? data.typ.value : this.typ,
      note: data.note.present ? data.note.value : this.note,
      number: data.number.present ? data.number.value : this.number,
      unit: data.unit.present ? data.unit.value : this.unit,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterData(')
          ..write('id: $id, ')
          ..write('typ: $typ, ')
          ..write('note: $note, ')
          ..write('number: $number, ')
          ..write('unit: $unit, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, typ, note, number, unit, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeterData &&
          other.id == this.id &&
          other.typ == this.typ &&
          other.note == this.note &&
          other.number == this.number &&
          other.unit == this.unit &&
          other.isArchived == this.isArchived);
}

class MeterCompanion extends UpdateCompanion<MeterData> {
  final Value<int> id;
  final Value<String> typ;
  final Value<String> note;
  final Value<String> number;
  final Value<String> unit;
  final Value<bool> isArchived;
  const MeterCompanion({
    this.id = const Value.absent(),
    this.typ = const Value.absent(),
    this.note = const Value.absent(),
    this.number = const Value.absent(),
    this.unit = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  MeterCompanion.insert({
    this.id = const Value.absent(),
    required String typ,
    required String note,
    required String number,
    required String unit,
    this.isArchived = const Value.absent(),
  })  : typ = Value(typ),
        note = Value(note),
        number = Value(number),
        unit = Value(unit);
  static Insertable<MeterData> custom({
    Expression<int>? id,
    Expression<String>? typ,
    Expression<String>? note,
    Expression<String>? number,
    Expression<String>? unit,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (typ != null) 'typ': typ,
      if (note != null) 'note': note,
      if (number != null) 'number': number,
      if (unit != null) 'unit': unit,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  MeterCompanion copyWith(
      {Value<int>? id,
      Value<String>? typ,
      Value<String>? note,
      Value<String>? number,
      Value<String>? unit,
      Value<bool>? isArchived}) {
    return MeterCompanion(
      id: id ?? this.id,
      typ: typ ?? this.typ,
      note: note ?? this.note,
      number: number ?? this.number,
      unit: unit ?? this.unit,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (typ.present) {
      map['typ'] = Variable<String>(typ.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterCompanion(')
          ..write('id: $id, ')
          ..write('typ: $typ, ')
          ..write('note: $note, ')
          ..write('number: $number, ')
          ..write('unit: $unit, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class Entries extends Table with TableInfo<Entries, EntriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Entries(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> meter = GeneratedColumn<int>(
      'meter', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> usage = GeneratedColumn<int>(
      'usage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
      'days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<bool> isReset = GeneratedColumn<bool>(
      'is_reset', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_reset" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<bool> transmittedToProvider =
      GeneratedColumn<bool>('transmitted_to_provider', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("transmitted_to_provider" IN (0, 1))'),
          defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        meter,
        count,
        usage,
        date,
        days,
        note,
        isReset,
        transmittedToProvider,
        imagePath
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntriesData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      meter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meter'])!,
      count: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}count'])!,
      usage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isReset: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_reset'])!,
      transmittedToProvider: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}transmitted_to_provider'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
    );
  }

  @override
  Entries createAlias(String alias) {
    return Entries(attachedDatabase, alias);
  }
}

class EntriesData extends DataClass implements Insertable<EntriesData> {
  final int id;
  final int meter;
  final int count;
  final int usage;
  final DateTime date;
  final int days;
  final String? note;
  final bool isReset;
  final bool transmittedToProvider;
  final String? imagePath;
  const EntriesData(
      {required this.id,
      required this.meter,
      required this.count,
      required this.usage,
      required this.date,
      required this.days,
      this.note,
      required this.isReset,
      required this.transmittedToProvider,
      this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meter'] = Variable<int>(meter);
    map['count'] = Variable<int>(count);
    map['usage'] = Variable<int>(usage);
    map['date'] = Variable<DateTime>(date);
    map['days'] = Variable<int>(days);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_reset'] = Variable<bool>(isReset);
    map['transmitted_to_provider'] = Variable<bool>(transmittedToProvider);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      meter: Value(meter),
      count: Value(count),
      usage: Value(usage),
      date: Value(date),
      days: Value(days),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isReset: Value(isReset),
      transmittedToProvider: Value(transmittedToProvider),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
    );
  }

  factory EntriesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntriesData(
      id: serializer.fromJson<int>(json['id']),
      meter: serializer.fromJson<int>(json['meter']),
      count: serializer.fromJson<int>(json['count']),
      usage: serializer.fromJson<int>(json['usage']),
      date: serializer.fromJson<DateTime>(json['date']),
      days: serializer.fromJson<int>(json['days']),
      note: serializer.fromJson<String?>(json['note']),
      isReset: serializer.fromJson<bool>(json['isReset']),
      transmittedToProvider:
          serializer.fromJson<bool>(json['transmittedToProvider']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meter': serializer.toJson<int>(meter),
      'count': serializer.toJson<int>(count),
      'usage': serializer.toJson<int>(usage),
      'date': serializer.toJson<DateTime>(date),
      'days': serializer.toJson<int>(days),
      'note': serializer.toJson<String?>(note),
      'isReset': serializer.toJson<bool>(isReset),
      'transmittedToProvider': serializer.toJson<bool>(transmittedToProvider),
      'imagePath': serializer.toJson<String?>(imagePath),
    };
  }

  EntriesData copyWith(
          {int? id,
          int? meter,
          int? count,
          int? usage,
          DateTime? date,
          int? days,
          Value<String?> note = const Value.absent(),
          bool? isReset,
          bool? transmittedToProvider,
          Value<String?> imagePath = const Value.absent()}) =>
      EntriesData(
        id: id ?? this.id,
        meter: meter ?? this.meter,
        count: count ?? this.count,
        usage: usage ?? this.usage,
        date: date ?? this.date,
        days: days ?? this.days,
        note: note.present ? note.value : this.note,
        isReset: isReset ?? this.isReset,
        transmittedToProvider:
            transmittedToProvider ?? this.transmittedToProvider,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
      );
  EntriesData copyWithCompanion(EntriesCompanion data) {
    return EntriesData(
      id: data.id.present ? data.id.value : this.id,
      meter: data.meter.present ? data.meter.value : this.meter,
      count: data.count.present ? data.count.value : this.count,
      usage: data.usage.present ? data.usage.value : this.usage,
      date: data.date.present ? data.date.value : this.date,
      days: data.days.present ? data.days.value : this.days,
      note: data.note.present ? data.note.value : this.note,
      isReset: data.isReset.present ? data.isReset.value : this.isReset,
      transmittedToProvider: data.transmittedToProvider.present
          ? data.transmittedToProvider.value
          : this.transmittedToProvider,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntriesData(')
          ..write('id: $id, ')
          ..write('meter: $meter, ')
          ..write('count: $count, ')
          ..write('usage: $usage, ')
          ..write('date: $date, ')
          ..write('days: $days, ')
          ..write('note: $note, ')
          ..write('isReset: $isReset, ')
          ..write('transmittedToProvider: $transmittedToProvider, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, meter, count, usage, date, days, note,
      isReset, transmittedToProvider, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntriesData &&
          other.id == this.id &&
          other.meter == this.meter &&
          other.count == this.count &&
          other.usage == this.usage &&
          other.date == this.date &&
          other.days == this.days &&
          other.note == this.note &&
          other.isReset == this.isReset &&
          other.transmittedToProvider == this.transmittedToProvider &&
          other.imagePath == this.imagePath);
}

class EntriesCompanion extends UpdateCompanion<EntriesData> {
  final Value<int> id;
  final Value<int> meter;
  final Value<int> count;
  final Value<int> usage;
  final Value<DateTime> date;
  final Value<int> days;
  final Value<String?> note;
  final Value<bool> isReset;
  final Value<bool> transmittedToProvider;
  final Value<String?> imagePath;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.meter = const Value.absent(),
    this.count = const Value.absent(),
    this.usage = const Value.absent(),
    this.date = const Value.absent(),
    this.days = const Value.absent(),
    this.note = const Value.absent(),
    this.isReset = const Value.absent(),
    this.transmittedToProvider = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  EntriesCompanion.insert({
    this.id = const Value.absent(),
    required int meter,
    required int count,
    required int usage,
    required DateTime date,
    required int days,
    this.note = const Value.absent(),
    this.isReset = const Value.absent(),
    this.transmittedToProvider = const Value.absent(),
    this.imagePath = const Value.absent(),
  })  : meter = Value(meter),
        count = Value(count),
        usage = Value(usage),
        date = Value(date),
        days = Value(days);
  static Insertable<EntriesData> custom({
    Expression<int>? id,
    Expression<int>? meter,
    Expression<int>? count,
    Expression<int>? usage,
    Expression<DateTime>? date,
    Expression<int>? days,
    Expression<String>? note,
    Expression<bool>? isReset,
    Expression<bool>? transmittedToProvider,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meter != null) 'meter': meter,
      if (count != null) 'count': count,
      if (usage != null) 'usage': usage,
      if (date != null) 'date': date,
      if (days != null) 'days': days,
      if (note != null) 'note': note,
      if (isReset != null) 'is_reset': isReset,
      if (transmittedToProvider != null)
        'transmitted_to_provider': transmittedToProvider,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  EntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? meter,
      Value<int>? count,
      Value<int>? usage,
      Value<DateTime>? date,
      Value<int>? days,
      Value<String?>? note,
      Value<bool>? isReset,
      Value<bool>? transmittedToProvider,
      Value<String?>? imagePath}) {
    return EntriesCompanion(
      id: id ?? this.id,
      meter: meter ?? this.meter,
      count: count ?? this.count,
      usage: usage ?? this.usage,
      date: date ?? this.date,
      days: days ?? this.days,
      note: note ?? this.note,
      isReset: isReset ?? this.isReset,
      transmittedToProvider:
          transmittedToProvider ?? this.transmittedToProvider,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (meter.present) {
      map['meter'] = Variable<int>(meter.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (usage.present) {
      map['usage'] = Variable<int>(usage.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (days.present) {
      map['days'] = Variable<int>(days.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isReset.present) {
      map['is_reset'] = Variable<bool>(isReset.value);
    }
    if (transmittedToProvider.present) {
      map['transmitted_to_provider'] =
          Variable<bool>(transmittedToProvider.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('meter: $meter, ')
          ..write('count: $count, ')
          ..write('usage: $usage, ')
          ..write('date: $date, ')
          ..write('days: $days, ')
          ..write('note: $note, ')
          ..write('isReset: $isReset, ')
          ..write('transmittedToProvider: $transmittedToProvider, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }
}

class Room extends Table with TableInfo<Room, RoomData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Room(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> typ = GeneratedColumn<String>(
      'typ', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, uuid, name, typ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'room';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoomData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoomData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      typ: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}typ'])!,
    );
  }

  @override
  Room createAlias(String alias) {
    return Room(attachedDatabase, alias);
  }
}

class RoomData extends DataClass implements Insertable<RoomData> {
  final int id;
  final String uuid;
  final String name;
  final String typ;
  const RoomData(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.typ});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['typ'] = Variable<String>(typ);
    return map;
  }

  RoomCompanion toCompanion(bool nullToAbsent) {
    return RoomCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      typ: Value(typ),
    );
  }

  factory RoomData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoomData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      typ: serializer.fromJson<String>(json['typ']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'typ': serializer.toJson<String>(typ),
    };
  }

  RoomData copyWith({int? id, String? uuid, String? name, String? typ}) =>
      RoomData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        typ: typ ?? this.typ,
      );
  RoomData copyWithCompanion(RoomCompanion data) {
    return RoomData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      typ: data.typ.present ? data.typ.value : this.typ,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoomData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('typ: $typ')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name, typ);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoomData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.typ == this.typ);
}

class RoomCompanion extends UpdateCompanion<RoomData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<String> typ;
  const RoomCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.typ = const Value.absent(),
  });
  RoomCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String name,
    required String typ,
  })  : uuid = Value(uuid),
        name = Value(name),
        typ = Value(typ);
  static Insertable<RoomData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? typ,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (typ != null) 'typ': typ,
    });
  }

  RoomCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<String>? typ}) {
    return RoomCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      typ: typ ?? this.typ,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (typ.present) {
      map['typ'] = Variable<String>(typ.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('typ: $typ')
          ..write(')'))
        .toString();
  }
}

class MeterInRoom extends Table with TableInfo<MeterInRoom, MeterInRoomData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MeterInRoom(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
      'room_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [meterId, roomId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter_in_room';
  @override
  Set<GeneratedColumn> get $primaryKey => {meterId, roomId};
  @override
  MeterInRoomData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterInRoomData(
      meterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meter_id'])!,
      roomId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_id'])!,
    );
  }

  @override
  MeterInRoom createAlias(String alias) {
    return MeterInRoom(attachedDatabase, alias);
  }
}

class MeterInRoomData extends DataClass implements Insertable<MeterInRoomData> {
  final int meterId;
  final String roomId;
  const MeterInRoomData({required this.meterId, required this.roomId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meter_id'] = Variable<int>(meterId);
    map['room_id'] = Variable<String>(roomId);
    return map;
  }

  MeterInRoomCompanion toCompanion(bool nullToAbsent) {
    return MeterInRoomCompanion(
      meterId: Value(meterId),
      roomId: Value(roomId),
    );
  }

  factory MeterInRoomData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterInRoomData(
      meterId: serializer.fromJson<int>(json['meterId']),
      roomId: serializer.fromJson<String>(json['roomId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'meterId': serializer.toJson<int>(meterId),
      'roomId': serializer.toJson<String>(roomId),
    };
  }

  MeterInRoomData copyWith({int? meterId, String? roomId}) => MeterInRoomData(
        meterId: meterId ?? this.meterId,
        roomId: roomId ?? this.roomId,
      );
  MeterInRoomData copyWithCompanion(MeterInRoomCompanion data) {
    return MeterInRoomData(
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterInRoomData(')
          ..write('meterId: $meterId, ')
          ..write('roomId: $roomId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(meterId, roomId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeterInRoomData &&
          other.meterId == this.meterId &&
          other.roomId == this.roomId);
}

class MeterInRoomCompanion extends UpdateCompanion<MeterInRoomData> {
  final Value<int> meterId;
  final Value<String> roomId;
  final Value<int> rowid;
  const MeterInRoomCompanion({
    this.meterId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeterInRoomCompanion.insert({
    required int meterId,
    required String roomId,
    this.rowid = const Value.absent(),
  })  : meterId = Value(meterId),
        roomId = Value(roomId);
  static Insertable<MeterInRoomData> custom({
    Expression<int>? meterId,
    Expression<String>? roomId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (meterId != null) 'meter_id': meterId,
      if (roomId != null) 'room_id': roomId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeterInRoomCompanion copyWith(
      {Value<int>? meterId, Value<String>? roomId, Value<int>? rowid}) {
    return MeterInRoomCompanion(
      meterId: meterId ?? this.meterId,
      roomId: roomId ?? this.roomId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (meterId.present) {
      map['meter_id'] = Variable<int>(meterId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterInRoomCompanion(')
          ..write('meterId: $meterId, ')
          ..write('roomId: $roomId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Provider extends Table with TableInfo<Provider, ProviderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Provider(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> contractNumber = GeneratedColumn<String>(
      'contract_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> notice = GeneratedColumn<int>(
      'notice', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
      'valid_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
      'valid_until', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<int> renewal = GeneratedColumn<int>(
      'renewal', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<bool> canceled = GeneratedColumn<bool>(
      'canceled', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("canceled" IN (0, 1))'));
  late final GeneratedColumn<DateTime> canceledDate = GeneratedColumn<DateTime>(
      'canceled_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        contractNumber,
        notice,
        validFrom,
        validUntil,
        renewal,
        canceled,
        canceledDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'provider';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contractNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}contract_number'])!,
      notice: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}notice']),
      validFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_from'])!,
      validUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}valid_until'])!,
      renewal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}renewal']),
      canceled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}canceled']),
      canceledDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}canceled_date']),
    );
  }

  @override
  Provider createAlias(String alias) {
    return Provider(attachedDatabase, alias);
  }
}

class ProviderData extends DataClass implements Insertable<ProviderData> {
  final int id;
  final String name;
  final String contractNumber;
  final int? notice;
  final DateTime validFrom;
  final DateTime validUntil;
  final int? renewal;
  final bool? canceled;
  final DateTime? canceledDate;
  const ProviderData(
      {required this.id,
      required this.name,
      required this.contractNumber,
      this.notice,
      required this.validFrom,
      required this.validUntil,
      this.renewal,
      this.canceled,
      this.canceledDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['contract_number'] = Variable<String>(contractNumber);
    if (!nullToAbsent || notice != null) {
      map['notice'] = Variable<int>(notice);
    }
    map['valid_from'] = Variable<DateTime>(validFrom);
    map['valid_until'] = Variable<DateTime>(validUntil);
    if (!nullToAbsent || renewal != null) {
      map['renewal'] = Variable<int>(renewal);
    }
    if (!nullToAbsent || canceled != null) {
      map['canceled'] = Variable<bool>(canceled);
    }
    if (!nullToAbsent || canceledDate != null) {
      map['canceled_date'] = Variable<DateTime>(canceledDate);
    }
    return map;
  }

  ProviderCompanion toCompanion(bool nullToAbsent) {
    return ProviderCompanion(
      id: Value(id),
      name: Value(name),
      contractNumber: Value(contractNumber),
      notice:
          notice == null && nullToAbsent ? const Value.absent() : Value(notice),
      validFrom: Value(validFrom),
      validUntil: Value(validUntil),
      renewal: renewal == null && nullToAbsent
          ? const Value.absent()
          : Value(renewal),
      canceled: canceled == null && nullToAbsent
          ? const Value.absent()
          : Value(canceled),
      canceledDate: canceledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(canceledDate),
    );
  }

  factory ProviderData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contractNumber: serializer.fromJson<String>(json['contractNumber']),
      notice: serializer.fromJson<int?>(json['notice']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      validUntil: serializer.fromJson<DateTime>(json['validUntil']),
      renewal: serializer.fromJson<int?>(json['renewal']),
      canceled: serializer.fromJson<bool?>(json['canceled']),
      canceledDate: serializer.fromJson<DateTime?>(json['canceledDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'contractNumber': serializer.toJson<String>(contractNumber),
      'notice': serializer.toJson<int?>(notice),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'validUntil': serializer.toJson<DateTime>(validUntil),
      'renewal': serializer.toJson<int?>(renewal),
      'canceled': serializer.toJson<bool?>(canceled),
      'canceledDate': serializer.toJson<DateTime?>(canceledDate),
    };
  }

  ProviderData copyWith(
          {int? id,
          String? name,
          String? contractNumber,
          Value<int?> notice = const Value.absent(),
          DateTime? validFrom,
          DateTime? validUntil,
          Value<int?> renewal = const Value.absent(),
          Value<bool?> canceled = const Value.absent(),
          Value<DateTime?> canceledDate = const Value.absent()}) =>
      ProviderData(
        id: id ?? this.id,
        name: name ?? this.name,
        contractNumber: contractNumber ?? this.contractNumber,
        notice: notice.present ? notice.value : this.notice,
        validFrom: validFrom ?? this.validFrom,
        validUntil: validUntil ?? this.validUntil,
        renewal: renewal.present ? renewal.value : this.renewal,
        canceled: canceled.present ? canceled.value : this.canceled,
        canceledDate:
            canceledDate.present ? canceledDate.value : this.canceledDate,
      );
  ProviderData copyWithCompanion(ProviderCompanion data) {
    return ProviderData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contractNumber: data.contractNumber.present
          ? data.contractNumber.value
          : this.contractNumber,
      notice: data.notice.present ? data.notice.value : this.notice,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil:
          data.validUntil.present ? data.validUntil.value : this.validUntil,
      renewal: data.renewal.present ? data.renewal.value : this.renewal,
      canceled: data.canceled.present ? data.canceled.value : this.canceled,
      canceledDate: data.canceledDate.present
          ? data.canceledDate.value
          : this.canceledDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contractNumber: $contractNumber, ')
          ..write('notice: $notice, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('renewal: $renewal, ')
          ..write('canceled: $canceled, ')
          ..write('canceledDate: $canceledDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, contractNumber, notice, validFrom,
      validUntil, renewal, canceled, canceledDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderData &&
          other.id == this.id &&
          other.name == this.name &&
          other.contractNumber == this.contractNumber &&
          other.notice == this.notice &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.renewal == this.renewal &&
          other.canceled == this.canceled &&
          other.canceledDate == this.canceledDate);
}

class ProviderCompanion extends UpdateCompanion<ProviderData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> contractNumber;
  final Value<int?> notice;
  final Value<DateTime> validFrom;
  final Value<DateTime> validUntil;
  final Value<int?> renewal;
  final Value<bool?> canceled;
  final Value<DateTime?> canceledDate;
  const ProviderCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contractNumber = const Value.absent(),
    this.notice = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.renewal = const Value.absent(),
    this.canceled = const Value.absent(),
    this.canceledDate = const Value.absent(),
  });
  ProviderCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String contractNumber,
    this.notice = const Value.absent(),
    required DateTime validFrom,
    required DateTime validUntil,
    this.renewal = const Value.absent(),
    this.canceled = const Value.absent(),
    this.canceledDate = const Value.absent(),
  })  : name = Value(name),
        contractNumber = Value(contractNumber),
        validFrom = Value(validFrom),
        validUntil = Value(validUntil);
  static Insertable<ProviderData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? contractNumber,
    Expression<int>? notice,
    Expression<DateTime>? validFrom,
    Expression<DateTime>? validUntil,
    Expression<int>? renewal,
    Expression<bool>? canceled,
    Expression<DateTime>? canceledDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contractNumber != null) 'contract_number': contractNumber,
      if (notice != null) 'notice': notice,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (renewal != null) 'renewal': renewal,
      if (canceled != null) 'canceled': canceled,
      if (canceledDate != null) 'canceled_date': canceledDate,
    });
  }

  ProviderCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? contractNumber,
      Value<int?>? notice,
      Value<DateTime>? validFrom,
      Value<DateTime>? validUntil,
      Value<int?>? renewal,
      Value<bool?>? canceled,
      Value<DateTime?>? canceledDate}) {
    return ProviderCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contractNumber: contractNumber ?? this.contractNumber,
      notice: notice ?? this.notice,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      renewal: renewal ?? this.renewal,
      canceled: canceled ?? this.canceled,
      canceledDate: canceledDate ?? this.canceledDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contractNumber.present) {
      map['contract_number'] = Variable<String>(contractNumber.value);
    }
    if (notice.present) {
      map['notice'] = Variable<int>(notice.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<DateTime>(validUntil.value);
    }
    if (renewal.present) {
      map['renewal'] = Variable<int>(renewal.value);
    }
    if (canceled.present) {
      map['canceled'] = Variable<bool>(canceled.value);
    }
    if (canceledDate.present) {
      map['canceled_date'] = Variable<DateTime>(canceledDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProviderCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contractNumber: $contractNumber, ')
          ..write('notice: $notice, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('renewal: $renewal, ')
          ..write('canceled: $canceled, ')
          ..write('canceledDate: $canceledDate')
          ..write(')'))
        .toString();
  }
}

class Contract extends Table with TableInfo<Contract, ContractData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Contract(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> meterTyp = GeneratedColumn<String>(
      'meter_typ', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> provider = GeneratedColumn<int>(
      'provider', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES provider (id) ON DELETE SET NULL'));
  late final GeneratedColumn<double> basicPrice = GeneratedColumn<double>(
      'basic_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<double> energyPrice = GeneratedColumn<double>(
      'energy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
      'bonus', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        meterTyp,
        provider,
        basicPrice,
        energyPrice,
        discount,
        bonus,
        note,
        unit,
        isArchived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contract';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContractData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContractData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      meterTyp: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meter_typ'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}provider']),
      basicPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}basic_price'])!,
      energyPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}energy_price'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      bonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  Contract createAlias(String alias) {
    return Contract(attachedDatabase, alias);
  }
}

class ContractData extends DataClass implements Insertable<ContractData> {
  final int id;
  final String meterTyp;
  final int? provider;
  final double basicPrice;
  final double energyPrice;
  final double discount;
  final int? bonus;
  final String note;
  final String unit;
  final bool isArchived;
  const ContractData(
      {required this.id,
      required this.meterTyp,
      this.provider,
      required this.basicPrice,
      required this.energyPrice,
      required this.discount,
      this.bonus,
      required this.note,
      required this.unit,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meter_typ'] = Variable<String>(meterTyp);
    if (!nullToAbsent || provider != null) {
      map['provider'] = Variable<int>(provider);
    }
    map['basic_price'] = Variable<double>(basicPrice);
    map['energy_price'] = Variable<double>(energyPrice);
    map['discount'] = Variable<double>(discount);
    if (!nullToAbsent || bonus != null) {
      map['bonus'] = Variable<int>(bonus);
    }
    map['note'] = Variable<String>(note);
    map['unit'] = Variable<String>(unit);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  ContractCompanion toCompanion(bool nullToAbsent) {
    return ContractCompanion(
      id: Value(id),
      meterTyp: Value(meterTyp),
      provider: provider == null && nullToAbsent
          ? const Value.absent()
          : Value(provider),
      basicPrice: Value(basicPrice),
      energyPrice: Value(energyPrice),
      discount: Value(discount),
      bonus:
          bonus == null && nullToAbsent ? const Value.absent() : Value(bonus),
      note: Value(note),
      unit: Value(unit),
      isArchived: Value(isArchived),
    );
  }

  factory ContractData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContractData(
      id: serializer.fromJson<int>(json['id']),
      meterTyp: serializer.fromJson<String>(json['meterTyp']),
      provider: serializer.fromJson<int?>(json['provider']),
      basicPrice: serializer.fromJson<double>(json['basicPrice']),
      energyPrice: serializer.fromJson<double>(json['energyPrice']),
      discount: serializer.fromJson<double>(json['discount']),
      bonus: serializer.fromJson<int?>(json['bonus']),
      note: serializer.fromJson<String>(json['note']),
      unit: serializer.fromJson<String>(json['unit']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'meterTyp': serializer.toJson<String>(meterTyp),
      'provider': serializer.toJson<int?>(provider),
      'basicPrice': serializer.toJson<double>(basicPrice),
      'energyPrice': serializer.toJson<double>(energyPrice),
      'discount': serializer.toJson<double>(discount),
      'bonus': serializer.toJson<int?>(bonus),
      'note': serializer.toJson<String>(note),
      'unit': serializer.toJson<String>(unit),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  ContractData copyWith(
          {int? id,
          String? meterTyp,
          Value<int?> provider = const Value.absent(),
          double? basicPrice,
          double? energyPrice,
          double? discount,
          Value<int?> bonus = const Value.absent(),
          String? note,
          String? unit,
          bool? isArchived}) =>
      ContractData(
        id: id ?? this.id,
        meterTyp: meterTyp ?? this.meterTyp,
        provider: provider.present ? provider.value : this.provider,
        basicPrice: basicPrice ?? this.basicPrice,
        energyPrice: energyPrice ?? this.energyPrice,
        discount: discount ?? this.discount,
        bonus: bonus.present ? bonus.value : this.bonus,
        note: note ?? this.note,
        unit: unit ?? this.unit,
        isArchived: isArchived ?? this.isArchived,
      );
  ContractData copyWithCompanion(ContractCompanion data) {
    return ContractData(
      id: data.id.present ? data.id.value : this.id,
      meterTyp: data.meterTyp.present ? data.meterTyp.value : this.meterTyp,
      provider: data.provider.present ? data.provider.value : this.provider,
      basicPrice:
          data.basicPrice.present ? data.basicPrice.value : this.basicPrice,
      energyPrice:
          data.energyPrice.present ? data.energyPrice.value : this.energyPrice,
      discount: data.discount.present ? data.discount.value : this.discount,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      note: data.note.present ? data.note.value : this.note,
      unit: data.unit.present ? data.unit.value : this.unit,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContractData(')
          ..write('id: $id, ')
          ..write('meterTyp: $meterTyp, ')
          ..write('provider: $provider, ')
          ..write('basicPrice: $basicPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('discount: $discount, ')
          ..write('bonus: $bonus, ')
          ..write('note: $note, ')
          ..write('unit: $unit, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, meterTyp, provider, basicPrice,
      energyPrice, discount, bonus, note, unit, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContractData &&
          other.id == this.id &&
          other.meterTyp == this.meterTyp &&
          other.provider == this.provider &&
          other.basicPrice == this.basicPrice &&
          other.energyPrice == this.energyPrice &&
          other.discount == this.discount &&
          other.bonus == this.bonus &&
          other.note == this.note &&
          other.unit == this.unit &&
          other.isArchived == this.isArchived);
}

class ContractCompanion extends UpdateCompanion<ContractData> {
  final Value<int> id;
  final Value<String> meterTyp;
  final Value<int?> provider;
  final Value<double> basicPrice;
  final Value<double> energyPrice;
  final Value<double> discount;
  final Value<int?> bonus;
  final Value<String> note;
  final Value<String> unit;
  final Value<bool> isArchived;
  const ContractCompanion({
    this.id = const Value.absent(),
    this.meterTyp = const Value.absent(),
    this.provider = const Value.absent(),
    this.basicPrice = const Value.absent(),
    this.energyPrice = const Value.absent(),
    this.discount = const Value.absent(),
    this.bonus = const Value.absent(),
    this.note = const Value.absent(),
    this.unit = const Value.absent(),
    this.isArchived = const Value.absent(),
  });
  ContractCompanion.insert({
    this.id = const Value.absent(),
    required String meterTyp,
    this.provider = const Value.absent(),
    required double basicPrice,
    required double energyPrice,
    required double discount,
    this.bonus = const Value.absent(),
    required String note,
    required String unit,
    this.isArchived = const Value.absent(),
  })  : meterTyp = Value(meterTyp),
        basicPrice = Value(basicPrice),
        energyPrice = Value(energyPrice),
        discount = Value(discount),
        note = Value(note),
        unit = Value(unit);
  static Insertable<ContractData> custom({
    Expression<int>? id,
    Expression<String>? meterTyp,
    Expression<int>? provider,
    Expression<double>? basicPrice,
    Expression<double>? energyPrice,
    Expression<double>? discount,
    Expression<int>? bonus,
    Expression<String>? note,
    Expression<String>? unit,
    Expression<bool>? isArchived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (meterTyp != null) 'meter_typ': meterTyp,
      if (provider != null) 'provider': provider,
      if (basicPrice != null) 'basic_price': basicPrice,
      if (energyPrice != null) 'energy_price': energyPrice,
      if (discount != null) 'discount': discount,
      if (bonus != null) 'bonus': bonus,
      if (note != null) 'note': note,
      if (unit != null) 'unit': unit,
      if (isArchived != null) 'is_archived': isArchived,
    });
  }

  ContractCompanion copyWith(
      {Value<int>? id,
      Value<String>? meterTyp,
      Value<int?>? provider,
      Value<double>? basicPrice,
      Value<double>? energyPrice,
      Value<double>? discount,
      Value<int?>? bonus,
      Value<String>? note,
      Value<String>? unit,
      Value<bool>? isArchived}) {
    return ContractCompanion(
      id: id ?? this.id,
      meterTyp: meterTyp ?? this.meterTyp,
      provider: provider ?? this.provider,
      basicPrice: basicPrice ?? this.basicPrice,
      energyPrice: energyPrice ?? this.energyPrice,
      discount: discount ?? this.discount,
      bonus: bonus ?? this.bonus,
      note: note ?? this.note,
      unit: unit ?? this.unit,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (meterTyp.present) {
      map['meter_typ'] = Variable<String>(meterTyp.value);
    }
    if (provider.present) {
      map['provider'] = Variable<int>(provider.value);
    }
    if (basicPrice.present) {
      map['basic_price'] = Variable<double>(basicPrice.value);
    }
    if (energyPrice.present) {
      map['energy_price'] = Variable<double>(energyPrice.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContractCompanion(')
          ..write('id: $id, ')
          ..write('meterTyp: $meterTyp, ')
          ..write('provider: $provider, ')
          ..write('basicPrice: $basicPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('discount: $discount, ')
          ..write('bonus: $bonus, ')
          ..write('note: $note, ')
          ..write('unit: $unit, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }
}

class Tags extends Table with TableInfo<Tags, TagsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Tags(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, uuid, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  Tags createAlias(String alias) {
    return Tags(attachedDatabase, alias);
  }
}

class TagsData extends DataClass implements Insertable<TagsData> {
  final int id;
  final String uuid;
  final String name;
  final int color;
  const TagsData(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      name: Value(name),
      color: Value(color),
    );
  }

  factory TagsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagsData(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  TagsData copyWith({int? id, String? uuid, String? name, int? color}) =>
      TagsData(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  TagsData copyWithCompanion(TagsCompanion data) {
    return TagsData(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagsData(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagsData &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<TagsData> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> name;
  final Value<int> color;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String name,
    required int color,
  })  : uuid = Value(uuid),
        name = Value(name),
        color = Value(color);
  static Insertable<TagsData> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? name,
      Value<int>? color}) {
    return TagsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class MeterWithTags extends Table
    with TableInfo<MeterWithTags, MeterWithTagsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MeterWithTags(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [meterId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter_with_tags';
  @override
  Set<GeneratedColumn> get $primaryKey => {meterId, tagId};
  @override
  MeterWithTagsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterWithTagsData(
      meterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meter_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  MeterWithTags createAlias(String alias) {
    return MeterWithTags(attachedDatabase, alias);
  }
}

class MeterWithTagsData extends DataClass
    implements Insertable<MeterWithTagsData> {
  final int meterId;
  final String tagId;
  const MeterWithTagsData({required this.meterId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meter_id'] = Variable<int>(meterId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  MeterWithTagsCompanion toCompanion(bool nullToAbsent) {
    return MeterWithTagsCompanion(
      meterId: Value(meterId),
      tagId: Value(tagId),
    );
  }

  factory MeterWithTagsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterWithTagsData(
      meterId: serializer.fromJson<int>(json['meterId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'meterId': serializer.toJson<int>(meterId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  MeterWithTagsData copyWith({int? meterId, String? tagId}) =>
      MeterWithTagsData(
        meterId: meterId ?? this.meterId,
        tagId: tagId ?? this.tagId,
      );
  MeterWithTagsData copyWithCompanion(MeterWithTagsCompanion data) {
    return MeterWithTagsData(
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterWithTagsData(')
          ..write('meterId: $meterId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(meterId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeterWithTagsData &&
          other.meterId == this.meterId &&
          other.tagId == this.tagId);
}

class MeterWithTagsCompanion extends UpdateCompanion<MeterWithTagsData> {
  final Value<int> meterId;
  final Value<String> tagId;
  final Value<int> rowid;
  const MeterWithTagsCompanion({
    this.meterId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeterWithTagsCompanion.insert({
    required int meterId,
    required String tagId,
    this.rowid = const Value.absent(),
  })  : meterId = Value(meterId),
        tagId = Value(tagId);
  static Insertable<MeterWithTagsData> custom({
    Expression<int>? meterId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (meterId != null) 'meter_id': meterId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeterWithTagsCompanion copyWith(
      {Value<int>? meterId, Value<String>? tagId, Value<int>? rowid}) {
    return MeterWithTagsCompanion(
      meterId: meterId ?? this.meterId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (meterId.present) {
      map['meter_id'] = Variable<int>(meterId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterWithTagsCompanion(')
          ..write('meterId: $meterId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CostCompare extends Table with TableInfo<CostCompare, CostCompareData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CostCompare(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<double> basicPrice = GeneratedColumn<double>(
      'basic_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<double> energyPrice = GeneratedColumn<double>(
      'energy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
      'bonus', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> usage = GeneratedColumn<int>(
      'usage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contract (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, basicPrice, energyPrice, bonus, usage, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_compare';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostCompareData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostCompareData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      basicPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}basic_price'])!,
      energyPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}energy_price'])!,
      bonus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bonus'])!,
      usage: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usage'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id'])!,
    );
  }

  @override
  CostCompare createAlias(String alias) {
    return CostCompare(attachedDatabase, alias);
  }
}

class CostCompareData extends DataClass implements Insertable<CostCompareData> {
  final int id;
  final double basicPrice;
  final double energyPrice;
  final int bonus;
  final int usage;
  final int parentId;
  const CostCompareData(
      {required this.id,
      required this.basicPrice,
      required this.energyPrice,
      required this.bonus,
      required this.usage,
      required this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['basic_price'] = Variable<double>(basicPrice);
    map['energy_price'] = Variable<double>(energyPrice);
    map['bonus'] = Variable<int>(bonus);
    map['usage'] = Variable<int>(usage);
    map['parent_id'] = Variable<int>(parentId);
    return map;
  }

  CostCompareCompanion toCompanion(bool nullToAbsent) {
    return CostCompareCompanion(
      id: Value(id),
      basicPrice: Value(basicPrice),
      energyPrice: Value(energyPrice),
      bonus: Value(bonus),
      usage: Value(usage),
      parentId: Value(parentId),
    );
  }

  factory CostCompareData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostCompareData(
      id: serializer.fromJson<int>(json['id']),
      basicPrice: serializer.fromJson<double>(json['basicPrice']),
      energyPrice: serializer.fromJson<double>(json['energyPrice']),
      bonus: serializer.fromJson<int>(json['bonus']),
      usage: serializer.fromJson<int>(json['usage']),
      parentId: serializer.fromJson<int>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'basicPrice': serializer.toJson<double>(basicPrice),
      'energyPrice': serializer.toJson<double>(energyPrice),
      'bonus': serializer.toJson<int>(bonus),
      'usage': serializer.toJson<int>(usage),
      'parentId': serializer.toJson<int>(parentId),
    };
  }

  CostCompareData copyWith(
          {int? id,
          double? basicPrice,
          double? energyPrice,
          int? bonus,
          int? usage,
          int? parentId}) =>
      CostCompareData(
        id: id ?? this.id,
        basicPrice: basicPrice ?? this.basicPrice,
        energyPrice: energyPrice ?? this.energyPrice,
        bonus: bonus ?? this.bonus,
        usage: usage ?? this.usage,
        parentId: parentId ?? this.parentId,
      );
  CostCompareData copyWithCompanion(CostCompareCompanion data) {
    return CostCompareData(
      id: data.id.present ? data.id.value : this.id,
      basicPrice:
          data.basicPrice.present ? data.basicPrice.value : this.basicPrice,
      energyPrice:
          data.energyPrice.present ? data.energyPrice.value : this.energyPrice,
      bonus: data.bonus.present ? data.bonus.value : this.bonus,
      usage: data.usage.present ? data.usage.value : this.usage,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostCompareData(')
          ..write('id: $id, ')
          ..write('basicPrice: $basicPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('bonus: $bonus, ')
          ..write('usage: $usage, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, basicPrice, energyPrice, bonus, usage, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostCompareData &&
          other.id == this.id &&
          other.basicPrice == this.basicPrice &&
          other.energyPrice == this.energyPrice &&
          other.bonus == this.bonus &&
          other.usage == this.usage &&
          other.parentId == this.parentId);
}

class CostCompareCompanion extends UpdateCompanion<CostCompareData> {
  final Value<int> id;
  final Value<double> basicPrice;
  final Value<double> energyPrice;
  final Value<int> bonus;
  final Value<int> usage;
  final Value<int> parentId;
  const CostCompareCompanion({
    this.id = const Value.absent(),
    this.basicPrice = const Value.absent(),
    this.energyPrice = const Value.absent(),
    this.bonus = const Value.absent(),
    this.usage = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  CostCompareCompanion.insert({
    this.id = const Value.absent(),
    required double basicPrice,
    required double energyPrice,
    required int bonus,
    required int usage,
    required int parentId,
  })  : basicPrice = Value(basicPrice),
        energyPrice = Value(energyPrice),
        bonus = Value(bonus),
        usage = Value(usage),
        parentId = Value(parentId);
  static Insertable<CostCompareData> custom({
    Expression<int>? id,
    Expression<double>? basicPrice,
    Expression<double>? energyPrice,
    Expression<int>? bonus,
    Expression<int>? usage,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (basicPrice != null) 'basic_price': basicPrice,
      if (energyPrice != null) 'energy_price': energyPrice,
      if (bonus != null) 'bonus': bonus,
      if (usage != null) 'usage': usage,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  CostCompareCompanion copyWith(
      {Value<int>? id,
      Value<double>? basicPrice,
      Value<double>? energyPrice,
      Value<int>? bonus,
      Value<int>? usage,
      Value<int>? parentId}) {
    return CostCompareCompanion(
      id: id ?? this.id,
      basicPrice: basicPrice ?? this.basicPrice,
      energyPrice: energyPrice ?? this.energyPrice,
      bonus: bonus ?? this.bonus,
      usage: usage ?? this.usage,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (basicPrice.present) {
      map['basic_price'] = Variable<double>(basicPrice.value);
    }
    if (energyPrice.present) {
      map['energy_price'] = Variable<double>(energyPrice.value);
    }
    if (bonus.present) {
      map['bonus'] = Variable<int>(bonus.value);
    }
    if (usage.present) {
      map['usage'] = Variable<int>(usage.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostCompareCompanion(')
          ..write('id: $id, ')
          ..write('basicPrice: $basicPrice, ')
          ..write('energyPrice: $energyPrice, ')
          ..write('bonus: $bonus, ')
          ..write('usage: $usage, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }
}

class MeterContract extends Table
    with TableInfo<MeterContract, MeterContractData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MeterContract(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
      'contract_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contract (id) ON DELETE CASCADE'));
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [meterId, contractId, startDate, endDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter_contract';
  @override
  Set<GeneratedColumn> get $primaryKey => {meterId, contractId};
  @override
  MeterContractData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterContractData(
      meterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meter_id'])!,
      contractId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}contract_id'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
    );
  }

  @override
  MeterContract createAlias(String alias) {
    return MeterContract(attachedDatabase, alias);
  }
}

class MeterContractData extends DataClass
    implements Insertable<MeterContractData> {
  final int meterId;
  final int contractId;
  final DateTime? startDate;
  final DateTime? endDate;
  const MeterContractData(
      {required this.meterId,
      required this.contractId,
      this.startDate,
      this.endDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['meter_id'] = Variable<int>(meterId);
    map['contract_id'] = Variable<int>(contractId);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    return map;
  }

  MeterContractCompanion toCompanion(bool nullToAbsent) {
    return MeterContractCompanion(
      meterId: Value(meterId),
      contractId: Value(contractId),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
    );
  }

  factory MeterContractData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterContractData(
      meterId: serializer.fromJson<int>(json['meterId']),
      contractId: serializer.fromJson<int>(json['contractId']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'meterId': serializer.toJson<int>(meterId),
      'contractId': serializer.toJson<int>(contractId),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
    };
  }

  MeterContractData copyWith(
          {int? meterId,
          int? contractId,
          Value<DateTime?> startDate = const Value.absent(),
          Value<DateTime?> endDate = const Value.absent()}) =>
      MeterContractData(
        meterId: meterId ?? this.meterId,
        contractId: contractId ?? this.contractId,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
      );
  MeterContractData copyWithCompanion(MeterContractCompanion data) {
    return MeterContractData(
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      contractId:
          data.contractId.present ? data.contractId.value : this.contractId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterContractData(')
          ..write('meterId: $meterId, ')
          ..write('contractId: $contractId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(meterId, contractId, startDate, endDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeterContractData &&
          other.meterId == this.meterId &&
          other.contractId == this.contractId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate);
}

class MeterContractCompanion extends UpdateCompanion<MeterContractData> {
  final Value<int> meterId;
  final Value<int> contractId;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<int> rowid;
  const MeterContractCompanion({
    this.meterId = const Value.absent(),
    this.contractId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeterContractCompanion.insert({
    required int meterId,
    required int contractId,
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : meterId = Value(meterId),
        contractId = Value(contractId);
  static Insertable<MeterContractData> custom({
    Expression<int>? meterId,
    Expression<int>? contractId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (meterId != null) 'meter_id': meterId,
      if (contractId != null) 'contract_id': contractId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeterContractCompanion copyWith(
      {Value<int>? meterId,
      Value<int>? contractId,
      Value<DateTime?>? startDate,
      Value<DateTime?>? endDate,
      Value<int>? rowid}) {
    return MeterContractCompanion(
      meterId: meterId ?? this.meterId,
      contractId: contractId ?? this.contractId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (meterId.present) {
      map['meter_id'] = Variable<int>(meterId.value);
    }
    if (contractId.present) {
      map['contract_id'] = Variable<int>(contractId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeterContractCompanion(')
          ..write('meterId: $meterId, ')
          ..write('contractId: $contractId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV10 extends GeneratedDatabase {
  DatabaseAtV10(QueryExecutor e) : super(e);
  late final Meter meter = Meter(this);
  late final Entries entries = Entries(this);
  late final Room room = Room(this);
  late final MeterInRoom meterInRoom = MeterInRoom(this);
  late final Provider provider = Provider(this);
  late final Contract contract = Contract(this);
  late final Tags tags = Tags(this);
  late final MeterWithTags meterWithTags = MeterWithTags(this);
  late final CostCompare costCompare = CostCompare(this);
  late final MeterContract meterContract = MeterContract(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        meter,
        entries,
        room,
        meterInRoom,
        provider,
        contract,
        tags,
        meterWithTags,
        costCompare,
        meterContract
      ];
  @override
  int get schemaVersion => 10;
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}
