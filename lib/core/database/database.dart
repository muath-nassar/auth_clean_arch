// File: lib/core/db/database.dart
import 'dart:io';
import 'package:auth_clean_arch/core/database/tables/users.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';


@DriftDatabase(tables: [Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<User> getUser(int id) => (select(users)..where((u) => u.id.equals(id))).getSingle();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(UsersCompanion user) => update(users).replace(user);

  Future<int> deleteUser(int id) => (delete(users)..where((u) => u.id.equals(id))).go();

  Future<User?> getUserByEmail(String email) =>
      (select(users)..where((u) => u.email.equals(email)))
          .getSingleOrNull();

  Future<int> updateLastLogin(int id, DateTime lastLogin) =>
      (update(users)..where((u) => u.id.equals(id)))
          .write(UsersCompanion(lastLogin: Value(lastLogin)));

  Future<int> setEmailVerified(int id, bool verified) =>
      (update(users)..where((u) => u.id.equals(id)))
          .write(UsersCompanion(emailVerified: Value(verified)));
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'auth_db.sqlite'));
    return NativeDatabase(file);
  });
}