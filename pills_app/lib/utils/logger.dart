import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    colors: false, // Colorful log messages
    printTime: true // Should each log print contain a timestamp
    ,
  ),
);
