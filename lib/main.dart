import 'package:flutter/material.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
TextStyle liteH = TextStyle(fontSize: 26.0, fontFamily: 'Raleway', );
TextStyle liteS = TextStyle(color: Colors.black87, fontSize: 16.0, fontFamily: 'Raleway');
String getTime(TimeOfDay d) => "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";    //returns time in 24hour format
var x = 0;
//Photo by eberhard grossgasteiger from Pexels
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Planner",
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              snap: false,
              backgroundColor: Colors.black87,
              expandedHeight: 140,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Planner", style: liteH),
                centerTitle: true,
                background: Image.asset("assets/images/banner.jpg", fit: BoxFit.cover,),
              ),
            ),

            PlanList(),
          ],
        ),
      ),
    );
  }
}
TextEditingController textEditingController = TextEditingController();
class PlanList extends StatefulWidget {
  @override
  _PlanListState createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  List<String> _titlesList = ['0'];
  List<String> _timesList = ['0'];
  _PlanListState() {
    _read();
  }
  void _read() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titlesList = prefs.getStringList('titles') ?? ['0'];
      _timesList = prefs.getStringList('times') ?? ['0'];
    });
  }
  void _write() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('titles', _titlesList);
    await prefs.setStringList('times', _timesList);
  }
  TextEditingController _t = TextEditingController();

  TimeOfDay timeSelected;

  Widget _addCard() {
    return Container(
      color: Color.fromARGB(64, 0x3F, 0x40, 0x40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: TextField(
                decoration: InputDecoration(labelText: 'Add a task'),
                controller: _t,
              ),
              width: 200.0,
            ),
            IconButton(
              icon: Icon(Icons.access_time),
              tooltip: "Select a time for task",
              onPressed: () {
                Future<TimeOfDay> timeSelector = showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                timeSelector.then((t) {
                  timeSelected = t;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              tooltip: "Add task to list",
              onPressed: () {
                setState(() {
                  //addToList(_t.text, timeSelected);
                  _titlesList.add(_t.text);
                  _t.text = "";
                  FocusScope.of(context).requestFocus(FocusNode());
                  _timesList.add(getTime(timeSelected));
                  _write();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    //read();
    return SliverList(
      delegate: new SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return (index == 0) ? _addCard() : PlanCard(_titlesList[index], _timesList[index]);
        },
        childCount: _titlesList.length,
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title, time;
  PlanCard(this.title, this.time);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black12,
      onTap: () {
      },
      child: Container(
        height: 72,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 18.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: liteS,),
              Text(time, style: liteS,),
            ],
          ),
        ),
      ),
    );
  }
}