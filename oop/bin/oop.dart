import 'dart:io';
import 'dart:math';

class Mug {
  String color;
  double capacity;
  double currentVolume;

  Mug(this.color, this.capacity) : currentVolume = 0;

  void fill(double volume) {
    if (volume > capacity) {
      print('Объём превышает вместимость кружки!');
      return;
    }
    currentVolume = volume;
    print('Кружка наполнена: $currentVolume/$capacity мл');
  }

  void drink(double volume) {
    if (volume > currentVolume) {
      print('В кружке недостаточно жидкости!');
      return;
    }
    currentVolume -= volume;
    print('Выпито $volume мл. Осталось: $currentVolume мл');
  }

  bool get isEmpty => currentVolume == 0;
  bool get isFull => currentVolume == capacity;
}

class Person {
  String name;

  Person(this.name);

  void drinkFromMug(Mug mug, double volume) {
    print('$name пытается пить из кружки...');
    if (mug.isEmpty) {
      print('Кружка пуста!');
      return;
    }
    mug.drink(volume);
    print('$name пьёт из $color кружки');
  }
}

class StorageSystem {
  String name;
  List<String> items;

  StorageSystem(this.name) : items = [];

  void addItem(String item) {
    items.add(item);
    print('Добавлено "$item" в $name');
  }

  String? removeItem(String item) {
    if (items.contains(item)) {
      items.remove(item);
      print('Забрано "$item" из $name');
      return item;
    }
    print('"$item" не найдено в $name');
    return null;
  }

  void showItems() {
    print('$name: ${items.isEmpty ? "пусто" : items.join(", ")}');
  }
}

class Wardrobe {
  String name;
  List<StorageSystem> storageSystems;

  Wardrobe(this.name) : storageSystems = [];

  void addStorageSystem(StorageSystem system) {
    storageSystems.add(system);
    print('Добавлена система хранения: ${system.name}');
  }

  void putItem(String itemName, int systemIndex) {
    if (systemIndex >= 0 && systemIndex < storageSystems.length) {
      storageSystems[systemIndex].addItem(itemName);
    } else {
      print('Неверный индекс системы хранения');
    }
  }

  void getItem(String itemName) {
    for (var system in storageSystems) {
      if (system.items.contains(itemName)) {
        system.removeItem(itemName);
        return;
      }
    }
    print('Вещь "$itemName" не найдена в шкафу');
  }

  void showContents() {
    print('\nШкаф "$name":');
    for (var system in storageSystems) {
      system.showItems();
    }
  }
}

class Plate {
  double weight;
  String color;

  Plate(this.weight, this.color);

  @override
  String toString() => '$color блин ($weight кг)';
}

class Barbell {
  double maxLoad;
  double barWeight;
  List<Plate> leftPlates;
  List<Plate> rightPlates;

  Barbell(this.maxLoad, {this.barWeight = 20})
      : leftPlates = [],
        rightPlates = [];

  double get totalWeight {
    double platesWeight = 0;
    for (var plate in leftPlates) platesWeight += plate.weight;
    for (var plate in rightPlates) platesWeight += plate.weight;
    return barWeight + platesWeight;
  }

  bool addPlate(String side, Plate plate) {
    if (totalWeight + plate.weight > maxLoad) {
      print('Превышена максимальная загрузка грифа!');
      return false;
    }
    if (side == 'left') {
      leftPlates.add(plate);
    } else if (side == 'right') {
      rightPlates.add(plate);
    }
    print('Добавлен $plate на $side сторону');
    return true;
  }

  void removePlate(String side) {
    if (side == 'left' && leftPlates.isNotEmpty) {
      leftPlates.removeLast();
      print('Снят блин с левой стороны');
    } else if (side == 'right' && rightPlates.isNotEmpty) {
      rightPlates.removeLast();
      print('Снят блин с правой стороны');
    } else {
      print('Нет блинов для снятия');
    }
  }

  void showStatus() {
    print('\nГриф (макс: $maxLoad кг):');
    print('   Левая сторона: ${leftPlates.isEmpty ? "пусто" : leftPlates.join(", ")}');
    print('   Правая сторона: ${rightPlates.isEmpty ? "пусто" : rightPlates.join(", ")}');
    print('   Общий вес: $totalWeight кг');
  }
}

class CurrencyConverter {
  Map<String, double> rates;

  CurrencyConverter() : rates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'RUB': 75.0,
    'JPY': 110.0,
  };

  double convert(double amount, String from, String to) {
    if (!rates.containsKey(from) || !rates.containsKey(to)) {
      throw Exception('Неизвестная валюта');
    }
    double inUSD = amount / rates[from]!;
    return inUSD * rates[to]!;
  }

  void addRate(String currency, double rate) {
    rates[currency] = rate;
    print('Добавлен курс для $currency: $rate');
  }

  void showRates() {
    print('\nКурсы валют (относительно USD):');
    rates.forEach((currency, rate) {
      print('   $currency: $rate');
    });
  }
}

class MyNumber {
  int value;

  MyNumber(this.value);

  MyNumber operator +(MyNumber other) => MyNumber(value + other.value);
  MyNumber operator -(MyNumber other) => MyNumber(value - other.value);
  MyNumber operator *(MyNumber other) => MyNumber(value * other.value);
  MyNumber operator /(MyNumber other) => MyNumber(value ~/ other.value);
  MyNumber operator %(MyNumber other) => MyNumber(value % other.value);

  @override
  bool operator ==(Object other) => other is MyNumber && value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MyNumber($value)';
}

enum CarState { stopped, moving, turning }

class Car {
  String model;
  CarState state;
  int speed;

  Car(this.model) : state = CarState.stopped, speed = 0;

  void start() {
    if (state == CarState.moving) {
      print('Автомобиль уже едет!');
      return;
    }
    state = CarState.moving;
    speed = 20;
    print('$model начал движение (скорость: $speed км/ч)');
  }

  void stop() {
    state = CarState.stopped;
    speed = 0;
    print('$model остановился');
  }

  void turn(String direction) {
    if (state == CarState.stopped) {
      print('Нельзя повернуть на месте!');
      return;
    }
    CarState oldState = state;
    state = CarState.turning;
    print('$model поворачивает $direction');
    state = oldState;
  }

  void accelerate(int increment) {
    if (state == CarState.stopped) {
      print('Сначала заведите автомобиль!');
      return;
    }
    speed += increment;
    print('Скорость: $speed км/ч');
  }

  void showStatus() {
    String stateStr = '';
    switch (state) {
      case CarState.stopped: stateStr = 'Стоп'; break;
      case CarState.moving: stateStr = 'Едет'; break;
      case CarState.turning: stateStr = 'Поворачивает'; break;
    }
    print('$model: $stateStr, скорость: $speed км/ч');
  }
}

abstract class Shape {
  String name;
  Shape(this.name);
  double get area;
  double get perimeter;
  @override
  String toString() => '$name (площадь: ${area.toStringAsFixed(2)})';
}

class Rectangle extends Shape {
  double width;
  double height;
  Rectangle(this.width, this.height) : super('Прямоугольник');
  @override
  double get area => width * height;
  @override
  double get perimeter => 2 * (width + height);
}

class Triangle extends Shape {
  double a, b, c;
  Triangle(this.a, this.b, this.c) : super('Треугольник');
  @override
  double get area {
    double s = perimeter / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }
  @override
  double get perimeter => a + b + c;
}

class Circle extends Shape {
  double radius;
  Circle(this.radius) : super('Окружность');
  @override
  double get area => pi * radius * radius;
  @override
  double get perimeter => 2 * pi * radius;
}

class NumberConverter {
  static String fromDecimal(int number, int base) {
    if (base < 2 || base > 16) throw Exception('Основание должно быть 2-16');
    if (number == 0) return '0';
    
    const digits = '0123456789ABCDEF';
    String result = '';
    int n = number.abs();
    
    while (n > 0) {
      result = digits[n % base] + result;
      n ~/= base;
    }
    
    return number < 0 ? '-' + result : result;
  }

  static int toDecimal(String number, int base) {
    if (base < 2 || base > 16) throw Exception('Основание должно быть 2-16');
    return int.parse(number, radix: base);
  }

  static String convert(String number, int fromBase, int toBase) {
    int decimal = toDecimal(number, fromBase);
    return fromDecimal(decimal, toBase);
  }
}

class ShapeCollection {
  List<Shape> shapes;

  ShapeCollection() : shapes = [];

  void addShape(Shape shape) {
    shapes.add(shape);
    print('Добавлена фигура: $shape');
  }

  Shape? findMaxArea() {
    if (shapes.isEmpty) return null;
    Shape maxShape = shapes[0];
    for (var shape in shapes) {
      if (shape.area > maxShape.area) {
        maxShape = shape;
      }
    }
    return maxShape;
  }

  void showAll() {
    print('\nВсе фигуры:');
    for (var shape in shapes) {
      print('   $shape');
    }
  }
}

abstract class Tableware {
  String name;
  Tableware(this.name);
  @override
  String toString() => name;
}

class Fork extends Tableware {
  Fork() : super('Вилка');
}

class Spoon extends Tableware {
  Spoon() : super('Ложка');
}

class Knife extends Tableware {
  Knife() : super('Нож');
}

class TableItem extends Tableware {
  TableItem() : super('Тарелка');
}

class Table {
  String name;
  List<Tableware> items;

  Table(this.name) : items = [];

  void putItem(Tableware item) {
    items.add(item);
    print('Поставлено: $item');
  }

  void removeItem(String itemName) {
    for (var item in items) {
      if (item.name == itemName) {
        items.remove(item);
        print('Убрано: $item');
        return;
      }
    }
    print('"$itemName" не найдено на столе');
  }

  void showItems() {
    print('\nСтол "$name": ${items.isEmpty ? "пуст" : items.join(", ")}');
  }
}

void main() {
  while (true) {
    print('\n' + '=' * 60);
    print('ОБЪЕКТНО-ОРИЕНТИРОВАННОЕ ПРОГРАММИРОВАНИЕ НА DART');
    print('=' * 60);
    print('1. Кружка и Человек');
    print('2. Шкаф и Системы хранения');
    print('3. Гриф и Блин');
    print('4. Конвертер валют');
    print('6. Перегрузка операторов');
    print('7. Автомобиль (enum)');
    print('8. Геометрические фигуры');
    print('9. Системы счисления');
    print('10. Коллекция фигур');
    print('11. Стол и приборы');
    print('0. Выход');
    print('-' * 60);
    print('Выберите задание: ');
    
    String? choice = stdin.readLineSync();
    if (choice == null || choice == '0') break;
    
    print('\n' + '-' * 60);
    
    switch (choice) {
      case '1':
        print('ЗАДАНИЕ 1: Кружка и Человек\n');
        Mug mug = Mug('синяя', 300);
        mug.fill(250);
        Person person = Person('Алексей');
        person.drinkFromMug(mug, 100);
        person.drinkFromMug(mug, 200);
        break;
        
      case '2':
        print('ЗАДАНИЕ 2: Шкаф и Системы хранения\n');
        Wardrobe wardrobe = Wardrobe('Гардероб');
        wardrobe.addStorageSystem(StorageSystem('Полка 1'));
        wardrobe.addStorageSystem(StorageSystem('Ящик 1'));
        wardrobe.putItem('Футболка', 0);
        wardrobe.putItem('Носки', 1);
        wardrobe.showContents();
        wardrobe.getItem('Футболка');
        wardrobe.showContents();
        break;
        
      case '3':
        print('ЗАДАНИЕ 3: Гриф и Блин\n');
        Barbell barbell = Barbell(100, barWeight: 20);
        barbell.addPlate('left', Plate(10, 'красный'));
        barbell.addPlate('right', Plate(10, 'красный'));
        barbell.addPlate('left', Plate(5, 'жёлтый'));
        barbell.showStatus();
        barbell.removePlate('left');
        barbell.showStatus();
        break;
        
      case '4':
        print('ЗАДАНИЕ 4: Конвертер валют\n');
        CurrencyConverter converter = CurrencyConverter();
        converter.showRates();
        double amount = 100;
        print('\n$amount USD = ${converter.convert(amount, 'USD', 'EUR').toStringAsFixed(2)} EUR');
        print('$amount USD = ${converter.convert(amount, 'USD', 'RUB').toStringAsFixed(2)} RUB');
        break;
        
      case '6':
        print('ЗАДАНИЕ 6: Перегрузка операторов\n');
        MyNumber a = MyNumber(10);
        MyNumber b = MyNumber(3);
        print('a = $a, b = $b');
        print('a + b = ${a + b}');
        print('a - b = ${a - b}');
        print('a * b = ${a * b}');
        print('a / b = ${a / b}');
        print('a % b = ${a % b}');
        print('a == b: ${a == b}');
        break;
        
      case '7':
        print('ЗАДАНИЕ 7: Автомобиль\n');
        Car car = Car('Toyota');
        car.showStatus();
        car.start();
        car.accelerate(30);
        car.turn('налево');
        car.stop();
        car.showStatus();
        break;
        
      case '8':
        print('ЗАДАНИЕ 8: Геометрические фигуры\n');
        Rectangle rect = Rectangle(5, 3);
        Triangle tri = Triangle(3, 4, 5);
        Circle circle = Circle(4);
        print('$rect, периметр: ${rect.perimeter.toStringAsFixed(2)}');
        print('$tri, периметр: ${tri.perimeter.toStringAsFixed(2)}');
        print('$circle, периметр: ${circle.perimeter.toStringAsFixed(2)}');
        break;
        
      case '9':
        print('ЗАДАНИЕ 9: Системы счисления\n');
        int num = 255;
        print('$num (DEC) = ${NumberConverter.fromDecimal(num, 2)} (BIN)');
        print('$num (DEC) = ${NumberConverter.fromDecimal(num, 8)} (OCT)');
        print('$num (DEC) = ${NumberConverter.fromDecimal(num, 16)} (HEX)');
        print('FF (HEX) = ${NumberConverter.toDecimal('FF', 16)} (DEC)');
        print('1111 (BIN) = ${NumberConverter.toDecimal('1111', 2)} (DEC)');
        break;
        
      case '10':
        print('ЗАДАНИЕ 10: Коллекция фигур\n');
        ShapeCollection collection = ShapeCollection();
        collection.addShape(Rectangle(5, 4));
        collection.addShape(Triangle(6, 8, 10));
        collection.addShape(Circle(3));
        collection.showAll();
        Shape? maxShape = collection.findMaxArea();
        print('\nМаксимальная площадь: $maxShape');
        break;
        
      case '11':
        print('ЗАДАНИЕ 11: Стол и приборы\n');
        Table table = Table('Обеденный');
        table.putItem(Fork());
        table.putItem(Spoon());
        table.putItem(Knife());
        table.putItem(TableItem());
        table.showItems();
        table.removeItem('Ложка');
        table.showItems();
        break;
        
      default:
        print('Неверный номер задания');
    }
    
    print('-' * 60);
  }
  
  print('\nПрограмма завершена. До свидания!');
}