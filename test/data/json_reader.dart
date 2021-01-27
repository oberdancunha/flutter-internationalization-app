import 'dart:convert';
import 'dart:io';

Map<String, dynamic> jsonReader(String file) => json.decode(
      File('test/data/$file').readAsStringSync(),
    ) as Map<String, dynamic>;
