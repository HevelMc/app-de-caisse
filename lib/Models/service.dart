class Service {
  String name;
  int price;

  Service(String name, int price) {
    this.name = name;
    this.price = price;
  }

  String getName() {
    return this.name;
  }

  int getPrice() {
    return this.price;
  }
}
