import 'package:logger/logger.dart';

/// Create a [PrefixPrinter] with just one prefix for all log types.
LogPrinter createSimplePrefixPrinter(
  LogPrinter realPrinter, {
  required String prefix,
}) =>
    PrefixPrinter(
      realPrinter,
      debug: prefix,
      error: prefix,
      info: prefix,
      verbose: prefix,
      warning: prefix,
      wtf: prefix,
    );
