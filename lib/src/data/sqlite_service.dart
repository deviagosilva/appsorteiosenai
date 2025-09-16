import 'package:sqflite/sqflite.dart';

class SqliteService {
  Database? database;

  Future<Database> open() async {
    const version = 2;
    if (database?.isOpen ?? false) {
      return database!;
    }
    var path = await getDatabasesPath();
    database = await openDatabase(
      '$path/app-sorteio-database',
      version: version,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE Turma (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            codigo TEXT NOT NULL UNIQUE,
            apelido TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE Aluno (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            nome TEXT NOT NULL, 
            matricula TEXT NOT NULL UNIQUE, 
            idTurma INTEGER NOT NULL,
            FOREIGN KEY (idTurma) REFERENCES Turma(id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE Atividade (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            descricao TEXT, 
            data TEXT NOT NULL, 
            sorteado INTEGER NOT NULL, 
            qntGrupo INTEGER NOT NULL 
          )
        ''');

        await db.execute('''
          CREATE TABLE Sorteio (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            idAluno INTEGER NOT NULL,
            idAtividade INTEGER NOT NULL,
            numeroGrupo INTEGER NOT NULL,
            FOREIGN KEY (idAluno) REFERENCES Aluno(id) ON DELETE CASCADE,
            FOREIGN KEY (idAtividade) REFERENCES Atividade(id) ON DELETE CASCADE
          );
        ''');
      },
    );
    return database!;
  }

  Future<void> close(Database db) async {
    await db.close();
  }

  Future<void> delete(Database db) async {
    await deleteDatabase(db.path);
  }
}
