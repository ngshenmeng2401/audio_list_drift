// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $AudioEntityTable extends AudioEntity
    with TableInfo<$AudioEntityTable, AudioEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _audioIdMeta =
      const VerificationMeta('audioId');
  @override
  late final GeneratedColumn<int> audioId = GeneratedColumn<int>(
      'audio_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _audioNameMeta =
      const VerificationMeta('audioName');
  @override
  late final GeneratedColumn<String> audioName = GeneratedColumn<String>(
      'audio_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioURLMeta =
      const VerificationMeta('audioURL');
  @override
  late final GeneratedColumn<String> audioURL = GeneratedColumn<String>(
      'audio_u_r_l', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalLengthMeta =
      const VerificationMeta('totalLength');
  @override
  late final GeneratedColumn<int> totalLength = GeneratedColumn<int>(
      'total_length', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playPositionMeta =
      const VerificationMeta('playPosition');
  @override
  late final GeneratedColumn<int> playPosition = GeneratedColumn<int>(
      'play_position', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [audioId, audioName, audioURL, totalLength, playPosition];
  @override
  String get aliasedName => _alias ?? 'audio_entity';
  @override
  String get actualTableName => 'audio_entity';
  @override
  VerificationContext validateIntegrity(Insertable<AudioEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('audio_id')) {
      context.handle(_audioIdMeta,
          audioId.isAcceptableOrUnknown(data['audio_id']!, _audioIdMeta));
    }
    if (data.containsKey('audio_name')) {
      context.handle(_audioNameMeta,
          audioName.isAcceptableOrUnknown(data['audio_name']!, _audioNameMeta));
    } else if (isInserting) {
      context.missing(_audioNameMeta);
    }
    if (data.containsKey('audio_u_r_l')) {
      context.handle(_audioURLMeta,
          audioURL.isAcceptableOrUnknown(data['audio_u_r_l']!, _audioURLMeta));
    } else if (isInserting) {
      context.missing(_audioURLMeta);
    }
    if (data.containsKey('total_length')) {
      context.handle(
          _totalLengthMeta,
          totalLength.isAcceptableOrUnknown(
              data['total_length']!, _totalLengthMeta));
    }
    if (data.containsKey('play_position')) {
      context.handle(
          _playPositionMeta,
          playPosition.isAcceptableOrUnknown(
              data['play_position']!, _playPositionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {audioId};
  @override
  AudioEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioEntityData(
      audioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}audio_id'])!,
      audioName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_name'])!,
      audioURL: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_u_r_l'])!,
      totalLength: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_length']),
      playPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}play_position']),
    );
  }

  @override
  $AudioEntityTable createAlias(String alias) {
    return $AudioEntityTable(attachedDatabase, alias);
  }
}

class AudioEntityData extends DataClass implements Insertable<AudioEntityData> {
  final int audioId;
  final String audioName;
  final String audioURL;
  final int? totalLength;
  final int? playPosition;
  const AudioEntityData(
      {required this.audioId,
      required this.audioName,
      required this.audioURL,
      this.totalLength,
      this.playPosition});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['audio_id'] = Variable<int>(audioId);
    map['audio_name'] = Variable<String>(audioName);
    map['audio_u_r_l'] = Variable<String>(audioURL);
    if (!nullToAbsent || totalLength != null) {
      map['total_length'] = Variable<int>(totalLength);
    }
    if (!nullToAbsent || playPosition != null) {
      map['play_position'] = Variable<int>(playPosition);
    }
    return map;
  }

  AudioEntityCompanion toCompanion(bool nullToAbsent) {
    return AudioEntityCompanion(
      audioId: Value(audioId),
      audioName: Value(audioName),
      audioURL: Value(audioURL),
      totalLength: totalLength == null && nullToAbsent
          ? const Value.absent()
          : Value(totalLength),
      playPosition: playPosition == null && nullToAbsent
          ? const Value.absent()
          : Value(playPosition),
    );
  }

  factory AudioEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioEntityData(
      audioId: serializer.fromJson<int>(json['audioId']),
      audioName: serializer.fromJson<String>(json['audioName']),
      audioURL: serializer.fromJson<String>(json['audioURL']),
      totalLength: serializer.fromJson<int?>(json['totalLength']),
      playPosition: serializer.fromJson<int?>(json['playPosition']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'audioId': serializer.toJson<int>(audioId),
      'audioName': serializer.toJson<String>(audioName),
      'audioURL': serializer.toJson<String>(audioURL),
      'totalLength': serializer.toJson<int?>(totalLength),
      'playPosition': serializer.toJson<int?>(playPosition),
    };
  }

  AudioEntityData copyWith(
          {int? audioId,
          String? audioName,
          String? audioURL,
          Value<int?> totalLength = const Value.absent(),
          Value<int?> playPosition = const Value.absent()}) =>
      AudioEntityData(
        audioId: audioId ?? this.audioId,
        audioName: audioName ?? this.audioName,
        audioURL: audioURL ?? this.audioURL,
        totalLength: totalLength.present ? totalLength.value : this.totalLength,
        playPosition:
            playPosition.present ? playPosition.value : this.playPosition,
      );
  @override
  String toString() {
    return (StringBuffer('AudioEntityData(')
          ..write('audioId: $audioId, ')
          ..write('audioName: $audioName, ')
          ..write('audioURL: $audioURL, ')
          ..write('totalLength: $totalLength, ')
          ..write('playPosition: $playPosition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(audioId, audioName, audioURL, totalLength, playPosition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioEntityData &&
          other.audioId == this.audioId &&
          other.audioName == this.audioName &&
          other.audioURL == this.audioURL &&
          other.totalLength == this.totalLength &&
          other.playPosition == this.playPosition);
}

class AudioEntityCompanion extends UpdateCompanion<AudioEntityData> {
  final Value<int> audioId;
  final Value<String> audioName;
  final Value<String> audioURL;
  final Value<int?> totalLength;
  final Value<int?> playPosition;
  const AudioEntityCompanion({
    this.audioId = const Value.absent(),
    this.audioName = const Value.absent(),
    this.audioURL = const Value.absent(),
    this.totalLength = const Value.absent(),
    this.playPosition = const Value.absent(),
  });
  AudioEntityCompanion.insert({
    this.audioId = const Value.absent(),
    required String audioName,
    required String audioURL,
    this.totalLength = const Value.absent(),
    this.playPosition = const Value.absent(),
  })  : audioName = Value(audioName),
        audioURL = Value(audioURL);
  static Insertable<AudioEntityData> custom({
    Expression<int>? audioId,
    Expression<String>? audioName,
    Expression<String>? audioURL,
    Expression<int>? totalLength,
    Expression<int>? playPosition,
  }) {
    return RawValuesInsertable({
      if (audioId != null) 'audio_id': audioId,
      if (audioName != null) 'audio_name': audioName,
      if (audioURL != null) 'audio_u_r_l': audioURL,
      if (totalLength != null) 'total_length': totalLength,
      if (playPosition != null) 'play_position': playPosition,
    });
  }

  AudioEntityCompanion copyWith(
      {Value<int>? audioId,
      Value<String>? audioName,
      Value<String>? audioURL,
      Value<int?>? totalLength,
      Value<int?>? playPosition}) {
    return AudioEntityCompanion(
      audioId: audioId ?? this.audioId,
      audioName: audioName ?? this.audioName,
      audioURL: audioURL ?? this.audioURL,
      totalLength: totalLength ?? this.totalLength,
      playPosition: playPosition ?? this.playPosition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (audioId.present) {
      map['audio_id'] = Variable<int>(audioId.value);
    }
    if (audioName.present) {
      map['audio_name'] = Variable<String>(audioName.value);
    }
    if (audioURL.present) {
      map['audio_u_r_l'] = Variable<String>(audioURL.value);
    }
    if (totalLength.present) {
      map['total_length'] = Variable<int>(totalLength.value);
    }
    if (playPosition.present) {
      map['play_position'] = Variable<int>(playPosition.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioEntityCompanion(')
          ..write('audioId: $audioId, ')
          ..write('audioName: $audioName, ')
          ..write('audioURL: $audioURL, ')
          ..write('totalLength: $totalLength, ')
          ..write('playPosition: $playPosition')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final $AudioEntityTable audioEntity = $AudioEntityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [audioEntity];
}
