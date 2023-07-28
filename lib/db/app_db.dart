import 'dart:io';

import 'package:audio_player_list_with_drift/entity/audio_entity.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'app_db.g.dart';

LazyDatabase _openConnection(){

  return LazyDatabase(() async {

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'audio.sqlite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [AudioEntity])
class AppDb extends _$AppDb{

  AppDb() : super (_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<AudioEntityData>> getAudioList() async{
    return await select(audioEntity).get();
  }

  Future<AudioEntityData> getAudio(int audioId) async{
    return await (select(audioEntity)..where((tbl) => tbl.audioId.equals(audioId))).getSingle();
  }

  Future<bool> updateAudio(AudioEntityCompanion entity) async{
    return await update(audioEntity).replace(entity);
  }

  Future<int> insertAudio(AudioEntityCompanion entity) async{
    return await into(audioEntity).insert(entity);
  }

  Future<int> deleteAudio(int audioId) async{
    return await (delete(audioEntity)..where((tbl) => tbl.audioId.equals(audioId))).go();
  }
}