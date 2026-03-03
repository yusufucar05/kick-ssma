import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),

  level: kReleaseMode ? Level.warning : Level.trace,
);