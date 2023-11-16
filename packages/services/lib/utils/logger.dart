import 'dart:developer';

import 'package:flutter/foundation.dart';

///This class is for all the log in the console related methods

class LogMaster {
  ///this constructor is for ensuring Nobody can create any object of this class

  LogMaster._();

  ///this works similar to log, one advantage you don't need to pass String always here

  ///you can send anything, it will call .toString() and log what you want

  static info(dynamic data, {required String tag, int stackTraceLevel = 1, bool printLeftLine = true}) {
    final stackTraces = StackTrace.current.toString().split('\n');

    final lines = '$data'.split('\n');

    final body = printLeftLine ? '│${lines.join('\n│')}' : '${lines.join('\n')}';

    final List<String> stackTracesLines =
        stackTraceLevel > 1 ? stackTraces.sublist(1, stackTraceLevel + 1) : [stackTraces[stackTraceLevel]];

    final stackTracesBody = '│${stackTracesLines.join('\n│')}';

    String output = '\n'
        '┌──[$tag]──────────────────────────────────────────────────────────────────────────────────────────\n'
        '$body'
        '\n├┄┄[STACK TRACE]┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄\n'
        '$stackTracesBody\n'
        '└─────────────────────────────────────────────────────────────────────────────────────────────────────\n\x1B[0m';

    // if (!kIsWeb) log('$output', name: 'REACTIV LOGGER', level: 0, time: DateTime.now(), sequenceNumber: 10);

    // debugPrint(output, wrapWidth: 100);

    if (kDebugMode) print(output);

    // print(StackTrace.current);

    // log(stackTracesBody);
  }

  static infoWithoutStackTrace(dynamic data, {required String tag, bool printLeftLine = true}) {
    final lines = '$data'.split('\n');

    final body = printLeftLine ? '│${lines.join('\n│')}' : '${lines.join('\n')}';

    String output = '\n'
        '┌─────────────────────────────────────────────────────────────────────────────────────────────────────\n'
        '$body\n'
        '└─────────────────────────────────────────────────────────────────────────────────────────────────────\n';

    if (!kIsWeb) log('$output', name: tag, level: 0);
  }

  static prodInfo(dynamic data, {required String tag}) {
    if (!kIsWeb) print('[$tag] $data');
  }

  static infoJson(dynamic data) {
    String response = prettyJson(data);

    LogMaster.info(response, tag: 'RESPONSE JSON', stackTraceLevel: 4);
  }

  static String prettyJson(dynamic data) {
    String response = '';

    int tabCount = 0;

    const String tab = '\t';

    printMap(dynamic data, {bool addSuffixComma = false, bool addSingleTab = false}) async {
      if (!kIsWeb && kDebugMode) {
        if (data is Map<String, dynamic>) {
          response = '$response${addSingleTab ? '' : tab * tabCount}{';

          tabCount++;

          for (int mapKeyIndex = 0; mapKeyIndex < data.keys.length; mapKeyIndex++) {
            final key = data.keys.toList()[mapKeyIndex];

            final isLastKey = mapKeyIndex == data.keys.toList().length - 1;

            if (data[key].runtimeType.toString() == 'List<dynamic>') {
              response = '$response \n${tab * tabCount}"$key" : [';

              tabCount++;

              for (var listIndex = 0; listIndex < (data[key] as List<dynamic>).length; listIndex++) {
                final element = data[key][listIndex];

                final isLastListElement = listIndex == data[key].length - 1;

                response = '$response \n';

                printMap(element);

                response = '$response${isLastListElement ? '' : ','}';
              }

              tabCount--;

              response = '$response${tab * tabCount} \n${tab * tabCount}]${isLastKey ? '' : ','}';
            } else {
              if (data[key].runtimeType.toString() == '_Map<String, dynamic>') {
              response = '$response \n${tab * tabCount}"$key" : ';

              printMap(data[key], addSuffixComma: !isLastKey, addSingleTab: true);
            } else if (data[key].runtimeType.toString() == 'String') {
              response =
                  '$response \n${tab * tabCount}"$key" : "${data[key]}"${isLastKey ? '' : ','}';
            } else {
              response =
                  '$response \n${tab * tabCount}"$key" : ${data[key]}${isLastKey ? '' : ','}';
            }
            }
          }

          tabCount--;

          response = '$response${tab * tabCount} \n${tab * tabCount}}${addSuffixComma ? ',' : ''}';
        } else {
          if (data.runtimeType.toString() == 'String') {
            response = '$response ${tab * tabCount}"$data"';
          } else {
            response = '$response ${tab * tabCount}$data';
          }
        }
      }
    }

    printMap(data);

    return response;
  }
}
