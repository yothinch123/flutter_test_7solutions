import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test 7solution'),
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
  List<dynamic> type1 = [];
  List<dynamic> type2 = [];
  List<dynamic> type3 = [];

  int lastRemoveIndex = -1;

  List<dynamic> allFibonacciNumbers = [];

  final ScrollController _scrollController = ScrollController();

   @override
  void initState() {
    super.initState();
    generateNumber();
  }

  void generateNumber() {
    List<dynamic> fibonacciNumbers = [{
        "index": 0,
        "number": 0,
        "type": 1,
    },{
        "index": 1,
        "number": 1,
        "type": 2,
    }];

    int p1 = 0;
    int p2 = 1;

    for (var i = 0; i < 44; i++) {
      int type = 2;
      int num = fibonacciNumbers[p1]['number'] + fibonacciNumbers[p2]['number'];

      int iconPos1 = fibonacciNumbers[p1]['type'];
      int iconPos2 = fibonacciNumbers[p2]['type'];
      
      if (num % 3 == 0) {
        type = 1;
      } else {
        if (iconPos1 == iconPos2) {
          if (iconPos2 == 2) {
            type = 3;
          } else {
            type = 2;
          }
        } else if(iconPos2 == 1) {
            type = iconPos1;
        } else {
            type = iconPos2;
        }
      }


      fibonacciNumbers.add({
        "index": i+2,
        "number": num,
        "type": type,
      });
    
      p1++;
      p2++;
    }
    
    setState(() {
      allFibonacciNumbers = fibonacciNumbers;
    });
  }

  Widget generateWidget() {
    List<Widget> list = [];

    for (var i = 0; i < allFibonacciNumbers.length; i++) {
      int type = allFibonacciNumbers[i]['type'];
      list.add(
        ListTile(
          tileColor: lastRemoveIndex == allFibonacciNumbers[i]['index'] ? Colors.red : Colors.white ,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Index: ${allFibonacciNumbers[i]['index']}, Number: ${allFibonacciNumbers[i]['number']} ",),
                InkWell(
                  onTap: (){
                    showModal(allFibonacciNumbers[i]);
                  },
                  child: type == 1 ? Icon(Icons.circle) : type == 2 ? Icon(Icons.square_outlined) : Icon(Icons.cancel_outlined)
                )
              ],
            ),
          ),
      );
    }
    return ListView(
        controller: _scrollController,
        children: list,
      );
  }

  List<dynamic> checkDuplicate(List<dynamic> types, dynamic fibonacciNumber) {
      int dup = types.indexWhere((e) => e['index'] == fibonacciNumber['index']);
      if (dup == -1) {
        types.add(fibonacciNumber);
      }
      return types;
  }

  void showModal(dynamic fibonacciNumber) {
    int findex = fibonacciNumber['index'];
    int type = fibonacciNumber['type'];
    
    setState(() {
      lastRemoveIndex = -1;
      allFibonacciNumbers.removeWhere((e) => e['index'] == findex);
    });

    List<dynamic> types = type == 1 ? type1 : type == 2 ? type2 : type3;

    types = checkDuplicate(types, fibonacciNumber);
    types.sort((a, b) => a['number'].compareTo(b['number']));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView(
            children: types.map((e) {
              return ListTile(
                tileColor: findex == e['index'] ? Colors.green : Colors.white,
                onTap: () {
                  removeData(e, types);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("index: ${e['number']}"),
                        Text("Number: ${e['index']}", style: const TextStyle(fontSize: 10),),
                      ],
                    ),
                    type == 1 ? Icon(Icons.circle) : type == 2 ? Icon(Icons.square_outlined) : Icon(Icons.cancel_outlined)
                  ],
                ),
              );
            }).toList(),
          )
        );
      },
    );
  }

  void removeData(dynamic fibonacciNumber, List<dynamic> type) {
    setState(() {
      lastRemoveIndex = fibonacciNumber['index'];
      type.removeWhere((e) => e['index'] == fibonacciNumber['index']);
      lastRemoveIndex = fibonacciNumber['index'];
      allFibonacciNumbers.add(fibonacciNumber);
      allFibonacciNumbers.sort((a, b) => a['number'].compareTo(b['number']));
      if (_scrollController.hasClients){
        _scrollToItem(fibonacciNumber['index']);
      }
    });

    Navigator.of(context).pop();
  }

  void _scrollToItem(int index) {
    int idx = allFibonacciNumbers.indexWhere((e) => e['index'] == index);
    _scrollController.animateTo(
      idx * 40,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
           Container(
              color: Colors.lightBlue,
                alignment: Alignment.center,
                height: 80,
              child: const Text("Fibonucci Number List", style: TextStyle(fontSize: 20, color: Colors.white),),
            ),
            Expanded(
              child: generateWidget()
            )
          ],
        )
      ),
    );
  }
}
