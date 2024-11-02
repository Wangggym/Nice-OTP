// ignore_for_file: avoid_print

import 'dart:io';

Future<bool> runCommand(
    String executable, List<String> arguments, String errorMessage,
    {bool autoFix = false}) async {
  final result = await Process.run(executable, arguments);
  if (result.exitCode != 0) {
    print('\n❌ $errorMessage');
    print(result.stdout);
    print(result.stderr);

    if (autoFix) {
      print('\n🔧 Attempting to fix...');
      return false;
    } else {
      exit(1);
    }
  }
  print(result.stdout);
  return true;
}

Future<void> formatCode() async {
  // 先检查格式
  final checkResult = await runCommand(
    'dart',
    ['format', '--output=none', '--set-exit-if-changed', '.'],
    'Code formatting issues found.',
    autoFix: true,
  );

  // 如果检查失败，进行自动修复
  if (!checkResult) {
    // 运行格式化
    await runCommand(
      'dart',
      ['format', '.'],
      'Failed to format code.',
    );

    // 将修改添加到 git
    await runCommand(
      'git',
      ['add', '.'],
      'Failed to stage formatted files.',
    );

    print('✅ Code formatting fixed and staged.');
  }
}

Future<void> analyzeCode() async {
  // 先运行分析
  final analyzeResult = await runCommand(
    'flutter',
    ['analyze'],
    'Flutter analyze found issues.',
    autoFix: true,
  );

  if (!analyzeResult) {
    // 尝试自动修复
    await runCommand(
      'dart',
      ['fix', '--apply'],
      'Failed to apply automatic fixes.',
    );

    // 再次运行分析检查是否修复
    final checkResult = await runCommand(
      'flutter',
      ['analyze'],
      'Some issues could not be fixed automatically.',
    );

    if (checkResult) {
      // 如果修复成功，将修改添加到 git
      await runCommand(
        'git',
        ['add', '.'],
        'Failed to stage fixed files.',
      );
      print('✅ Code issues fixed and staged.');
    }
  }
}

void main() async {
  print('Running code checks...\n');

  // 检查并自动修复代码格式
  print('1/3 Checking code formatting...');
  await formatCode();

  // 运行并尝试修复 Flutter analyze
  print('\n2/3 Running Flutter analyze...');
  await analyzeCode();

  // 运行测试
  print('\n3/3 Running tests...');
  await runCommand(
    'flutter',
    ['test'],
    'Tests failed. Please fix the failing tests.',
  );

  print('\n✅ All checks passed!');
}
