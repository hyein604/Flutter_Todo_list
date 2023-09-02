import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_list/task.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),
        labelMedium: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
        ),

      ),
      home: const MyHomePage(title: 'TO-DO List'),
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
  final _textController = TextEditingController();

  List<Task> tasks=[];

  bool isModifying=false;
  int modifyingIndex=0; 
  double percent=0.0;

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

 void updatePercent(){
  if(tasks.isEmpty){
    percent=0.0;
  }else{
    var completeTaskCnt=0;
    for(var i=0;i<tasks.length;i++){
      if(tasks[i].isComplete){
        completeTaskCnt++;
      }
    }
    percent=completeTaskCnt/tasks.length;
  }

  
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(getToday()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _textController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_textController.text==''){
                        return;
                      }else{
                        isModifying
                        ?  setState(() {
                          tasks[modifyingIndex].work=_textController.text;
                          tasks[modifyingIndex].isComplete=false;
                          _textController.clear();
                          modifyingIndex=0;
                          isModifying=false;
                        })
                        :setState(() {
                          var task=Task(
                            id: 0,
                            work: _textController.text,
                            isComplete: false);
                          addTaskToServer(task);
                          _textController.clear();
                        });
                        updatePercent();
                      }
                    },
                    child: isModifying ? const Text("수정") : const Text("추가"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 50,
                    lineHeight: 14.0,
                    percent: percent,
                    progressColor: Colors.purple[300],
                    backgroundColor: Colors.purple[50],
                  ),
                ],
              ),
            ),

            for(var i=0;i<tasks.length;i++)
            Row(
              children: [
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                         tasks[i].isComplete=!tasks[i].isComplete;
                          updatePercent();
                      });
                     
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          tasks[i].isComplete 
                          ? const Icon(Icons.check_box_rounded) 
                           :const Icon(Icons.check_box_outline_blank_rounded),
                          Text(tasks[i].work,
                          style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: isModifying ? null :  () {
                   setState(() {
                    isModifying=true;
                     _textController.text=tasks[i].work;
                     modifyingIndex=i;
                   });
                  },
                  child: const Text("수정"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      tasks.remove(tasks[i]);
                       updatePercent();
                    });
                     
                  },
                  child: const Text("삭제"),
                ),
              ],
            ),
            
          ],
        ),
      ),
      )
    );
  }
  
  addTaskToServer(Task task) async {
    print("${task.work} ${task.isComplete}");
    final response = await http.post(
      // http.post post 형식으로 통신할 것이고 Uri.http의 경우 10.0.2.2:8000 주소로 보낼 거며 추가 주소로 /positng/addTask로 보낸다
      Uri.http('10.0.2.2:8000','/posting/addTodo'),
      // headers는 해당 데이터의 머리에 이 Content의 타입이 Json형식이다
      headers: {'Content-type': 'application/json'},
      // body로는 Json으로 Encode 된 task 데이터를 보내 주겠다
      // 이 경우에 Task객체에 toJson 함수를 만들어 놓지 않을 시 jsonEncode가 연결을 해주지 않으며 오류가 난다.
      body: jsonEncode(task));
    print("response is = ${response.body}");
  }
  
}