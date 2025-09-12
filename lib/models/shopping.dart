//"shopping" para compras permanentes de produtos
//'Não foi adicionado nenhum produto ate agora'
class Shopping {
  final String id;
  final String name;

  const Shopping({
    required this.id,
    required this.name,
  });

  Map<String, String> get toMap {
    return {
      "id": id,
      "name": name,
    };
  }
}
