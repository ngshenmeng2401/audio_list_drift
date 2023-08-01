import 'package:drift/drift.dart';

@DataClassName('AudioCourse')
class AudioEntity extends Table{

  IntColumn get audioId => integer().autoIncrement()();
  TextColumn get audioName => text().nullable()();
  TextColumn get audioURL => text().nullable()();
  IntColumn get totalLength => integer().nullable()();
  IntColumn get playPosition => integer().nullable()();
  BoolColumn get isPlaying => boolean().nullable()();
}