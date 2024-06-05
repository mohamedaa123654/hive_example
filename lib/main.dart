import 'package:flutter/material.dart';
import 'package:hive_example/boxes.dart';
import 'package:hive_example/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('personBox');
  // boxPersons.put('key_$name', Person(name: name, age: age, ));
  Person person = boxPersons.get('key_$name');
  print(person.name);
  print(person.age);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test Hive DB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          hintText: 'name',
                          fillColor: Colors.grey,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide()),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide()))),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          hintText: 'age',
                          fillColor: Colors.grey,
                          filled: true,
                          hintStyle: TextStyle(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide()),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              borderSide: BorderSide()))),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              boxPersons.put(
                                  'key_${nameController?.text}',
                                  Person(
                                      name: nameController!.text,
                                      age: int.parse(ageController!.text)));
                            });
                          },
                          child: const Text('Add')))
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.grey,
              ),
              child: ListView.builder(
                itemCount: boxPersons.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var person = boxPersons.getAt(index) as Person;
                  return ListTile(
                    leading: IconButton(
                      onPressed: () {
                        setState(() {
                          boxPersons.deleteAt(index);
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    title: Text(person.name),
                    subtitle: Text('Name'),
                    trailing: Text('age: ${person.age.toString()}'),
                  );
                },
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
