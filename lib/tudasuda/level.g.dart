// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      width: json['width'] as int,
      height: json['height'] as int,
      playerPos:
          Level._pointFromJson(json['playerPos'] as Map<String, dynamic>?),
      mobs: Level._mobsFromJson(json['mobs']),
      title: json['title'] as String,
      turns: json['turns'] as int? ?? 0,
      turnTime: json['turnTime'] as int? ?? 0,
      deathTimer: json['deathTimer'] as bool? ?? false,
      dialog: json['dialog'] as String? ?? '',
      boardSize: (json['boardSize'] as num?)?.toDouble() ?? 7,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'playerPos': Level._pointToJson(instance.playerPos),
      'mobs': Level._mobsToJson(instance.mobs),
      'turnTime': instance.turnTime,
      'title': instance.title,
      'dialog': instance.dialog,
      'turns': instance.turns,
      'deathTimer': instance.deathTimer,
      'boardSize': instance.boardSize,
    };
