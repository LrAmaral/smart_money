enum ModalInputType {
  text(type: "teste"),
  number(type: "number"),
  date(type: "date"),
  password(type: "password");

  const ModalInputType({required this.type});

  final String type;
}
