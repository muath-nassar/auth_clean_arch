import 'dart:io';

String fixture(String name) =>
    File('/Users/muathnassar/Desktop/auth_clean_arch/test/fixtures/$name')
        .readAsStringSync();