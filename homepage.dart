import 'package:flutter/material.dart';

import 'model/course.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String courseName;
  int credit = 5;
  double gradeValue;
  String letterGrade = "FF";
  List<Course> courses;
  double avg = 0;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courses = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //tüm ekran
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Calculate Average"),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: appBody(),
    );
  }

  Widget appBody() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: formKey,
              child: Column(
                //all buttons
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Course Name",
                        labelStyle: TextStyle(color: Colors.blueAccent),
                        hintText: "Enter Course Name",
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)))),
                    validator: (inputValue) {
                      if (inputValue.length > 0) {
                        return null;
                      } else {
                        return "Course Name can not be empty!";
                      }
                    },
                    onSaved: (String saveValue) {
                      courseName = saveValue;
                      setState(() {
                        courses.add(Course(courseName, gradeValue, credit));
                        _calculateAverage();
                      });
                    },
                  ),
                  Row(
                    //2 other buttons in one row
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        //first button
                        margin: EdgeInsets.only(top: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.blueAccent, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blueAccent),
                        child: DropdownButtonHideUnderline(
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.blueAccent),
                            child: DropdownButton<int>(
                              items: courseCredits(),
                              value: credit,
                              onChanged: (chosenCredit) {
                                setState(() {
                                  credit = chosenCredit;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //second button
                        margin: EdgeInsets.only(top: 10),
                        padding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: Colors.blueAccent, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blueAccent),
                        child: DropdownButtonHideUnderline(
                          child: new Theme(
                            data: Theme.of(context)
                                .copyWith(canvasColor: Colors.blueAccent),
                            child: DropdownButton<double>(
                              items: courseLetters(),
                              value: gradeValue,
                              onChanged: (chosenLetter) {
                                setState(() {
                                  gradeValue = chosenLetter;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                border: BorderDirectional(
                    top: BorderSide(color: Colors.blueAccent, width: 2),
                    bottom: BorderSide(color: Colors.blueAccent, width: 2))),
            child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Average is: ",
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                    TextSpan(
                        text: courses.length == 0
                            ? "Please add courses"
                            : avg.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ]),
                )),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                  itemBuilder: _createListElements, itemCount: courses.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createListElements(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          debugPrint("index: " + index.toString());
          courses.removeAt(index);
          _calculateAverage();
        });
      },
      child: addedCourseCard(index),
    );
  }

  Card addedCourseCard(int index) {
    return Card(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(Icons.arrow_forward_ios),
        title: Text(courses.elementAt(index).name,
            style: TextStyle(color: Colors.white)),
        subtitle: Text(courses.elementAt(index).credit.toString() +
            " credit and letter grade is " +
            courses.elementAt(index).letterGrade.toString()),
      ),
    );
  }

  void _calculateAverage() {
    double totalGrade = 0;
    double totalCredit = 0;
    for (var currentCourse in courses) {
      totalGrade += currentCourse.letterGrade * currentCourse.credit;
      totalCredit += currentCourse.credit;
    }
    avg = totalGrade / totalCredit;
  }
}

List<DropdownMenuItem<int>> courseCredits() {
  List<DropdownMenuItem<int>> credits = [];
  for (int i = 1; i < 10; i++) {
    var item = DropdownMenuItem(
      child: Text(
        "$i Credit",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: i,
    );
    credits.add(item);
  }
  return credits;
}

List<DropdownMenuItem<double>> courseLetters() {
  List<DropdownMenuItem<double>> letters = [];
  letters.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 4));
  letters.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 3.5));
  letters.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 3));
  letters.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 2.5));
  letters.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 2));
  letters.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 1.5));
  letters.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 1));
  letters.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 0));
  return letters;
}
