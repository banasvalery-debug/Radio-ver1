class EqualizerOption {
  final int id;
  final String name;

  const EqualizerOption({
    required this.id,
    required this.name,
  });

  @override
  toString() => {"id": id, "name": name}.toString();
}
