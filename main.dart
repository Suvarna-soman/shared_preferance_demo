import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:openbox_hive/person.dart';
import 'boxes.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  boxPersons = await Hive.openBox<Person>('PersonBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hive OpenBox Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 31, 57),
      appBar: AppBar(
        title: const Text('Hive OpenBox Demo'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          const Image(
            image: AssetImage(
              'images/logo.jpg',
            ),
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'name',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: ageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Age',
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          boxPersons.put(
                            'key_${nameController.text}',
                            Person(
                              name: nameController.text,
                              age: int.parse(ageController.text),
                            ),
                          );
                        });
                      },
                      child: const Text('add'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: boxPersons.length,
                    itemBuilder: (context, index) {
                      Person person = boxPersons.getAt(index);
                      return ListTile(
                        leading: IconButton(
                          onPressed: () {
                            setState(() {
                              boxPersons.deleteAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.remove,
                          ),
                        ),
                        title: Text(person.name),
                        subtitle: const Text('Name'),
                        trailing: Text('age:${person.age.toString()}'),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              boxPersons.clear();
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete All'),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
