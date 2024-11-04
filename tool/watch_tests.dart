import 'dart:io';
import 'package:watcher/watcher.dart';

/// 日志级别枚举
enum LogLevel { info, warning, error }

/// 带颜色的日志输出
void log(String message, {LogLevel level = LogLevel.info}) {
  final now = DateTime.now().toString().split('.').first;
  final prefix = '[$now]';

  switch (level) {
    case LogLevel.info:
      stderr.writeln('\x1B[32m$prefix INFO: $message\x1B[0m'); // 绿色
    case LogLevel.warning:
      stderr.writeln('\x1B[33m$prefix WARN: $message\x1B[0m'); // 黄色
    case LogLevel.error:
      stderr.writeln('\x1B[31m$prefix ERROR: $message\x1B[0m'); // 红色
  }
}

void main() {
  // 监视 lib 和 test 目录
  final libWatcher = DirectoryWatcher('lib');
  final testWatcher = DirectoryWatcher('test');

  log('Starting test watcher...');
  log('Watching directories: lib/, test/', level: LogLevel.info);

  void runTests() {
    log('Running tests...', level: LogLevel.info);
    final result = Process.runSync('flutter', ['test'], runInShell: true);

    if (result.exitCode != 0) {
      log('Tests failed!', level: LogLevel.error);
      stderr.write(result.stderr);
    } else {
      log('Tests passed successfully!', level: LogLevel.info);
    }
  }

  // 初次运行测试
  runTests();

  // 监听文件变化
  libWatcher.events.listen((event) {
    log('File changed: ${event.path}', level: LogLevel.info);
    log('Change type: ${event.type}', level: LogLevel.info);
    runTests();
  });

  testWatcher.events.listen((event) {
    log('File changed: ${event.path}', level: LogLevel.info);
    log('Change type: ${event.type}', level: LogLevel.info);
    runTests();
  });
}
