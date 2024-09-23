// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _hashPasswordMeta =
      const VerificationMeta('hashPassword');
  @override
  late final GeneratedColumn<String> hashPassword = GeneratedColumn<String>(
      'hash_password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createTimeMeta =
      const VerificationMeta('createTime');
  @override
  late final GeneratedColumn<DateTime> createTime = GeneratedColumn<DateTime>(
      'create_time', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastLoginMeta =
      const VerificationMeta('lastLogin');
  @override
  late final GeneratedColumn<DateTime> lastLogin = GeneratedColumn<DateTime>(
      'last_login', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _emailVerifiedMeta =
      const VerificationMeta('emailVerified');
  @override
  late final GeneratedColumn<bool> emailVerified = GeneratedColumn<bool>(
      'email_verified', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("email_verified" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        hashPassword,
        firstName,
        lastName,
        createTime,
        lastLogin,
        emailVerified
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('hash_password')) {
      context.handle(
          _hashPasswordMeta,
          hashPassword.isAcceptableOrUnknown(
              data['hash_password']!, _hashPasswordMeta));
    } else if (isInserting) {
      context.missing(_hashPasswordMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('create_time')) {
      context.handle(
          _createTimeMeta,
          createTime.isAcceptableOrUnknown(
              data['create_time']!, _createTimeMeta));
    } else if (isInserting) {
      context.missing(_createTimeMeta);
    }
    if (data.containsKey('last_login')) {
      context.handle(_lastLoginMeta,
          lastLogin.isAcceptableOrUnknown(data['last_login']!, _lastLoginMeta));
    }
    if (data.containsKey('email_verified')) {
      context.handle(
          _emailVerifiedMeta,
          emailVerified.isAcceptableOrUnknown(
              data['email_verified']!, _emailVerifiedMeta));
    } else if (isInserting) {
      context.missing(_emailVerifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      hashPassword: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}hash_password'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      createTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}create_time'])!,
      lastLogin: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login']),
      emailVerified: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}email_verified'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String hashPassword;
  final String firstName;
  final String lastName;
  final DateTime createTime;
  final DateTime? lastLogin;
  final bool emailVerified;
  const User(
      {required this.id,
      required this.email,
      required this.hashPassword,
      required this.firstName,
      required this.lastName,
      required this.createTime,
      this.lastLogin,
      required this.emailVerified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['hash_password'] = Variable<String>(hashPassword);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['create_time'] = Variable<DateTime>(createTime);
    if (!nullToAbsent || lastLogin != null) {
      map['last_login'] = Variable<DateTime>(lastLogin);
    }
    map['email_verified'] = Variable<bool>(emailVerified);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      hashPassword: Value(hashPassword),
      firstName: Value(firstName),
      lastName: Value(lastName),
      createTime: Value(createTime),
      lastLogin: lastLogin == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLogin),
      emailVerified: Value(emailVerified),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      hashPassword: serializer.fromJson<String>(json['hashPassword']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      createTime: serializer.fromJson<DateTime>(json['createTime']),
      lastLogin: serializer.fromJson<DateTime?>(json['lastLogin']),
      emailVerified: serializer.fromJson<bool>(json['emailVerified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'hashPassword': serializer.toJson<String>(hashPassword),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'createTime': serializer.toJson<DateTime>(createTime),
      'lastLogin': serializer.toJson<DateTime?>(lastLogin),
      'emailVerified': serializer.toJson<bool>(emailVerified),
    };
  }

  User copyWith(
          {int? id,
          String? email,
          String? hashPassword,
          String? firstName,
          String? lastName,
          DateTime? createTime,
          Value<DateTime?> lastLogin = const Value.absent(),
          bool? emailVerified}) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        hashPassword: hashPassword ?? this.hashPassword,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        createTime: createTime ?? this.createTime,
        lastLogin: lastLogin.present ? lastLogin.value : this.lastLogin,
        emailVerified: emailVerified ?? this.emailVerified,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      hashPassword: data.hashPassword.present
          ? data.hashPassword.value
          : this.hashPassword,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      createTime:
          data.createTime.present ? data.createTime.value : this.createTime,
      lastLogin: data.lastLogin.present ? data.lastLogin.value : this.lastLogin,
      emailVerified: data.emailVerified.present
          ? data.emailVerified.value
          : this.emailVerified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('hashPassword: $hashPassword, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('createTime: $createTime, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('emailVerified: $emailVerified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, hashPassword, firstName, lastName,
      createTime, lastLogin, emailVerified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.hashPassword == this.hashPassword &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.createTime == this.createTime &&
          other.lastLogin == this.lastLogin &&
          other.emailVerified == this.emailVerified);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> hashPassword;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<DateTime> createTime;
  final Value<DateTime?> lastLogin;
  final Value<bool> emailVerified;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.hashPassword = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.createTime = const Value.absent(),
    this.lastLogin = const Value.absent(),
    this.emailVerified = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String hashPassword,
    required String firstName,
    required String lastName,
    required DateTime createTime,
    this.lastLogin = const Value.absent(),
    required bool emailVerified,
  })  : email = Value(email),
        hashPassword = Value(hashPassword),
        firstName = Value(firstName),
        lastName = Value(lastName),
        createTime = Value(createTime),
        emailVerified = Value(emailVerified);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? hashPassword,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<DateTime>? createTime,
    Expression<DateTime>? lastLogin,
    Expression<bool>? emailVerified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (hashPassword != null) 'hash_password': hashPassword,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (createTime != null) 'create_time': createTime,
      if (lastLogin != null) 'last_login': lastLogin,
      if (emailVerified != null) 'email_verified': emailVerified,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String>? hashPassword,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<DateTime>? createTime,
      Value<DateTime?>? lastLogin,
      Value<bool>? emailVerified}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      hashPassword: hashPassword ?? this.hashPassword,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      createTime: createTime ?? this.createTime,
      lastLogin: lastLogin ?? this.lastLogin,
      emailVerified: emailVerified ?? this.emailVerified,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (hashPassword.present) {
      map['hash_password'] = Variable<String>(hashPassword.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (createTime.present) {
      map['create_time'] = Variable<DateTime>(createTime.value);
    }
    if (lastLogin.present) {
      map['last_login'] = Variable<DateTime>(lastLogin.value);
    }
    if (emailVerified.present) {
      map['email_verified'] = Variable<bool>(emailVerified.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('hashPassword: $hashPassword, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('createTime: $createTime, ')
          ..write('lastLogin: $lastLogin, ')
          ..write('emailVerified: $emailVerified')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String email,
  required String hashPassword,
  required String firstName,
  required String lastName,
  required DateTime createTime,
  Value<DateTime?> lastLogin,
  required bool emailVerified,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> email,
  Value<String> hashPassword,
  Value<String> firstName,
  Value<String> lastName,
  Value<DateTime> createTime,
  Value<DateTime?> lastLogin,
  Value<bool> emailVerified,
});

class $$UsersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get hashPassword => $state.composableBuilder(
      column: $state.table.hashPassword,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get firstName => $state.composableBuilder(
      column: $state.table.firstName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get lastName => $state.composableBuilder(
      column: $state.table.lastName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createTime => $state.composableBuilder(
      column: $state.table.createTime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastLogin => $state.composableBuilder(
      column: $state.table.lastLogin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get emailVerified => $state.composableBuilder(
      column: $state.table.emailVerified,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$UsersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get email => $state.composableBuilder(
      column: $state.table.email,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get hashPassword => $state.composableBuilder(
      column: $state.table.hashPassword,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get firstName => $state.composableBuilder(
      column: $state.table.firstName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get lastName => $state.composableBuilder(
      column: $state.table.lastName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createTime => $state.composableBuilder(
      column: $state.table.createTime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastLogin => $state.composableBuilder(
      column: $state.table.lastLogin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get emailVerified => $state.composableBuilder(
      column: $state.table.emailVerified,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$UsersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$UsersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> hashPassword = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<DateTime> createTime = const Value.absent(),
            Value<DateTime?> lastLogin = const Value.absent(),
            Value<bool> emailVerified = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            hashPassword: hashPassword,
            firstName: firstName,
            lastName: lastName,
            createTime: createTime,
            lastLogin: lastLogin,
            emailVerified: emailVerified,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String email,
            required String hashPassword,
            required String firstName,
            required String lastName,
            required DateTime createTime,
            Value<DateTime?> lastLogin = const Value.absent(),
            required bool emailVerified,
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            hashPassword: hashPassword,
            firstName: firstName,
            lastName: lastName,
            createTime: createTime,
            lastLogin: lastLogin,
            emailVerified: emailVerified,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
}
