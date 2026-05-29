class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  int? idade;
  double? peso;
  double? altura;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.idade,
    this.peso,
    this.altura,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) => Usuario(
    id: map['id'] as int?,
    nome: map['nome'] as String? ?? '',
    email: map['email'] as String? ?? '',
    senha: map['senha'] as String? ?? '',
    idade: map['idade'] as int?,
    peso: map['peso'] == null ? null : (map['peso'] as num).toDouble(),
    altura: map['altura'] == null ? null : (map['altura'] as num).toDouble(),
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'nome': nome,
    'email': email,
    'senha': senha,
    'idade': idade,
    'peso': peso,
    'altura': altura,
  };
}
