import 'package:drift/drift.dart';

class AudioEntity extends Table{

  IntColumn get audioId => integer().autoIncrement()();
  TextColumn get audioName => text()();
  TextColumn get audioURL => text()();
  IntColumn get totalLength => integer().nullable()();
  IntColumn get playPosition => integer().nullable()();
}