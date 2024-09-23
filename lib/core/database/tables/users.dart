import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get hashPassword => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get lastLogin => dateTime().nullable()();
  BoolColumn get emailVerified => boolean()();
}