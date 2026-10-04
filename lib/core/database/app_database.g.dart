// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ActivityRecordsTable extends ActivityRecords
    with TableInfo<$ActivityRecordsTable, ActivityRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityType>($ActivityRecordsTable.$convertertype);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMetersMeta = const VerificationMeta(
    'distanceMeters',
  );
  @override
  late final GeneratedColumn<double> distanceMeters = GeneratedColumn<double>(
    'distance_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    startedAt,
    durationSeconds,
    distanceMeters,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationSecondsMeta);
    }
    if (data.containsKey('distance_meters')) {
      context.handle(
        _distanceMetersMeta,
        distanceMeters.isAcceptableOrUnknown(
          data['distance_meters']!,
          _distanceMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_distanceMetersMeta);
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: $ActivityRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      distanceMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_meters'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      ),
    );
  }

  @override
  $ActivityRecordsTable createAlias(String alias) {
    return $ActivityRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityType, String, String> $convertertype =
      const EnumNameConverter<ActivityType>(ActivityType.values);
}

class ActivityRecord extends DataClass implements Insertable<ActivityRecord> {
  final int id;
  final String userId;
  final ActivityType type;
  final DateTime startedAt;
  final int durationSeconds;
  final double distanceMeters;
  final DateTime? syncedAt;
  const ActivityRecord({
    required this.id,
    required this.userId,
    required this.type,
    required this.startedAt,
    required this.durationSeconds,
    required this.distanceMeters,
    this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['type'] = Variable<String>(
        $ActivityRecordsTable.$convertertype.toSql(type),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['distance_meters'] = Variable<double>(distanceMeters);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ActivityRecordsCompanion toCompanion(bool nullToAbsent) {
    return ActivityRecordsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      startedAt: Value(startedAt),
      durationSeconds: Value(durationSeconds),
      distanceMeters: Value(distanceMeters),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory ActivityRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRecord(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: $ActivityRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      distanceMeters: serializer.fromJson<double>(json['distanceMeters']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(
        $ActivityRecordsTable.$convertertype.toJson(type),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'distanceMeters': serializer.toJson<double>(distanceMeters),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ActivityRecord copyWith({
    int? id,
    String? userId,
    ActivityType? type,
    DateTime? startedAt,
    int? durationSeconds,
    double? distanceMeters,
    Value<DateTime?> syncedAt = const Value.absent(),
  }) => ActivityRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    startedAt: startedAt ?? this.startedAt,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    distanceMeters: distanceMeters ?? this.distanceMeters,
    syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
  );
  ActivityRecord copyWithCompanion(ActivityRecordsCompanion data) {
    return ActivityRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      distanceMeters: data.distanceMeters.present
          ? data.distanceMeters.value
          : this.distanceMeters,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    startedAt,
    durationSeconds,
    distanceMeters,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.startedAt == this.startedAt &&
          other.durationSeconds == this.durationSeconds &&
          other.distanceMeters == this.distanceMeters &&
          other.syncedAt == this.syncedAt);
}

class ActivityRecordsCompanion extends UpdateCompanion<ActivityRecord> {
  final Value<int> id;
  final Value<String> userId;
  final Value<ActivityType> type;
  final Value<DateTime> startedAt;
  final Value<int> durationSeconds;
  final Value<double> distanceMeters;
  final Value<DateTime?> syncedAt;
  const ActivityRecordsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.distanceMeters = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  ActivityRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required ActivityType type,
    required DateTime startedAt,
    required int durationSeconds,
    required double distanceMeters,
    this.syncedAt = const Value.absent(),
  }) : userId = Value(userId),
       type = Value(type),
       startedAt = Value(startedAt),
       durationSeconds = Value(durationSeconds),
       distanceMeters = Value(distanceMeters);
  static Insertable<ActivityRecord> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<DateTime>? startedAt,
    Expression<int>? durationSeconds,
    Expression<double>? distanceMeters,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (startedAt != null) 'started_at': startedAt,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (distanceMeters != null) 'distance_meters': distanceMeters,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  ActivityRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<ActivityType>? type,
    Value<DateTime>? startedAt,
    Value<int>? durationSeconds,
    Value<double>? distanceMeters,
    Value<DateTime?>? syncedAt,
  }) {
    return ActivityRecordsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ActivityRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (distanceMeters.present) {
      map['distance_meters'] = Variable<double>(distanceMeters.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRecordsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('distanceMeters: $distanceMeters, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $TrackPointRecordsTable extends TrackPointRecords
    with TableInfo<$TrackPointRecordsTable, TrackPointRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackPointRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activity_records (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _segmentIndexMeta = const VerificationMeta(
    'segmentIndex',
  );
  @override
  late final GeneratedColumn<int> segmentIndex = GeneratedColumn<int>(
    'segment_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    segmentIndex,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'track_point_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<TrackPointRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('segment_index')) {
      context.handle(
        _segmentIndexMeta,
        segmentIndex.isAcceptableOrUnknown(
          data['segment_index']!,
          _segmentIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_segmentIndexMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyMetersMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrackPointRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrackPointRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      )!,
      segmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment_index'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $TrackPointRecordsTable createAlias(String alias) {
    return $TrackPointRecordsTable(attachedDatabase, alias);
  }
}

class TrackPointRecord extends DataClass
    implements Insertable<TrackPointRecord> {
  final int id;
  final int activityId;
  final int segmentIndex;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final DateTime recordedAt;
  const TrackPointRecord({
    required this.id,
    required this.activityId,
    required this.segmentIndex,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<int>(activityId);
    map['segment_index'] = Variable<int>(segmentIndex);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy_meters'] = Variable<double>(accuracyMeters);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  TrackPointRecordsCompanion toCompanion(bool nullToAbsent) {
    return TrackPointRecordsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      segmentIndex: Value(segmentIndex),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracyMeters: Value(accuracyMeters),
      recordedAt: Value(recordedAt),
    );
  }

  factory TrackPointRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrackPointRecord(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<int>(json['activityId']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracyMeters: serializer.fromJson<double>(json['accuracyMeters']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<int>(activityId),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracyMeters': serializer.toJson<double>(accuracyMeters),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  TrackPointRecord copyWith({
    int? id,
    int? activityId,
    int? segmentIndex,
    double? latitude,
    double? longitude,
    double? accuracyMeters,
    DateTime? recordedAt,
  }) => TrackPointRecord(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    segmentIndex: segmentIndex ?? this.segmentIndex,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracyMeters: accuracyMeters ?? this.accuracyMeters,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  TrackPointRecord copyWithCompanion(TrackPointRecordsCompanion data) {
    return TrackPointRecord(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      segmentIndex: data.segmentIndex.present
          ? data.segmentIndex.value
          : this.segmentIndex,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointRecord(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    segmentIndex,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrackPointRecord &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.segmentIndex == this.segmentIndex &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.recordedAt == this.recordedAt);
}

class TrackPointRecordsCompanion extends UpdateCompanion<TrackPointRecord> {
  final Value<int> id;
  final Value<int> activityId;
  final Value<int> segmentIndex;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracyMeters;
  final Value<DateTime> recordedAt;
  const TrackPointRecordsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  TrackPointRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int activityId,
    required int segmentIndex,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required DateTime recordedAt,
  }) : activityId = Value(activityId),
       segmentIndex = Value(segmentIndex),
       latitude = Value(latitude),
       longitude = Value(longitude),
       accuracyMeters = Value(accuracyMeters),
       recordedAt = Value(recordedAt);
  static Insertable<TrackPointRecord> custom({
    Expression<int>? id,
    Expression<int>? activityId,
    Expression<int>? segmentIndex,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (segmentIndex != null) 'segment_index': segmentIndex,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  TrackPointRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? activityId,
    Value<int>? segmentIndex,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? accuracyMeters,
    Value<DateTime>? recordedAt,
  }) {
    return TrackPointRecordsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (segmentIndex.present) {
      map['segment_index'] = Variable<int>(segmentIndex.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackPointRecordsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

class $DraftSessionsTable extends DraftSessions
    with TableInfo<$DraftSessionsTable, DraftSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityType>($DraftSessionsTable.$convertertype);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elapsedSecondsMeta = const VerificationMeta(
    'elapsedSeconds',
  );
  @override
  late final GeneratedColumn<int> elapsedSeconds = GeneratedColumn<int>(
    'elapsed_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    type,
    startedAt,
    elapsedSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('elapsed_seconds')) {
      context.handle(
        _elapsedSecondsMeta,
        elapsedSeconds.isAcceptableOrUnknown(
          data['elapsed_seconds']!,
          _elapsedSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  DraftSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftSession(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: $DraftSessionsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      elapsedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_seconds'],
      )!,
    );
  }

  @override
  $DraftSessionsTable createAlias(String alias) {
    return $DraftSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityType, String, String> $convertertype =
      const EnumNameConverter<ActivityType>(ActivityType.values);
}

class DraftSession extends DataClass implements Insertable<DraftSession> {
  final String userId;
  final ActivityType type;
  final DateTime startedAt;
  final int elapsedSeconds;
  const DraftSession({
    required this.userId,
    required this.type,
    required this.startedAt,
    required this.elapsedSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    {
      map['type'] = Variable<String>(
        $DraftSessionsTable.$convertertype.toSql(type),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['elapsed_seconds'] = Variable<int>(elapsedSeconds);
    return map;
  }

  DraftSessionsCompanion toCompanion(bool nullToAbsent) {
    return DraftSessionsCompanion(
      userId: Value(userId),
      type: Value(type),
      startedAt: Value(startedAt),
      elapsedSeconds: Value(elapsedSeconds),
    );
  }

  factory DraftSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftSession(
      userId: serializer.fromJson<String>(json['userId']),
      type: $DraftSessionsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      elapsedSeconds: serializer.fromJson<int>(json['elapsedSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(
        $DraftSessionsTable.$convertertype.toJson(type),
      ),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'elapsedSeconds': serializer.toJson<int>(elapsedSeconds),
    };
  }

  DraftSession copyWith({
    String? userId,
    ActivityType? type,
    DateTime? startedAt,
    int? elapsedSeconds,
  }) => DraftSession(
    userId: userId ?? this.userId,
    type: type ?? this.type,
    startedAt: startedAt ?? this.startedAt,
    elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
  );
  DraftSession copyWithCompanion(DraftSessionsCompanion data) {
    return DraftSession(
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      elapsedSeconds: data.elapsedSeconds.present
          ? data.elapsedSeconds.value
          : this.elapsedSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftSession(')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('elapsedSeconds: $elapsedSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, type, startedAt, elapsedSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftSession &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.startedAt == this.startedAt &&
          other.elapsedSeconds == this.elapsedSeconds);
}

class DraftSessionsCompanion extends UpdateCompanion<DraftSession> {
  final Value<String> userId;
  final Value<ActivityType> type;
  final Value<DateTime> startedAt;
  final Value<int> elapsedSeconds;
  final Value<int> rowid;
  const DraftSessionsCompanion({
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.elapsedSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DraftSessionsCompanion.insert({
    required String userId,
    required ActivityType type,
    required DateTime startedAt,
    this.elapsedSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       type = Value(type),
       startedAt = Value(startedAt);
  static Insertable<DraftSession> custom({
    Expression<String>? userId,
    Expression<String>? type,
    Expression<DateTime>? startedAt,
    Expression<int>? elapsedSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (startedAt != null) 'started_at': startedAt,
      if (elapsedSeconds != null) 'elapsed_seconds': elapsedSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DraftSessionsCompanion copyWith({
    Value<String>? userId,
    Value<ActivityType>? type,
    Value<DateTime>? startedAt,
    Value<int>? elapsedSeconds,
    Value<int>? rowid,
  }) {
    return DraftSessionsCompanion(
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startedAt: startedAt ?? this.startedAt,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $DraftSessionsTable.$convertertype.toSql(type.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (elapsedSeconds.present) {
      map['elapsed_seconds'] = Variable<int>(elapsedSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftSessionsCompanion(')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('startedAt: $startedAt, ')
          ..write('elapsedSeconds: $elapsedSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DraftPointsTable extends DraftPoints
    with TableInfo<$DraftPointsTable, DraftPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DraftPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES draft_sessions (user_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _segmentIndexMeta = const VerificationMeta(
    'segmentIndex',
  );
  @override
  late final GeneratedColumn<int> segmentIndex = GeneratedColumn<int>(
    'segment_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    segmentIndex,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'draft_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<DraftPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('segment_index')) {
      context.handle(
        _segmentIndexMeta,
        segmentIndex.isAcceptableOrUnknown(
          data['segment_index']!,
          _segmentIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_segmentIndexMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyMetersMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DraftPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DraftPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      segmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}segment_index'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
    );
  }

  @override
  $DraftPointsTable createAlias(String alias) {
    return $DraftPointsTable(attachedDatabase, alias);
  }
}

class DraftPoint extends DataClass implements Insertable<DraftPoint> {
  final int id;
  final String userId;
  final int segmentIndex;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final DateTime recordedAt;
  const DraftPoint({
    required this.id,
    required this.userId,
    required this.segmentIndex,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.recordedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    map['segment_index'] = Variable<int>(segmentIndex);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy_meters'] = Variable<double>(accuracyMeters);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    return map;
  }

  DraftPointsCompanion toCompanion(bool nullToAbsent) {
    return DraftPointsCompanion(
      id: Value(id),
      userId: Value(userId),
      segmentIndex: Value(segmentIndex),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracyMeters: Value(accuracyMeters),
      recordedAt: Value(recordedAt),
    );
  }

  factory DraftPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DraftPoint(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      segmentIndex: serializer.fromJson<int>(json['segmentIndex']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracyMeters: serializer.fromJson<double>(json['accuracyMeters']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'segmentIndex': serializer.toJson<int>(segmentIndex),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracyMeters': serializer.toJson<double>(accuracyMeters),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
    };
  }

  DraftPoint copyWith({
    int? id,
    String? userId,
    int? segmentIndex,
    double? latitude,
    double? longitude,
    double? accuracyMeters,
    DateTime? recordedAt,
  }) => DraftPoint(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    segmentIndex: segmentIndex ?? this.segmentIndex,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracyMeters: accuracyMeters ?? this.accuracyMeters,
    recordedAt: recordedAt ?? this.recordedAt,
  );
  DraftPoint copyWithCompanion(DraftPointsCompanion data) {
    return DraftPoint(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      segmentIndex: data.segmentIndex.present
          ? data.segmentIndex.value
          : this.segmentIndex,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DraftPoint(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    segmentIndex,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DraftPoint &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.segmentIndex == this.segmentIndex &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.recordedAt == this.recordedAt);
}

class DraftPointsCompanion extends UpdateCompanion<DraftPoint> {
  final Value<int> id;
  final Value<String> userId;
  final Value<int> segmentIndex;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracyMeters;
  final Value<DateTime> recordedAt;
  const DraftPointsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.segmentIndex = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.recordedAt = const Value.absent(),
  });
  DraftPointsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    required int segmentIndex,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required DateTime recordedAt,
  }) : userId = Value(userId),
       segmentIndex = Value(segmentIndex),
       latitude = Value(latitude),
       longitude = Value(longitude),
       accuracyMeters = Value(accuracyMeters),
       recordedAt = Value(recordedAt);
  static Insertable<DraftPoint> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<int>? segmentIndex,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? recordedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (segmentIndex != null) 'segment_index': segmentIndex,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (recordedAt != null) 'recorded_at': recordedAt,
    });
  }

  DraftPointsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<int>? segmentIndex,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? accuracyMeters,
    Value<DateTime>? recordedAt,
  }) {
    return DraftPointsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      segmentIndex: segmentIndex ?? this.segmentIndex,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (segmentIndex.present) {
      map['segment_index'] = Variable<int>(segmentIndex.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DraftPointsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('segmentIndex: $segmentIndex, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ActivityRecordsTable activityRecords = $ActivityRecordsTable(
    this,
  );
  late final $TrackPointRecordsTable trackPointRecords =
      $TrackPointRecordsTable(this);
  late final $DraftSessionsTable draftSessions = $DraftSessionsTable(this);
  late final $DraftPointsTable draftPoints = $DraftPointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    activityRecords,
    trackPointRecords,
    draftSessions,
    draftPoints,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activity_records',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('track_point_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'draft_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('draft_points', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ActivityRecordsTableCreateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      required String userId,
      required ActivityType type,
      required DateTime startedAt,
      required int durationSeconds,
      required double distanceMeters,
      Value<DateTime?> syncedAt,
    });
typedef $$ActivityRecordsTableUpdateCompanionBuilder =
    ActivityRecordsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<ActivityType> type,
      Value<DateTime> startedAt,
      Value<int> durationSeconds,
      Value<double> distanceMeters,
      Value<DateTime?> syncedAt,
    });

final class $$ActivityRecordsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ActivityRecordsTable, ActivityRecord> {
  $$ActivityRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TrackPointRecordsTable, List<TrackPointRecord>>
  _trackPointRecordsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.trackPointRecords,
        aliasName: 'activity_records__id__track_point_records__activity_id',
      );

  $$TrackPointRecordsTableProcessedTableManager get trackPointRecordsRefs {
    final manager = $$TrackPointRecordsTableTableManager(
      $_db,
      $_db.trackPointRecords,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _trackPointRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivityRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityType, ActivityType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> trackPointRecordsRefs(
    Expression<bool> Function($$TrackPointRecordsTableFilterComposer f) f,
  ) {
    final $$TrackPointRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trackPointRecords,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TrackPointRecordsTableFilterComposer(
            $db: $db,
            $table: $db.trackPointRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivityRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityRecordsTable> {
  $$ActivityRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceMeters => $composableBuilder(
    column: $table.distanceMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  Expression<T> trackPointRecordsRefs<T extends Object>(
    Expression<T> Function($$TrackPointRecordsTableAnnotationComposer a) f,
  ) {
    final $$TrackPointRecordsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.trackPointRecords,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TrackPointRecordsTableAnnotationComposer(
                $db: $db,
                $table: $db.trackPointRecords,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ActivityRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityRecordsTable,
          ActivityRecord,
          $$ActivityRecordsTableFilterComposer,
          $$ActivityRecordsTableOrderingComposer,
          $$ActivityRecordsTableAnnotationComposer,
          $$ActivityRecordsTableCreateCompanionBuilder,
          $$ActivityRecordsTableUpdateCompanionBuilder,
          (ActivityRecord, $$ActivityRecordsTableReferences),
          ActivityRecord,
          PrefetchHooks Function({bool trackPointRecordsRefs})
        > {
  $$ActivityRecordsTableTableManager(
    _$AppDatabase db,
    $ActivityRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<ActivityType> type = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<double> distanceMeters = const Value.absent(),
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => ActivityRecordsCompanion(
                id: id,
                userId: userId,
                type: type,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required ActivityType type,
                required DateTime startedAt,
                required int durationSeconds,
                required double distanceMeters,
                Value<DateTime?> syncedAt = const Value.absent(),
              }) => ActivityRecordsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                startedAt: startedAt,
                durationSeconds: durationSeconds,
                distanceMeters: distanceMeters,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({trackPointRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (trackPointRecordsRefs) db.trackPointRecords,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (trackPointRecordsRefs)
                    await $_getPrefetchedData<
                      ActivityRecord,
                      $ActivityRecordsTable,
                      TrackPointRecord
                    >(
                      currentTable: table,
                      referencedTable: $$ActivityRecordsTableReferences
                          ._trackPointRecordsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActivityRecordsTableReferences(
                            db,
                            table,
                            p0,
                          ).trackPointRecordsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ActivityRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityRecordsTable,
      ActivityRecord,
      $$ActivityRecordsTableFilterComposer,
      $$ActivityRecordsTableOrderingComposer,
      $$ActivityRecordsTableAnnotationComposer,
      $$ActivityRecordsTableCreateCompanionBuilder,
      $$ActivityRecordsTableUpdateCompanionBuilder,
      (ActivityRecord, $$ActivityRecordsTableReferences),
      ActivityRecord,
      PrefetchHooks Function({bool trackPointRecordsRefs})
    >;
typedef $$TrackPointRecordsTableCreateCompanionBuilder =
    TrackPointRecordsCompanion Function({
      Value<int> id,
      required int activityId,
      required int segmentIndex,
      required double latitude,
      required double longitude,
      required double accuracyMeters,
      required DateTime recordedAt,
    });
typedef $$TrackPointRecordsTableUpdateCompanionBuilder =
    TrackPointRecordsCompanion Function({
      Value<int> id,
      Value<int> activityId,
      Value<int> segmentIndex,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> accuracyMeters,
      Value<DateTime> recordedAt,
    });

final class $$TrackPointRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TrackPointRecordsTable,
          TrackPointRecord
        > {
  $$TrackPointRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivityRecordsTable _activityIdTable(_$AppDatabase db) => db
      .activityRecords
      .createAlias('track_point_records__activity_id__activity_records__id');

  $$ActivityRecordsTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<int>('activity_id')!;

    final manager = $$ActivityRecordsTableTableManager(
      $_db,
      $_db.activityRecords,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TrackPointRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $TrackPointRecordsTable> {
  $$TrackPointRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivityRecordsTableFilterComposer get activityId {
    final $$ActivityRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activityRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityRecordsTableFilterComposer(
            $db: $db,
            $table: $db.activityRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackPointRecordsTable> {
  $$TrackPointRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivityRecordsTableOrderingComposer get activityId {
    final $$ActivityRecordsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activityRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityRecordsTableOrderingComposer(
            $db: $db,
            $table: $db.activityRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackPointRecordsTable> {
  $$TrackPointRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$ActivityRecordsTableAnnotationComposer get activityId {
    final $$ActivityRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activityRecords,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.activityRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TrackPointRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackPointRecordsTable,
          TrackPointRecord,
          $$TrackPointRecordsTableFilterComposer,
          $$TrackPointRecordsTableOrderingComposer,
          $$TrackPointRecordsTableAnnotationComposer,
          $$TrackPointRecordsTableCreateCompanionBuilder,
          $$TrackPointRecordsTableUpdateCompanionBuilder,
          (TrackPointRecord, $$TrackPointRecordsTableReferences),
          TrackPointRecord,
          PrefetchHooks Function({bool activityId})
        > {
  $$TrackPointRecordsTableTableManager(
    _$AppDatabase db,
    $TrackPointRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackPointRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackPointRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackPointRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> activityId = const Value.absent(),
                Value<int> segmentIndex = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
              }) => TrackPointRecordsCompanion(
                id: id,
                activityId: activityId,
                segmentIndex: segmentIndex,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int activityId,
                required int segmentIndex,
                required double latitude,
                required double longitude,
                required double accuracyMeters,
                required DateTime recordedAt,
              }) => TrackPointRecordsCompanion.insert(
                id: id,
                activityId: activityId,
                segmentIndex: segmentIndex,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TrackPointRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.activityId,
                                referencedTable:
                                    $$TrackPointRecordsTableReferences
                                        ._activityIdTable(db),
                                referencedColumn:
                                    $$TrackPointRecordsTableReferences
                                        ._activityIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TrackPointRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackPointRecordsTable,
      TrackPointRecord,
      $$TrackPointRecordsTableFilterComposer,
      $$TrackPointRecordsTableOrderingComposer,
      $$TrackPointRecordsTableAnnotationComposer,
      $$TrackPointRecordsTableCreateCompanionBuilder,
      $$TrackPointRecordsTableUpdateCompanionBuilder,
      (TrackPointRecord, $$TrackPointRecordsTableReferences),
      TrackPointRecord,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$DraftSessionsTableCreateCompanionBuilder =
    DraftSessionsCompanion Function({
      required String userId,
      required ActivityType type,
      required DateTime startedAt,
      Value<int> elapsedSeconds,
      Value<int> rowid,
    });
typedef $$DraftSessionsTableUpdateCompanionBuilder =
    DraftSessionsCompanion Function({
      Value<String> userId,
      Value<ActivityType> type,
      Value<DateTime> startedAt,
      Value<int> elapsedSeconds,
      Value<int> rowid,
    });

final class $$DraftSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $DraftSessionsTable, DraftSession> {
  $$DraftSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$DraftPointsTable, List<DraftPoint>>
  _draftPointsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.draftPoints,
    aliasName: 'draft_sessions__user_id__draft_points__user_id',
  );

  $$DraftPointsTableProcessedTableManager get draftPointsRefs {
    final manager = $$DraftPointsTableTableManager($_db, $_db.draftPoints)
        .filter(
          (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_draftPointsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DraftSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $DraftSessionsTable> {
  $$DraftSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ActivityType, ActivityType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> draftPointsRefs(
    Expression<bool> Function($$DraftPointsTableFilterComposer f) f,
  ) {
    final $$DraftPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.draftPoints,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPointsTableFilterComposer(
            $db: $db,
            $table: $db.draftPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DraftSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftSessionsTable> {
  $$DraftSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DraftSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftSessionsTable> {
  $$DraftSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get elapsedSeconds => $composableBuilder(
    column: $table.elapsedSeconds,
    builder: (column) => column,
  );

  Expression<T> draftPointsRefs<T extends Object>(
    Expression<T> Function($$DraftPointsTableAnnotationComposer a) f,
  ) {
    final $$DraftPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.draftPoints,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.draftPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DraftSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DraftSessionsTable,
          DraftSession,
          $$DraftSessionsTableFilterComposer,
          $$DraftSessionsTableOrderingComposer,
          $$DraftSessionsTableAnnotationComposer,
          $$DraftSessionsTableCreateCompanionBuilder,
          $$DraftSessionsTableUpdateCompanionBuilder,
          (DraftSession, $$DraftSessionsTableReferences),
          DraftSession,
          PrefetchHooks Function({bool draftPointsRefs})
        > {
  $$DraftSessionsTableTableManager(_$AppDatabase db, $DraftSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<ActivityType> type = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DraftSessionsCompanion(
                userId: userId,
                type: type,
                startedAt: startedAt,
                elapsedSeconds: elapsedSeconds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required ActivityType type,
                required DateTime startedAt,
                Value<int> elapsedSeconds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DraftSessionsCompanion.insert(
                userId: userId,
                type: type,
                startedAt: startedAt,
                elapsedSeconds: elapsedSeconds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DraftSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({draftPointsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (draftPointsRefs) db.draftPoints],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (draftPointsRefs)
                    await $_getPrefetchedData<
                      DraftSession,
                      $DraftSessionsTable,
                      DraftPoint
                    >(
                      currentTable: table,
                      referencedTable: $$DraftSessionsTableReferences
                          ._draftPointsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DraftSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).draftPointsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.userId),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DraftSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DraftSessionsTable,
      DraftSession,
      $$DraftSessionsTableFilterComposer,
      $$DraftSessionsTableOrderingComposer,
      $$DraftSessionsTableAnnotationComposer,
      $$DraftSessionsTableCreateCompanionBuilder,
      $$DraftSessionsTableUpdateCompanionBuilder,
      (DraftSession, $$DraftSessionsTableReferences),
      DraftSession,
      PrefetchHooks Function({bool draftPointsRefs})
    >;
typedef $$DraftPointsTableCreateCompanionBuilder =
    DraftPointsCompanion Function({
      Value<int> id,
      required String userId,
      required int segmentIndex,
      required double latitude,
      required double longitude,
      required double accuracyMeters,
      required DateTime recordedAt,
    });
typedef $$DraftPointsTableUpdateCompanionBuilder =
    DraftPointsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<int> segmentIndex,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> accuracyMeters,
      Value<DateTime> recordedAt,
    });

final class $$DraftPointsTableReferences
    extends BaseReferences<_$AppDatabase, $DraftPointsTable, DraftPoint> {
  $$DraftPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DraftSessionsTable _userIdTable(_$AppDatabase db) => db.draftSessions
      .createAlias('draft_points__user_id__draft_sessions__user_id');

  $$DraftSessionsTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$DraftSessionsTableTableManager(
      $_db,
      $_db.draftSessions,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DraftPointsTableFilterComposer
    extends Composer<_$AppDatabase, $DraftPointsTable> {
  $$DraftPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DraftSessionsTableFilterComposer get userId {
    final $$DraftSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.draftSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftSessionsTableFilterComposer(
            $db: $db,
            $table: $db.draftSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $DraftPointsTable> {
  $$DraftPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DraftSessionsTableOrderingComposer get userId {
    final $$DraftSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.draftSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.draftSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DraftPointsTable> {
  $$DraftPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get segmentIndex => $composableBuilder(
    column: $table.segmentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  $$DraftSessionsTableAnnotationComposer get userId {
    final $$DraftSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.draftSessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DraftSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.draftSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DraftPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DraftPointsTable,
          DraftPoint,
          $$DraftPointsTableFilterComposer,
          $$DraftPointsTableOrderingComposer,
          $$DraftPointsTableAnnotationComposer,
          $$DraftPointsTableCreateCompanionBuilder,
          $$DraftPointsTableUpdateCompanionBuilder,
          (DraftPoint, $$DraftPointsTableReferences),
          DraftPoint,
          PrefetchHooks Function({bool userId})
        > {
  $$DraftPointsTableTableManager(_$AppDatabase db, $DraftPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DraftPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DraftPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DraftPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<int> segmentIndex = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
              }) => DraftPointsCompanion(
                id: id,
                userId: userId,
                segmentIndex: segmentIndex,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                required int segmentIndex,
                required double latitude,
                required double longitude,
                required double accuracyMeters,
                required DateTime recordedAt,
              }) => DraftPointsCompanion.insert(
                id: id,
                userId: userId,
                segmentIndex: segmentIndex,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DraftPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$DraftPointsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$DraftPointsTableReferences
                                    ._userIdTable(db)
                                    .userId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DraftPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DraftPointsTable,
      DraftPoint,
      $$DraftPointsTableFilterComposer,
      $$DraftPointsTableOrderingComposer,
      $$DraftPointsTableAnnotationComposer,
      $$DraftPointsTableCreateCompanionBuilder,
      $$DraftPointsTableUpdateCompanionBuilder,
      (DraftPoint, $$DraftPointsTableReferences),
      DraftPoint,
      PrefetchHooks Function({bool userId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ActivityRecordsTableTableManager get activityRecords =>
      $$ActivityRecordsTableTableManager(_db, _db.activityRecords);
  $$TrackPointRecordsTableTableManager get trackPointRecords =>
      $$TrackPointRecordsTableTableManager(_db, _db.trackPointRecords);
  $$DraftSessionsTableTableManager get draftSessions =>
      $$DraftSessionsTableTableManager(_db, _db.draftSessions);
  $$DraftPointsTableTableManager get draftPoints =>
      $$DraftPointsTableTableManager(_db, _db.draftPoints);
}
