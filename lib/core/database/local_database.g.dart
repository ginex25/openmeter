// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $MeterTable extends Meter with TableInfo<$MeterTable, MeterData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typMeta = const VerificationMeta('typ');
  @override
  late final GeneratedColumn<String> typ = GeneratedColumn<String>(
      'typ', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, typ, note, number, unit, isArchived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meter';
  @override
  VerificationContext validateIntegrity(Insertable<MeterData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('typ')) {
      context.handle(
          _typMeta, typ.isAcceptableOrUnknown(data['typ']!, _typMeta));
    } else if (isInserting) {
      context.missing(_typMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

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
  $MeterTable createAlias(String alias) {
    return $MeterTable(attachedDatabase, alias);
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

class $EntriesTable extends Entries with TableInfo<$EntriesTable, Entry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _meterMeta = const VerificationMeta('meter');
  @override
  late final GeneratedColumn<int> meter = GeneratedColumn<int>(
      'meter', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
      'count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usageMeta = const VerificationMeta('usage');
  @override
  late final GeneratedColumn<int> usage = GeneratedColumn<int>(
      'usage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
      'days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isResetMeta =
      const VerificationMeta('isReset');
  @override
  late final GeneratedColumn<bool> isReset = GeneratedColumn<bool>(
      'is_reset', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_reset" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _transmittedToProviderMeta =
      const VerificationMeta('transmittedToProvider');
  @override
  late final GeneratedColumn<bool> transmittedToProvider =
      GeneratedColumn<bool>('transmitted_to_provider', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("transmitted_to_provider" IN (0, 1))'),
          defaultValue: const Constant(false));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
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
  VerificationContext validateIntegrity(Insertable<Entry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meter')) {
      context.handle(
          _meterMeta, meter.isAcceptableOrUnknown(data['meter']!, _meterMeta));
    } else if (isInserting) {
      context.missing(_meterMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
          _countMeta, count.isAcceptableOrUnknown(data['count']!, _countMeta));
    } else if (isInserting) {
      context.missing(_countMeta);
    }
    if (data.containsKey('usage')) {
      context.handle(
          _usageMeta, usage.isAcceptableOrUnknown(data['usage']!, _usageMeta));
    } else if (isInserting) {
      context.missing(_usageMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_reset')) {
      context.handle(_isResetMeta,
          isReset.isAcceptableOrUnknown(data['is_reset']!, _isResetMeta));
    }
    if (data.containsKey('transmitted_to_provider')) {
      context.handle(
          _transmittedToProviderMeta,
          transmittedToProvider.isAcceptableOrUnknown(
              data['transmitted_to_provider']!, _transmittedToProviderMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entry(
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
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class Entry extends DataClass implements Insertable<Entry> {
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
  const Entry(
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

  factory Entry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entry(
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

  Entry copyWith(
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
      Entry(
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
  Entry copyWithCompanion(EntriesCompanion data) {
    return Entry(
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
    return (StringBuffer('Entry(')
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
      (other is Entry &&
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

class EntriesCompanion extends UpdateCompanion<Entry> {
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
  static Insertable<Entry> custom({
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

class $RoomTable extends Room with TableInfo<$RoomTable, RoomData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typMeta = const VerificationMeta('typ');
  @override
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
  VerificationContext validateIntegrity(Insertable<RoomData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('typ')) {
      context.handle(
          _typMeta, typ.isAcceptableOrUnknown(data['typ']!, _typMeta));
    } else if (isInserting) {
      context.missing(_typMeta);
    }
    return context;
  }

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
  $RoomTable createAlias(String alias) {
    return $RoomTable(attachedDatabase, alias);
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

class $MeterInRoomTable extends MeterInRoom
    with TableInfo<$MeterInRoomTable, MeterInRoomData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterInRoomTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _meterIdMeta =
      const VerificationMeta('meterId');
  @override
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
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
  VerificationContext validateIntegrity(Insertable<MeterInRoomData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meter_id')) {
      context.handle(_meterIdMeta,
          meterId.isAcceptableOrUnknown(data['meter_id']!, _meterIdMeta));
    } else if (isInserting) {
      context.missing(_meterIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta,
          roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    return context;
  }

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
  $MeterInRoomTable createAlias(String alias) {
    return $MeterInRoomTable(attachedDatabase, alias);
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

class $ProviderTable extends c.Provider
    with TableInfo<$ProviderTable, ProviderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProviderTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contractNumberMeta =
      const VerificationMeta('contractNumber');
  @override
  late final GeneratedColumn<String> contractNumber = GeneratedColumn<String>(
      'contract_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noticeMeta = const VerificationMeta('notice');
  @override
  late final GeneratedColumn<int> notice = GeneratedColumn<int>(
      'notice', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _validFromMeta =
      const VerificationMeta('validFrom');
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
      'valid_from', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _validUntilMeta =
      const VerificationMeta('validUntil');
  @override
  late final GeneratedColumn<DateTime> validUntil = GeneratedColumn<DateTime>(
      'valid_until', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _renewalMeta =
      const VerificationMeta('renewal');
  @override
  late final GeneratedColumn<int> renewal = GeneratedColumn<int>(
      'renewal', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _canceledMeta =
      const VerificationMeta('canceled');
  @override
  late final GeneratedColumn<bool> canceled = GeneratedColumn<bool>(
      'canceled', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("canceled" IN (0, 1))'));
  static const VerificationMeta _canceledDateMeta =
      const VerificationMeta('canceledDate');
  @override
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
  VerificationContext validateIntegrity(Insertable<ProviderData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contract_number')) {
      context.handle(
          _contractNumberMeta,
          contractNumber.isAcceptableOrUnknown(
              data['contract_number']!, _contractNumberMeta));
    } else if (isInserting) {
      context.missing(_contractNumberMeta);
    }
    if (data.containsKey('notice')) {
      context.handle(_noticeMeta,
          notice.isAcceptableOrUnknown(data['notice']!, _noticeMeta));
    }
    if (data.containsKey('valid_from')) {
      context.handle(_validFromMeta,
          validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta));
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_until')) {
      context.handle(
          _validUntilMeta,
          validUntil.isAcceptableOrUnknown(
              data['valid_until']!, _validUntilMeta));
    } else if (isInserting) {
      context.missing(_validUntilMeta);
    }
    if (data.containsKey('renewal')) {
      context.handle(_renewalMeta,
          renewal.isAcceptableOrUnknown(data['renewal']!, _renewalMeta));
    }
    if (data.containsKey('canceled')) {
      context.handle(_canceledMeta,
          canceled.isAcceptableOrUnknown(data['canceled']!, _canceledMeta));
    }
    if (data.containsKey('canceled_date')) {
      context.handle(
          _canceledDateMeta,
          canceledDate.isAcceptableOrUnknown(
              data['canceled_date']!, _canceledDateMeta));
    }
    return context;
  }

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
  $ProviderTable createAlias(String alias) {
    return $ProviderTable(attachedDatabase, alias);
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

class $ContractTable extends c.Contract
    with TableInfo<$ContractTable, ContractData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContractTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _meterTypMeta =
      const VerificationMeta('meterTyp');
  @override
  late final GeneratedColumn<String> meterTyp = GeneratedColumn<String>(
      'meter_typ', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<int> provider = GeneratedColumn<int>(
      'provider', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES provider (id) ON DELETE SET NULL'));
  static const VerificationMeta _basicPriceMeta =
      const VerificationMeta('basicPrice');
  @override
  late final GeneratedColumn<double> basicPrice = GeneratedColumn<double>(
      'basic_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _energyPriceMeta =
      const VerificationMeta('energyPrice');
  @override
  late final GeneratedColumn<double> energyPrice = GeneratedColumn<double>(
      'energy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
      'bonus', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  VerificationContext validateIntegrity(Insertable<ContractData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meter_typ')) {
      context.handle(_meterTypMeta,
          meterTyp.isAcceptableOrUnknown(data['meter_typ']!, _meterTypMeta));
    } else if (isInserting) {
      context.missing(_meterTypMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    }
    if (data.containsKey('basic_price')) {
      context.handle(
          _basicPriceMeta,
          basicPrice.isAcceptableOrUnknown(
              data['basic_price']!, _basicPriceMeta));
    } else if (isInserting) {
      context.missing(_basicPriceMeta);
    }
    if (data.containsKey('energy_price')) {
      context.handle(
          _energyPriceMeta,
          energyPrice.isAcceptableOrUnknown(
              data['energy_price']!, _energyPriceMeta));
    } else if (isInserting) {
      context.missing(_energyPriceMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    } else if (isInserting) {
      context.missing(_discountMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
          _bonusMeta, bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

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
  $ContractTable createAlias(String alias) {
    return $ContractTable(attachedDatabase, alias);
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

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
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
  VerificationContext validateIntegrity(Insertable<Tag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
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
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String uuid;
  final String name;
  final int color;
  const Tag(
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

  factory Tag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
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

  Tag copyWith({int? id, String? uuid, String? name, int? color}) => Tag(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
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
      (other is Tag &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
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
  static Insertable<Tag> custom({
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

class $MeterWithTagsTable extends MeterWithTags
    with TableInfo<$MeterWithTagsTable, MeterWithTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterWithTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _meterIdMeta =
      const VerificationMeta('meterId');
  @override
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
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
  VerificationContext validateIntegrity(Insertable<MeterWithTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meter_id')) {
      context.handle(_meterIdMeta,
          meterId.isAcceptableOrUnknown(data['meter_id']!, _meterIdMeta));
    } else if (isInserting) {
      context.missing(_meterIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {meterId, tagId};
  @override
  MeterWithTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeterWithTag(
      meterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}meter_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $MeterWithTagsTable createAlias(String alias) {
    return $MeterWithTagsTable(attachedDatabase, alias);
  }
}

class MeterWithTag extends DataClass implements Insertable<MeterWithTag> {
  final int meterId;
  final String tagId;
  const MeterWithTag({required this.meterId, required this.tagId});
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

  factory MeterWithTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeterWithTag(
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

  MeterWithTag copyWith({int? meterId, String? tagId}) => MeterWithTag(
        meterId: meterId ?? this.meterId,
        tagId: tagId ?? this.tagId,
      );
  MeterWithTag copyWithCompanion(MeterWithTagsCompanion data) {
    return MeterWithTag(
      meterId: data.meterId.present ? data.meterId.value : this.meterId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeterWithTag(')
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
      (other is MeterWithTag &&
          other.meterId == this.meterId &&
          other.tagId == this.tagId);
}

class MeterWithTagsCompanion extends UpdateCompanion<MeterWithTag> {
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
  static Insertable<MeterWithTag> custom({
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

class $CostCompareTable extends CostCompare
    with TableInfo<$CostCompareTable, CostCompareData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostCompareTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _basicPriceMeta =
      const VerificationMeta('basicPrice');
  @override
  late final GeneratedColumn<double> basicPrice = GeneratedColumn<double>(
      'basic_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _energyPriceMeta =
      const VerificationMeta('energyPrice');
  @override
  late final GeneratedColumn<double> energyPrice = GeneratedColumn<double>(
      'energy_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _bonusMeta = const VerificationMeta('bonus');
  @override
  late final GeneratedColumn<int> bonus = GeneratedColumn<int>(
      'bonus', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _usageMeta = const VerificationMeta('usage');
  @override
  late final GeneratedColumn<int> usage = GeneratedColumn<int>(
      'usage', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
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
  VerificationContext validateIntegrity(Insertable<CostCompareData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('basic_price')) {
      context.handle(
          _basicPriceMeta,
          basicPrice.isAcceptableOrUnknown(
              data['basic_price']!, _basicPriceMeta));
    } else if (isInserting) {
      context.missing(_basicPriceMeta);
    }
    if (data.containsKey('energy_price')) {
      context.handle(
          _energyPriceMeta,
          energyPrice.isAcceptableOrUnknown(
              data['energy_price']!, _energyPriceMeta));
    } else if (isInserting) {
      context.missing(_energyPriceMeta);
    }
    if (data.containsKey('bonus')) {
      context.handle(
          _bonusMeta, bonus.isAcceptableOrUnknown(data['bonus']!, _bonusMeta));
    } else if (isInserting) {
      context.missing(_bonusMeta);
    }
    if (data.containsKey('usage')) {
      context.handle(
          _usageMeta, usage.isAcceptableOrUnknown(data['usage']!, _usageMeta));
    } else if (isInserting) {
      context.missing(_usageMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    return context;
  }

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
  $CostCompareTable createAlias(String alias) {
    return $CostCompareTable(attachedDatabase, alias);
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

class $MeterContractTable extends MeterContract
    with TableInfo<$MeterContractTable, MeterContractData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeterContractTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _meterIdMeta =
      const VerificationMeta('meterId');
  @override
  late final GeneratedColumn<int> meterId = GeneratedColumn<int>(
      'meter_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES meter (id) ON DELETE CASCADE'));
  static const VerificationMeta _contractIdMeta =
      const VerificationMeta('contractId');
  @override
  late final GeneratedColumn<int> contractId = GeneratedColumn<int>(
      'contract_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES contract (id) ON DELETE CASCADE'));
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
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
  VerificationContext validateIntegrity(Insertable<MeterContractData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('meter_id')) {
      context.handle(_meterIdMeta,
          meterId.isAcceptableOrUnknown(data['meter_id']!, _meterIdMeta));
    } else if (isInserting) {
      context.missing(_meterIdMeta);
    }
    if (data.containsKey('contract_id')) {
      context.handle(
          _contractIdMeta,
          contractId.isAcceptableOrUnknown(
              data['contract_id']!, _contractIdMeta));
    } else if (isInserting) {
      context.missing(_contractIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    return context;
  }

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
  $MeterContractTable createAlias(String alias) {
    return $MeterContractTable(attachedDatabase, alias);
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

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $MeterTable meter = $MeterTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  late final $RoomTable room = $RoomTable(this);
  late final $MeterInRoomTable meterInRoom = $MeterInRoomTable(this);
  late final $ProviderTable provider = $ProviderTable(this);
  late final $ContractTable contract = $ContractTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $MeterWithTagsTable meterWithTags = $MeterWithTagsTable(this);
  late final $CostCompareTable costCompare = $CostCompareTable(this);
  late final $MeterContractTable meterContract = $MeterContractTable(this);
  late final Index idxMeterId =
      Index('idx_meter_id', 'CREATE INDEX idx_meter_id ON meter (id)');
  late final Index idxMeterType =
      Index('idx_meter_type', 'CREATE INDEX idx_meter_type ON meter (typ)');
  late final Index idxMeterArchived = Index('idx_meter_archived',
      'CREATE INDEX idx_meter_archived ON meter (is_archived)');
  late final Index idxEntryMeterId = Index('idx_entry_meter_id',
      'CREATE INDEX idx_entry_meter_id ON entries (meter)');
  late final Index idxEntryId =
      Index('idx_entry_id', 'CREATE INDEX idx_entry_id ON entries (id)');
  late final Index idxRoomId =
      Index('idx_room_id', 'CREATE INDEX idx_room_id ON room (id)');
  late final Index idxRoomUuid =
      Index('idx_room_uuid', 'CREATE INDEX idx_room_uuid ON room (uuid)');
  late final Index idxMeterroomRoomId = Index('idx_meterroom_room_id',
      'CREATE INDEX idx_meterroom_room_id ON meter_in_room (room_id)');
  late final Index idxMeterroomMeterId = Index('idx_meterroom_meter_id',
      'CREATE INDEX idx_meterroom_meter_id ON meter_in_room (meter_id)');
  late final Index idxContractArchived = Index('idx_contract_archived',
      'CREATE INDEX idx_contract_archived ON contract (is_archived)');
  late final Index idxContractId =
      Index('idx_contract_id', 'CREATE INDEX idx_contract_id ON contract (id)');
  late final Index idxContractArchivedTyp = Index('idx_contract_archived_typ',
      'CREATE INDEX idx_contract_archived_typ ON contract (is_archived, meter_typ)');
  late final Index idxProviderId =
      Index('idx_provider_id', 'CREATE INDEX idx_provider_id ON provider (id)');
  late final Index idxTagId =
      Index('idx_tag_id', 'CREATE INDEX idx_tag_id ON tags (id)');
  late final Index idxTagUuid =
      Index('idx_tag_uuid', 'CREATE INDEX idx_tag_uuid ON tags (uuid)');
  late final Index idxMetertagMeterId = Index('idx_metertag_meter_id',
      'CREATE INDEX idx_metertag_meter_id ON meter_with_tags (meter_id)');
  late final Index idxMetertagTagId = Index('idx_metertag_tag_id',
      'CREATE INDEX idx_metertag_tag_id ON meter_with_tags (tag_id)');
  late final Index idxCostCompareId = Index('idx_cost_compare_id',
      'CREATE INDEX idx_cost_compare_id ON cost_compare (id)');
  late final Index idxCostCompareParentId = Index('idx_cost_compare_parent_id',
      'CREATE INDEX idx_cost_compare_parent_id ON cost_compare (parent_id)');
  late final MeterDao meterDao = MeterDao(this as LocalDatabase);
  late final EntryDao entryDao = EntryDao(this as LocalDatabase);
  late final RoomDao roomDao = RoomDao(this as LocalDatabase);
  late final ContractDao contractDao = ContractDao(this as LocalDatabase);
  late final TagsDao tagsDao = TagsDao(this as LocalDatabase);
  late final CostCompareDao costCompareDao =
      CostCompareDao(this as LocalDatabase);
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
        meterContract,
        idxMeterId,
        idxMeterType,
        idxMeterArchived,
        idxEntryMeterId,
        idxEntryId,
        idxRoomId,
        idxRoomUuid,
        idxMeterroomRoomId,
        idxMeterroomMeterId,
        idxContractArchived,
        idxContractId,
        idxContractArchivedTyp,
        idxProviderId,
        idxTagId,
        idxTagUuid,
        idxMetertagMeterId,
        idxMetertagTagId,
        idxCostCompareId,
        idxCostCompareParentId
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('meter',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meter',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meter_in_room', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('provider',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('contract', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meter',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meter_with_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('contract',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('cost_compare', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('meter',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meter_contract', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('contract',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('meter_contract', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$MeterTableCreateCompanionBuilder = MeterCompanion Function({
  Value<int> id,
  required String typ,
  required String note,
  required String number,
  required String unit,
  Value<bool> isArchived,
});
typedef $$MeterTableUpdateCompanionBuilder = MeterCompanion Function({
  Value<int> id,
  Value<String> typ,
  Value<String> note,
  Value<String> number,
  Value<String> unit,
  Value<bool> isArchived,
});

final class $$MeterTableReferences
    extends BaseReferences<_$LocalDatabase, $MeterTable, MeterData> {
  $$MeterTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntriesTable, List<Entry>> _entriesRefsTable(
          _$LocalDatabase db) =>
      MultiTypedResultKey.fromTable(db.entries,
          aliasName: $_aliasNameGenerator(db.meter.id, db.entries.meter));

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager($_db, $_db.entries)
        .filter((f) => f.meter.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MeterInRoomTable, List<MeterInRoomData>>
      _meterInRoomRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.meterInRoom,
              aliasName:
                  $_aliasNameGenerator(db.meter.id, db.meterInRoom.meterId));

  $$MeterInRoomTableProcessedTableManager get meterInRoomRefs {
    final manager = $$MeterInRoomTableTableManager($_db, $_db.meterInRoom)
        .filter((f) => f.meterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meterInRoomRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MeterWithTagsTable, List<MeterWithTag>>
      _meterWithTagsRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.meterWithTags,
              aliasName:
                  $_aliasNameGenerator(db.meter.id, db.meterWithTags.meterId));

  $$MeterWithTagsTableProcessedTableManager get meterWithTagsRefs {
    final manager = $$MeterWithTagsTableTableManager($_db, $_db.meterWithTags)
        .filter((f) => f.meterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meterWithTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MeterContractTable, List<MeterContractData>>
      _meterContractRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.meterContract,
              aliasName:
                  $_aliasNameGenerator(db.meter.id, db.meterContract.meterId));

  $$MeterContractTableProcessedTableManager get meterContractRefs {
    final manager = $$MeterContractTableTableManager($_db, $_db.meterContract)
        .filter((f) => f.meterId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meterContractRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MeterTableFilterComposer
    extends Composer<_$LocalDatabase, $MeterTable> {
  $$MeterTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typ => $composableBuilder(
      column: $table.typ, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  Expression<bool> entriesRefs(
      Expression<bool> Function($$EntriesTableFilterComposer f) f) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entries,
        getReferencedColumn: (t) => t.meter,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntriesTableFilterComposer(
              $db: $db,
              $table: $db.entries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> meterInRoomRefs(
      Expression<bool> Function($$MeterInRoomTableFilterComposer f) f) {
    final $$MeterInRoomTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterInRoom,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterInRoomTableFilterComposer(
              $db: $db,
              $table: $db.meterInRoom,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> meterWithTagsRefs(
      Expression<bool> Function($$MeterWithTagsTableFilterComposer f) f) {
    final $$MeterWithTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterWithTags,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterWithTagsTableFilterComposer(
              $db: $db,
              $table: $db.meterWithTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> meterContractRefs(
      Expression<bool> Function($$MeterContractTableFilterComposer f) f) {
    final $$MeterContractTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterContract,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterContractTableFilterComposer(
              $db: $db,
              $table: $db.meterContract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MeterTableOrderingComposer
    extends Composer<_$LocalDatabase, $MeterTable> {
  $$MeterTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typ => $composableBuilder(
      column: $table.typ, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));
}

class $$MeterTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MeterTable> {
  $$MeterTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typ =>
      $composableBuilder(column: $table.typ, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  Expression<T> entriesRefs<T extends Object>(
      Expression<T> Function($$EntriesTableAnnotationComposer a) f) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entries,
        getReferencedColumn: (t) => t.meter,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.entries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> meterInRoomRefs<T extends Object>(
      Expression<T> Function($$MeterInRoomTableAnnotationComposer a) f) {
    final $$MeterInRoomTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterInRoom,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterInRoomTableAnnotationComposer(
              $db: $db,
              $table: $db.meterInRoom,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> meterWithTagsRefs<T extends Object>(
      Expression<T> Function($$MeterWithTagsTableAnnotationComposer a) f) {
    final $$MeterWithTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterWithTags,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterWithTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.meterWithTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> meterContractRefs<T extends Object>(
      Expression<T> Function($$MeterContractTableAnnotationComposer a) f) {
    final $$MeterContractTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterContract,
        getReferencedColumn: (t) => t.meterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterContractTableAnnotationComposer(
              $db: $db,
              $table: $db.meterContract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MeterTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $MeterTable,
    MeterData,
    $$MeterTableFilterComposer,
    $$MeterTableOrderingComposer,
    $$MeterTableAnnotationComposer,
    $$MeterTableCreateCompanionBuilder,
    $$MeterTableUpdateCompanionBuilder,
    (MeterData, $$MeterTableReferences),
    MeterData,
    PrefetchHooks Function(
        {bool entriesRefs,
        bool meterInRoomRefs,
        bool meterWithTagsRefs,
        bool meterContractRefs})> {
  $$MeterTableTableManager(_$LocalDatabase db, $MeterTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeterTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeterTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeterTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> typ = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> number = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
          }) =>
              MeterCompanion(
            id: id,
            typ: typ,
            note: note,
            number: number,
            unit: unit,
            isArchived: isArchived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String typ,
            required String note,
            required String number,
            required String unit,
            Value<bool> isArchived = const Value.absent(),
          }) =>
              MeterCompanion.insert(
            id: id,
            typ: typ,
            note: note,
            number: number,
            unit: unit,
            isArchived: isArchived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MeterTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {entriesRefs = false,
              meterInRoomRefs = false,
              meterWithTagsRefs = false,
              meterContractRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (entriesRefs) db.entries,
                if (meterInRoomRefs) db.meterInRoom,
                if (meterWithTagsRefs) db.meterWithTags,
                if (meterContractRefs) db.meterContract
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<MeterData, $MeterTable, Entry>(
                        currentTable: table,
                        referencedTable:
                            $$MeterTableReferences._entriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MeterTableReferences(db, table, p0).entriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.meter == item.id),
                        typedResults: items),
                  if (meterInRoomRefs)
                    await $_getPrefetchedData<MeterData, $MeterTable,
                            MeterInRoomData>(
                        currentTable: table,
                        referencedTable:
                            $$MeterTableReferences._meterInRoomRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MeterTableReferences(db, table, p0)
                                .meterInRoomRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.meterId == item.id),
                        typedResults: items),
                  if (meterWithTagsRefs)
                    await $_getPrefetchedData<MeterData, $MeterTable,
                            MeterWithTag>(
                        currentTable: table,
                        referencedTable:
                            $$MeterTableReferences._meterWithTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MeterTableReferences(db, table, p0)
                                .meterWithTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.meterId == item.id),
                        typedResults: items),
                  if (meterContractRefs)
                    await $_getPrefetchedData<MeterData, $MeterTable,
                            MeterContractData>(
                        currentTable: table,
                        referencedTable:
                            $$MeterTableReferences._meterContractRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MeterTableReferences(db, table, p0)
                                .meterContractRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.meterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MeterTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $MeterTable,
    MeterData,
    $$MeterTableFilterComposer,
    $$MeterTableOrderingComposer,
    $$MeterTableAnnotationComposer,
    $$MeterTableCreateCompanionBuilder,
    $$MeterTableUpdateCompanionBuilder,
    (MeterData, $$MeterTableReferences),
    MeterData,
    PrefetchHooks Function(
        {bool entriesRefs,
        bool meterInRoomRefs,
        bool meterWithTagsRefs,
        bool meterContractRefs})>;
typedef $$EntriesTableCreateCompanionBuilder = EntriesCompanion Function({
  Value<int> id,
  required int meter,
  required int count,
  required int usage,
  required DateTime date,
  required int days,
  Value<String?> note,
  Value<bool> isReset,
  Value<bool> transmittedToProvider,
  Value<String?> imagePath,
});
typedef $$EntriesTableUpdateCompanionBuilder = EntriesCompanion Function({
  Value<int> id,
  Value<int> meter,
  Value<int> count,
  Value<int> usage,
  Value<DateTime> date,
  Value<int> days,
  Value<String?> note,
  Value<bool> isReset,
  Value<bool> transmittedToProvider,
  Value<String?> imagePath,
});

final class $$EntriesTableReferences
    extends BaseReferences<_$LocalDatabase, $EntriesTable, Entry> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeterTable _meterTable(_$LocalDatabase db) =>
      db.meter.createAlias($_aliasNameGenerator(db.entries.meter, db.meter.id));

  $$MeterTableProcessedTableManager get meter {
    final $_column = $_itemColumn<int>('meter')!;

    final manager = $$MeterTableTableManager($_db, $_db.meter)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meterTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$LocalDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usage => $composableBuilder(
      column: $table.usage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReset => $composableBuilder(
      column: $table.isReset, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get transmittedToProvider => $composableBuilder(
      column: $table.transmittedToProvider,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  $$MeterTableFilterComposer get meter {
    final $$MeterTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meter,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableFilterComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get count => $composableBuilder(
      column: $table.count, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usage => $composableBuilder(
      column: $table.usage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReset => $composableBuilder(
      column: $table.isReset, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get transmittedToProvider => $composableBuilder(
      column: $table.transmittedToProvider,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  $$MeterTableOrderingComposer get meter {
    final $$MeterTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meter,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableOrderingComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get usage =>
      $composableBuilder(column: $table.usage, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isReset =>
      $composableBuilder(column: $table.isReset, builder: (column) => column);

  GeneratedColumn<bool> get transmittedToProvider => $composableBuilder(
      column: $table.transmittedToProvider, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$MeterTableAnnotationComposer get meter {
    final $$MeterTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meter,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableAnnotationComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntriesTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $EntriesTable,
    Entry,
    $$EntriesTableFilterComposer,
    $$EntriesTableOrderingComposer,
    $$EntriesTableAnnotationComposer,
    $$EntriesTableCreateCompanionBuilder,
    $$EntriesTableUpdateCompanionBuilder,
    (Entry, $$EntriesTableReferences),
    Entry,
    PrefetchHooks Function({bool meter})> {
  $$EntriesTableTableManager(_$LocalDatabase db, $EntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> meter = const Value.absent(),
            Value<int> count = const Value.absent(),
            Value<int> usage = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int> days = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReset = const Value.absent(),
            Value<bool> transmittedToProvider = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
          }) =>
              EntriesCompanion(
            id: id,
            meter: meter,
            count: count,
            usage: usage,
            date: date,
            days: days,
            note: note,
            isReset: isReset,
            transmittedToProvider: transmittedToProvider,
            imagePath: imagePath,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int meter,
            required int count,
            required int usage,
            required DateTime date,
            required int days,
            Value<String?> note = const Value.absent(),
            Value<bool> isReset = const Value.absent(),
            Value<bool> transmittedToProvider = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
          }) =>
              EntriesCompanion.insert(
            id: id,
            meter: meter,
            count: count,
            usage: usage,
            date: date,
            days: days,
            note: note,
            isReset: isReset,
            transmittedToProvider: transmittedToProvider,
            imagePath: imagePath,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EntriesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({meter = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (meter) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.meter,
                    referencedTable: $$EntriesTableReferences._meterTable(db),
                    referencedColumn:
                        $$EntriesTableReferences._meterTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EntriesTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $EntriesTable,
    Entry,
    $$EntriesTableFilterComposer,
    $$EntriesTableOrderingComposer,
    $$EntriesTableAnnotationComposer,
    $$EntriesTableCreateCompanionBuilder,
    $$EntriesTableUpdateCompanionBuilder,
    (Entry, $$EntriesTableReferences),
    Entry,
    PrefetchHooks Function({bool meter})>;
typedef $$RoomTableCreateCompanionBuilder = RoomCompanion Function({
  Value<int> id,
  required String uuid,
  required String name,
  required String typ,
});
typedef $$RoomTableUpdateCompanionBuilder = RoomCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
  Value<String> typ,
});

class $$RoomTableFilterComposer extends Composer<_$LocalDatabase, $RoomTable> {
  $$RoomTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typ => $composableBuilder(
      column: $table.typ, builder: (column) => ColumnFilters(column));
}

class $$RoomTableOrderingComposer
    extends Composer<_$LocalDatabase, $RoomTable> {
  $$RoomTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typ => $composableBuilder(
      column: $table.typ, builder: (column) => ColumnOrderings(column));
}

class $$RoomTableAnnotationComposer
    extends Composer<_$LocalDatabase, $RoomTable> {
  $$RoomTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get typ =>
      $composableBuilder(column: $table.typ, builder: (column) => column);
}

class $$RoomTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $RoomTable,
    RoomData,
    $$RoomTableFilterComposer,
    $$RoomTableOrderingComposer,
    $$RoomTableAnnotationComposer,
    $$RoomTableCreateCompanionBuilder,
    $$RoomTableUpdateCompanionBuilder,
    (RoomData, BaseReferences<_$LocalDatabase, $RoomTable, RoomData>),
    RoomData,
    PrefetchHooks Function()> {
  $$RoomTableTableManager(_$LocalDatabase db, $RoomTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoomTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoomTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoomTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> typ = const Value.absent(),
          }) =>
              RoomCompanion(
            id: id,
            uuid: uuid,
            name: name,
            typ: typ,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String name,
            required String typ,
          }) =>
              RoomCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
            typ: typ,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoomTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $RoomTable,
    RoomData,
    $$RoomTableFilterComposer,
    $$RoomTableOrderingComposer,
    $$RoomTableAnnotationComposer,
    $$RoomTableCreateCompanionBuilder,
    $$RoomTableUpdateCompanionBuilder,
    (RoomData, BaseReferences<_$LocalDatabase, $RoomTable, RoomData>),
    RoomData,
    PrefetchHooks Function()>;
typedef $$MeterInRoomTableCreateCompanionBuilder = MeterInRoomCompanion
    Function({
  required int meterId,
  required String roomId,
  Value<int> rowid,
});
typedef $$MeterInRoomTableUpdateCompanionBuilder = MeterInRoomCompanion
    Function({
  Value<int> meterId,
  Value<String> roomId,
  Value<int> rowid,
});

final class $$MeterInRoomTableReferences extends BaseReferences<_$LocalDatabase,
    $MeterInRoomTable, MeterInRoomData> {
  $$MeterInRoomTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MeterTable _meterIdTable(_$LocalDatabase db) => db.meter
      .createAlias($_aliasNameGenerator(db.meterInRoom.meterId, db.meter.id));

  $$MeterTableProcessedTableManager get meterId {
    final $_column = $_itemColumn<int>('meter_id')!;

    final manager = $$MeterTableTableManager($_db, $_db.meter)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MeterInRoomTableFilterComposer
    extends Composer<_$LocalDatabase, $MeterInRoomTable> {
  $$MeterInRoomTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnFilters(column));

  $$MeterTableFilterComposer get meterId {
    final $$MeterTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableFilterComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterInRoomTableOrderingComposer
    extends Composer<_$LocalDatabase, $MeterInRoomTable> {
  $$MeterInRoomTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnOrderings(column));

  $$MeterTableOrderingComposer get meterId {
    final $$MeterTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableOrderingComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterInRoomTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MeterInRoomTable> {
  $$MeterInRoomTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  $$MeterTableAnnotationComposer get meterId {
    final $$MeterTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableAnnotationComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterInRoomTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $MeterInRoomTable,
    MeterInRoomData,
    $$MeterInRoomTableFilterComposer,
    $$MeterInRoomTableOrderingComposer,
    $$MeterInRoomTableAnnotationComposer,
    $$MeterInRoomTableCreateCompanionBuilder,
    $$MeterInRoomTableUpdateCompanionBuilder,
    (MeterInRoomData, $$MeterInRoomTableReferences),
    MeterInRoomData,
    PrefetchHooks Function({bool meterId})> {
  $$MeterInRoomTableTableManager(_$LocalDatabase db, $MeterInRoomTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeterInRoomTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeterInRoomTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeterInRoomTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> meterId = const Value.absent(),
            Value<String> roomId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterInRoomCompanion(
            meterId: meterId,
            roomId: roomId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int meterId,
            required String roomId,
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterInRoomCompanion.insert(
            meterId: meterId,
            roomId: roomId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MeterInRoomTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({meterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (meterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.meterId,
                    referencedTable:
                        $$MeterInRoomTableReferences._meterIdTable(db),
                    referencedColumn:
                        $$MeterInRoomTableReferences._meterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MeterInRoomTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $MeterInRoomTable,
    MeterInRoomData,
    $$MeterInRoomTableFilterComposer,
    $$MeterInRoomTableOrderingComposer,
    $$MeterInRoomTableAnnotationComposer,
    $$MeterInRoomTableCreateCompanionBuilder,
    $$MeterInRoomTableUpdateCompanionBuilder,
    (MeterInRoomData, $$MeterInRoomTableReferences),
    MeterInRoomData,
    PrefetchHooks Function({bool meterId})>;
typedef $$ProviderTableCreateCompanionBuilder = ProviderCompanion Function({
  Value<int> id,
  required String name,
  required String contractNumber,
  Value<int?> notice,
  required DateTime validFrom,
  required DateTime validUntil,
  Value<int?> renewal,
  Value<bool?> canceled,
  Value<DateTime?> canceledDate,
});
typedef $$ProviderTableUpdateCompanionBuilder = ProviderCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> contractNumber,
  Value<int?> notice,
  Value<DateTime> validFrom,
  Value<DateTime> validUntil,
  Value<int?> renewal,
  Value<bool?> canceled,
  Value<DateTime?> canceledDate,
});

final class $$ProviderTableReferences
    extends BaseReferences<_$LocalDatabase, $ProviderTable, ProviderData> {
  $$ProviderTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ContractTable, List<ContractData>>
      _contractRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.contract,
              aliasName:
                  $_aliasNameGenerator(db.provider.id, db.contract.provider));

  $$ContractTableProcessedTableManager get contractRefs {
    final manager = $$ContractTableTableManager($_db, $_db.contract)
        .filter((f) => f.provider.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_contractRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProviderTableFilterComposer
    extends Composer<_$LocalDatabase, $ProviderTable> {
  $$ProviderTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contractNumber => $composableBuilder(
      column: $table.contractNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get notice => $composableBuilder(
      column: $table.notice, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get renewal => $composableBuilder(
      column: $table.renewal, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get canceled => $composableBuilder(
      column: $table.canceled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get canceledDate => $composableBuilder(
      column: $table.canceledDate, builder: (column) => ColumnFilters(column));

  Expression<bool> contractRefs(
      Expression<bool> Function($$ContractTableFilterComposer f) f) {
    final $$ContractTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.provider,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableFilterComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProviderTableOrderingComposer
    extends Composer<_$LocalDatabase, $ProviderTable> {
  $$ProviderTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contractNumber => $composableBuilder(
      column: $table.contractNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get notice => $composableBuilder(
      column: $table.notice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
      column: $table.validFrom, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get renewal => $composableBuilder(
      column: $table.renewal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get canceled => $composableBuilder(
      column: $table.canceled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get canceledDate => $composableBuilder(
      column: $table.canceledDate,
      builder: (column) => ColumnOrderings(column));
}

class $$ProviderTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ProviderTable> {
  $$ProviderTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contractNumber => $composableBuilder(
      column: $table.contractNumber, builder: (column) => column);

  GeneratedColumn<int> get notice =>
      $composableBuilder(column: $table.notice, builder: (column) => column);

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<DateTime> get validUntil => $composableBuilder(
      column: $table.validUntil, builder: (column) => column);

  GeneratedColumn<int> get renewal =>
      $composableBuilder(column: $table.renewal, builder: (column) => column);

  GeneratedColumn<bool> get canceled =>
      $composableBuilder(column: $table.canceled, builder: (column) => column);

  GeneratedColumn<DateTime> get canceledDate => $composableBuilder(
      column: $table.canceledDate, builder: (column) => column);

  Expression<T> contractRefs<T extends Object>(
      Expression<T> Function($$ContractTableAnnotationComposer a) f) {
    final $$ContractTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.provider,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableAnnotationComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProviderTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ProviderTable,
    ProviderData,
    $$ProviderTableFilterComposer,
    $$ProviderTableOrderingComposer,
    $$ProviderTableAnnotationComposer,
    $$ProviderTableCreateCompanionBuilder,
    $$ProviderTableUpdateCompanionBuilder,
    (ProviderData, $$ProviderTableReferences),
    ProviderData,
    PrefetchHooks Function({bool contractRefs})> {
  $$ProviderTableTableManager(_$LocalDatabase db, $ProviderTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProviderTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProviderTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProviderTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> contractNumber = const Value.absent(),
            Value<int?> notice = const Value.absent(),
            Value<DateTime> validFrom = const Value.absent(),
            Value<DateTime> validUntil = const Value.absent(),
            Value<int?> renewal = const Value.absent(),
            Value<bool?> canceled = const Value.absent(),
            Value<DateTime?> canceledDate = const Value.absent(),
          }) =>
              ProviderCompanion(
            id: id,
            name: name,
            contractNumber: contractNumber,
            notice: notice,
            validFrom: validFrom,
            validUntil: validUntil,
            renewal: renewal,
            canceled: canceled,
            canceledDate: canceledDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String contractNumber,
            Value<int?> notice = const Value.absent(),
            required DateTime validFrom,
            required DateTime validUntil,
            Value<int?> renewal = const Value.absent(),
            Value<bool?> canceled = const Value.absent(),
            Value<DateTime?> canceledDate = const Value.absent(),
          }) =>
              ProviderCompanion.insert(
            id: id,
            name: name,
            contractNumber: contractNumber,
            notice: notice,
            validFrom: validFrom,
            validUntil: validUntil,
            renewal: renewal,
            canceled: canceled,
            canceledDate: canceledDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProviderTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({contractRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (contractRefs) db.contract],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (contractRefs)
                    await $_getPrefetchedData<ProviderData, $ProviderTable,
                            ContractData>(
                        currentTable: table,
                        referencedTable:
                            $$ProviderTableReferences._contractRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProviderTableReferences(db, table, p0)
                                .contractRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.provider == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProviderTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $ProviderTable,
    ProviderData,
    $$ProviderTableFilterComposer,
    $$ProviderTableOrderingComposer,
    $$ProviderTableAnnotationComposer,
    $$ProviderTableCreateCompanionBuilder,
    $$ProviderTableUpdateCompanionBuilder,
    (ProviderData, $$ProviderTableReferences),
    ProviderData,
    PrefetchHooks Function({bool contractRefs})>;
typedef $$ContractTableCreateCompanionBuilder = ContractCompanion Function({
  Value<int> id,
  required String meterTyp,
  Value<int?> provider,
  required double basicPrice,
  required double energyPrice,
  required double discount,
  Value<int?> bonus,
  required String note,
  required String unit,
  Value<bool> isArchived,
});
typedef $$ContractTableUpdateCompanionBuilder = ContractCompanion Function({
  Value<int> id,
  Value<String> meterTyp,
  Value<int?> provider,
  Value<double> basicPrice,
  Value<double> energyPrice,
  Value<double> discount,
  Value<int?> bonus,
  Value<String> note,
  Value<String> unit,
  Value<bool> isArchived,
});

final class $$ContractTableReferences
    extends BaseReferences<_$LocalDatabase, $ContractTable, ContractData> {
  $$ContractTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProviderTable _providerTable(_$LocalDatabase db) => db.provider
      .createAlias($_aliasNameGenerator(db.contract.provider, db.provider.id));

  $$ProviderTableProcessedTableManager? get provider {
    final $_column = $_itemColumn<int>('provider');
    if ($_column == null) return null;
    final manager = $$ProviderTableTableManager($_db, $_db.provider)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_providerTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$CostCompareTable, List<CostCompareData>>
      _costCompareRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.costCompare,
              aliasName: $_aliasNameGenerator(
                  db.contract.id, db.costCompare.parentId));

  $$CostCompareTableProcessedTableManager get costCompareRefs {
    final manager = $$CostCompareTableTableManager($_db, $_db.costCompare)
        .filter((f) => f.parentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_costCompareRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MeterContractTable, List<MeterContractData>>
      _meterContractRefsTable(_$LocalDatabase db) =>
          MultiTypedResultKey.fromTable(db.meterContract,
              aliasName: $_aliasNameGenerator(
                  db.contract.id, db.meterContract.contractId));

  $$MeterContractTableProcessedTableManager get meterContractRefs {
    final manager = $$MeterContractTableTableManager($_db, $_db.meterContract)
        .filter((f) => f.contractId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_meterContractRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ContractTableFilterComposer
    extends Composer<_$LocalDatabase, $ContractTable> {
  $$ContractTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get meterTyp => $composableBuilder(
      column: $table.meterTyp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  $$ProviderTableFilterComposer get provider {
    final $$ProviderTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.provider,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProviderTableFilterComposer(
              $db: $db,
              $table: $db.provider,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> costCompareRefs(
      Expression<bool> Function($$CostCompareTableFilterComposer f) f) {
    final $$CostCompareTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costCompare,
        getReferencedColumn: (t) => t.parentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCompareTableFilterComposer(
              $db: $db,
              $table: $db.costCompare,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> meterContractRefs(
      Expression<bool> Function($$MeterContractTableFilterComposer f) f) {
    final $$MeterContractTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterContract,
        getReferencedColumn: (t) => t.contractId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterContractTableFilterComposer(
              $db: $db,
              $table: $db.meterContract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContractTableOrderingComposer
    extends Composer<_$LocalDatabase, $ContractTable> {
  $$ContractTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get meterTyp => $composableBuilder(
      column: $table.meterTyp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  $$ProviderTableOrderingComposer get provider {
    final $$ProviderTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.provider,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProviderTableOrderingComposer(
              $db: $db,
              $table: $db.provider,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ContractTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ContractTable> {
  $$ContractTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get meterTyp =>
      $composableBuilder(column: $table.meterTyp, builder: (column) => column);

  GeneratedColumn<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => column);

  GeneratedColumn<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  $$ProviderTableAnnotationComposer get provider {
    final $$ProviderTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.provider,
        referencedTable: $db.provider,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProviderTableAnnotationComposer(
              $db: $db,
              $table: $db.provider,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> costCompareRefs<T extends Object>(
      Expression<T> Function($$CostCompareTableAnnotationComposer a) f) {
    final $$CostCompareTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.costCompare,
        getReferencedColumn: (t) => t.parentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CostCompareTableAnnotationComposer(
              $db: $db,
              $table: $db.costCompare,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> meterContractRefs<T extends Object>(
      Expression<T> Function($$MeterContractTableAnnotationComposer a) f) {
    final $$MeterContractTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.meterContract,
        getReferencedColumn: (t) => t.contractId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterContractTableAnnotationComposer(
              $db: $db,
              $table: $db.meterContract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ContractTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $ContractTable,
    ContractData,
    $$ContractTableFilterComposer,
    $$ContractTableOrderingComposer,
    $$ContractTableAnnotationComposer,
    $$ContractTableCreateCompanionBuilder,
    $$ContractTableUpdateCompanionBuilder,
    (ContractData, $$ContractTableReferences),
    ContractData,
    PrefetchHooks Function(
        {bool provider, bool costCompareRefs, bool meterContractRefs})> {
  $$ContractTableTableManager(_$LocalDatabase db, $ContractTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContractTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContractTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContractTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> meterTyp = const Value.absent(),
            Value<int?> provider = const Value.absent(),
            Value<double> basicPrice = const Value.absent(),
            Value<double> energyPrice = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<int?> bonus = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
          }) =>
              ContractCompanion(
            id: id,
            meterTyp: meterTyp,
            provider: provider,
            basicPrice: basicPrice,
            energyPrice: energyPrice,
            discount: discount,
            bonus: bonus,
            note: note,
            unit: unit,
            isArchived: isArchived,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String meterTyp,
            Value<int?> provider = const Value.absent(),
            required double basicPrice,
            required double energyPrice,
            required double discount,
            Value<int?> bonus = const Value.absent(),
            required String note,
            required String unit,
            Value<bool> isArchived = const Value.absent(),
          }) =>
              ContractCompanion.insert(
            id: id,
            meterTyp: meterTyp,
            provider: provider,
            basicPrice: basicPrice,
            energyPrice: energyPrice,
            discount: discount,
            bonus: bonus,
            note: note,
            unit: unit,
            isArchived: isArchived,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ContractTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {provider = false,
              costCompareRefs = false,
              meterContractRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (costCompareRefs) db.costCompare,
                if (meterContractRefs) db.meterContract
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (provider) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.provider,
                    referencedTable:
                        $$ContractTableReferences._providerTable(db),
                    referencedColumn:
                        $$ContractTableReferences._providerTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (costCompareRefs)
                    await $_getPrefetchedData<ContractData, $ContractTable,
                            CostCompareData>(
                        currentTable: table,
                        referencedTable:
                            $$ContractTableReferences._costCompareRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContractTableReferences(db, table, p0)
                                .costCompareRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.parentId == item.id),
                        typedResults: items),
                  if (meterContractRefs)
                    await $_getPrefetchedData<ContractData, $ContractTable, MeterContractData>(
                        currentTable: table,
                        referencedTable: $$ContractTableReferences
                            ._meterContractRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ContractTableReferences(db, table, p0)
                                .meterContractRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.contractId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ContractTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $ContractTable,
    ContractData,
    $$ContractTableFilterComposer,
    $$ContractTableOrderingComposer,
    $$ContractTableAnnotationComposer,
    $$ContractTableCreateCompanionBuilder,
    $$ContractTableUpdateCompanionBuilder,
    (ContractData, $$ContractTableReferences),
    ContractData,
    PrefetchHooks Function(
        {bool provider, bool costCompareRefs, bool meterContractRefs})>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  required String uuid,
  required String name,
  required int color,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> name,
  Value<int> color,
});

class $$TagsTableFilterComposer extends Composer<_$LocalDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));
}

class $$TagsTableOrderingComposer
    extends Composer<_$LocalDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$TagsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$TagsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$LocalDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()> {
  $$TagsTableTableManager(_$LocalDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            uuid: uuid,
            name: name,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String name,
            required int color,
          }) =>
              TagsCompanion.insert(
            id: id,
            uuid: uuid,
            name: name,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $TagsTable,
    Tag,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (Tag, BaseReferences<_$LocalDatabase, $TagsTable, Tag>),
    Tag,
    PrefetchHooks Function()>;
typedef $$MeterWithTagsTableCreateCompanionBuilder = MeterWithTagsCompanion
    Function({
  required int meterId,
  required String tagId,
  Value<int> rowid,
});
typedef $$MeterWithTagsTableUpdateCompanionBuilder = MeterWithTagsCompanion
    Function({
  Value<int> meterId,
  Value<String> tagId,
  Value<int> rowid,
});

final class $$MeterWithTagsTableReferences
    extends BaseReferences<_$LocalDatabase, $MeterWithTagsTable, MeterWithTag> {
  $$MeterWithTagsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MeterTable _meterIdTable(_$LocalDatabase db) => db.meter
      .createAlias($_aliasNameGenerator(db.meterWithTags.meterId, db.meter.id));

  $$MeterTableProcessedTableManager get meterId {
    final $_column = $_itemColumn<int>('meter_id')!;

    final manager = $$MeterTableTableManager($_db, $_db.meter)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MeterWithTagsTableFilterComposer
    extends Composer<_$LocalDatabase, $MeterWithTagsTable> {
  $$MeterWithTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnFilters(column));

  $$MeterTableFilterComposer get meterId {
    final $$MeterTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableFilterComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterWithTagsTableOrderingComposer
    extends Composer<_$LocalDatabase, $MeterWithTagsTable> {
  $$MeterWithTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get tagId => $composableBuilder(
      column: $table.tagId, builder: (column) => ColumnOrderings(column));

  $$MeterTableOrderingComposer get meterId {
    final $$MeterTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableOrderingComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterWithTagsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MeterWithTagsTable> {
  $$MeterWithTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);

  $$MeterTableAnnotationComposer get meterId {
    final $$MeterTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableAnnotationComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterWithTagsTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $MeterWithTagsTable,
    MeterWithTag,
    $$MeterWithTagsTableFilterComposer,
    $$MeterWithTagsTableOrderingComposer,
    $$MeterWithTagsTableAnnotationComposer,
    $$MeterWithTagsTableCreateCompanionBuilder,
    $$MeterWithTagsTableUpdateCompanionBuilder,
    (MeterWithTag, $$MeterWithTagsTableReferences),
    MeterWithTag,
    PrefetchHooks Function({bool meterId})> {
  $$MeterWithTagsTableTableManager(
      _$LocalDatabase db, $MeterWithTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeterWithTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeterWithTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeterWithTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> meterId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterWithTagsCompanion(
            meterId: meterId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int meterId,
            required String tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterWithTagsCompanion.insert(
            meterId: meterId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MeterWithTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({meterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (meterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.meterId,
                    referencedTable:
                        $$MeterWithTagsTableReferences._meterIdTable(db),
                    referencedColumn:
                        $$MeterWithTagsTableReferences._meterIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MeterWithTagsTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $MeterWithTagsTable,
    MeterWithTag,
    $$MeterWithTagsTableFilterComposer,
    $$MeterWithTagsTableOrderingComposer,
    $$MeterWithTagsTableAnnotationComposer,
    $$MeterWithTagsTableCreateCompanionBuilder,
    $$MeterWithTagsTableUpdateCompanionBuilder,
    (MeterWithTag, $$MeterWithTagsTableReferences),
    MeterWithTag,
    PrefetchHooks Function({bool meterId})>;
typedef $$CostCompareTableCreateCompanionBuilder = CostCompareCompanion
    Function({
  Value<int> id,
  required double basicPrice,
  required double energyPrice,
  required int bonus,
  required int usage,
  required int parentId,
});
typedef $$CostCompareTableUpdateCompanionBuilder = CostCompareCompanion
    Function({
  Value<int> id,
  Value<double> basicPrice,
  Value<double> energyPrice,
  Value<int> bonus,
  Value<int> usage,
  Value<int> parentId,
});

final class $$CostCompareTableReferences extends BaseReferences<_$LocalDatabase,
    $CostCompareTable, CostCompareData> {
  $$CostCompareTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ContractTable _parentIdTable(_$LocalDatabase db) =>
      db.contract.createAlias(
          $_aliasNameGenerator(db.costCompare.parentId, db.contract.id));

  $$ContractTableProcessedTableManager get parentId {
    final $_column = $_itemColumn<int>('parent_id')!;

    final manager = $$ContractTableTableManager($_db, $_db.contract)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CostCompareTableFilterComposer
    extends Composer<_$LocalDatabase, $CostCompareTable> {
  $$CostCompareTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get usage => $composableBuilder(
      column: $table.usage, builder: (column) => ColumnFilters(column));

  $$ContractTableFilterComposer get parentId {
    final $$ContractTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableFilterComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostCompareTableOrderingComposer
    extends Composer<_$LocalDatabase, $CostCompareTable> {
  $$CostCompareTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bonus => $composableBuilder(
      column: $table.bonus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get usage => $composableBuilder(
      column: $table.usage, builder: (column) => ColumnOrderings(column));

  $$ContractTableOrderingComposer get parentId {
    final $$ContractTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableOrderingComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostCompareTableAnnotationComposer
    extends Composer<_$LocalDatabase, $CostCompareTable> {
  $$CostCompareTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get basicPrice => $composableBuilder(
      column: $table.basicPrice, builder: (column) => column);

  GeneratedColumn<double> get energyPrice => $composableBuilder(
      column: $table.energyPrice, builder: (column) => column);

  GeneratedColumn<int> get bonus =>
      $composableBuilder(column: $table.bonus, builder: (column) => column);

  GeneratedColumn<int> get usage =>
      $composableBuilder(column: $table.usage, builder: (column) => column);

  $$ContractTableAnnotationComposer get parentId {
    final $$ContractTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableAnnotationComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CostCompareTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $CostCompareTable,
    CostCompareData,
    $$CostCompareTableFilterComposer,
    $$CostCompareTableOrderingComposer,
    $$CostCompareTableAnnotationComposer,
    $$CostCompareTableCreateCompanionBuilder,
    $$CostCompareTableUpdateCompanionBuilder,
    (CostCompareData, $$CostCompareTableReferences),
    CostCompareData,
    PrefetchHooks Function({bool parentId})> {
  $$CostCompareTableTableManager(_$LocalDatabase db, $CostCompareTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostCompareTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostCompareTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostCompareTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> basicPrice = const Value.absent(),
            Value<double> energyPrice = const Value.absent(),
            Value<int> bonus = const Value.absent(),
            Value<int> usage = const Value.absent(),
            Value<int> parentId = const Value.absent(),
          }) =>
              CostCompareCompanion(
            id: id,
            basicPrice: basicPrice,
            energyPrice: energyPrice,
            bonus: bonus,
            usage: usage,
            parentId: parentId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double basicPrice,
            required double energyPrice,
            required int bonus,
            required int usage,
            required int parentId,
          }) =>
              CostCompareCompanion.insert(
            id: id,
            basicPrice: basicPrice,
            energyPrice: energyPrice,
            bonus: bonus,
            usage: usage,
            parentId: parentId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CostCompareTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$CostCompareTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$CostCompareTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CostCompareTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $CostCompareTable,
    CostCompareData,
    $$CostCompareTableFilterComposer,
    $$CostCompareTableOrderingComposer,
    $$CostCompareTableAnnotationComposer,
    $$CostCompareTableCreateCompanionBuilder,
    $$CostCompareTableUpdateCompanionBuilder,
    (CostCompareData, $$CostCompareTableReferences),
    CostCompareData,
    PrefetchHooks Function({bool parentId})>;
typedef $$MeterContractTableCreateCompanionBuilder = MeterContractCompanion
    Function({
  required int meterId,
  required int contractId,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});
typedef $$MeterContractTableUpdateCompanionBuilder = MeterContractCompanion
    Function({
  Value<int> meterId,
  Value<int> contractId,
  Value<DateTime?> startDate,
  Value<DateTime?> endDate,
  Value<int> rowid,
});

final class $$MeterContractTableReferences extends BaseReferences<
    _$LocalDatabase, $MeterContractTable, MeterContractData> {
  $$MeterContractTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MeterTable _meterIdTable(_$LocalDatabase db) => db.meter
      .createAlias($_aliasNameGenerator(db.meterContract.meterId, db.meter.id));

  $$MeterTableProcessedTableManager get meterId {
    final $_column = $_itemColumn<int>('meter_id')!;

    final manager = $$MeterTableTableManager($_db, $_db.meter)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_meterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ContractTable _contractIdTable(_$LocalDatabase db) =>
      db.contract.createAlias(
          $_aliasNameGenerator(db.meterContract.contractId, db.contract.id));

  $$ContractTableProcessedTableManager get contractId {
    final $_column = $_itemColumn<int>('contract_id')!;

    final manager = $$ContractTableTableManager($_db, $_db.contract)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_contractIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MeterContractTableFilterComposer
    extends Composer<_$LocalDatabase, $MeterContractTable> {
  $$MeterContractTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  $$MeterTableFilterComposer get meterId {
    final $$MeterTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableFilterComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContractTableFilterComposer get contractId {
    final $$ContractTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contractId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableFilterComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterContractTableOrderingComposer
    extends Composer<_$LocalDatabase, $MeterContractTable> {
  $$MeterContractTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  $$MeterTableOrderingComposer get meterId {
    final $$MeterTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableOrderingComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContractTableOrderingComposer get contractId {
    final $$ContractTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contractId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableOrderingComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterContractTableAnnotationComposer
    extends Composer<_$LocalDatabase, $MeterContractTable> {
  $$MeterContractTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  $$MeterTableAnnotationComposer get meterId {
    final $$MeterTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.meterId,
        referencedTable: $db.meter,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MeterTableAnnotationComposer(
              $db: $db,
              $table: $db.meter,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ContractTableAnnotationComposer get contractId {
    final $$ContractTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.contractId,
        referencedTable: $db.contract,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ContractTableAnnotationComposer(
              $db: $db,
              $table: $db.contract,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MeterContractTableTableManager extends RootTableManager<
    _$LocalDatabase,
    $MeterContractTable,
    MeterContractData,
    $$MeterContractTableFilterComposer,
    $$MeterContractTableOrderingComposer,
    $$MeterContractTableAnnotationComposer,
    $$MeterContractTableCreateCompanionBuilder,
    $$MeterContractTableUpdateCompanionBuilder,
    (MeterContractData, $$MeterContractTableReferences),
    MeterContractData,
    PrefetchHooks Function({bool meterId, bool contractId})> {
  $$MeterContractTableTableManager(
      _$LocalDatabase db, $MeterContractTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeterContractTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeterContractTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeterContractTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> meterId = const Value.absent(),
            Value<int> contractId = const Value.absent(),
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterContractCompanion(
            meterId: meterId,
            contractId: contractId,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int meterId,
            required int contractId,
            Value<DateTime?> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeterContractCompanion.insert(
            meterId: meterId,
            contractId: contractId,
            startDate: startDate,
            endDate: endDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MeterContractTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({meterId = false, contractId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (meterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.meterId,
                    referencedTable:
                        $$MeterContractTableReferences._meterIdTable(db),
                    referencedColumn:
                        $$MeterContractTableReferences._meterIdTable(db).id,
                  ) as T;
                }
                if (contractId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.contractId,
                    referencedTable:
                        $$MeterContractTableReferences._contractIdTable(db),
                    referencedColumn:
                        $$MeterContractTableReferences._contractIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MeterContractTableProcessedTableManager = ProcessedTableManager<
    _$LocalDatabase,
    $MeterContractTable,
    MeterContractData,
    $$MeterContractTableFilterComposer,
    $$MeterContractTableOrderingComposer,
    $$MeterContractTableAnnotationComposer,
    $$MeterContractTableCreateCompanionBuilder,
    $$MeterContractTableUpdateCompanionBuilder,
    (MeterContractData, $$MeterContractTableReferences),
    MeterContractData,
    PrefetchHooks Function({bool meterId, bool contractId})>;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$MeterTableTableManager get meter =>
      $$MeterTableTableManager(_db, _db.meter);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
  $$RoomTableTableManager get room => $$RoomTableTableManager(_db, _db.room);
  $$MeterInRoomTableTableManager get meterInRoom =>
      $$MeterInRoomTableTableManager(_db, _db.meterInRoom);
  $$ProviderTableTableManager get provider =>
      $$ProviderTableTableManager(_db, _db.provider);
  $$ContractTableTableManager get contract =>
      $$ContractTableTableManager(_db, _db.contract);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$MeterWithTagsTableTableManager get meterWithTags =>
      $$MeterWithTagsTableTableManager(_db, _db.meterWithTags);
  $$CostCompareTableTableManager get costCompare =>
      $$CostCompareTableTableManager(_db, _db.costCompare);
  $$MeterContractTableTableManager get meterContract =>
      $$MeterContractTableTableManager(_db, _db.meterContract);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localDbHash() => r'4c6dda4d48370072c7a4885a0b7dd4a9d55797ad';

/// See also [localDb].
@ProviderFor(localDb)
final localDbProvider = Provider<LocalDatabase>.internal(
  localDb,
  name: r'localDbProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localDbHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalDbRef = ProviderRef<LocalDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
