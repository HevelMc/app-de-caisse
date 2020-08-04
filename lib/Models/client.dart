class Client {
  int id;
  String firstName;
  String lastName;

  Client(String firstName, String lastName) {
    this.firstName = capitalize(firstName);
    this.lastName = lastName.toUpperCase();
  }

  String getName() {
    return this.firstName + " " + this.lastName;
  }

  String getNameReversed() {
    return this.lastName + " " + this.firstName;
  }
}

String capitalize(String string) {
  if (string == null) throw ArgumentError("string: $string");
  if (string.isEmpty) return string;
  List<String> split = string.split("");
  List<String> newSplit = new List<String>();
  String previous = " ";
  split.forEach((element) {
    if (previous == " ")
      newSplit.add(element.toUpperCase());
    else
      newSplit.add(element);
    previous = element;
  });
  return newSplit.join();
}
