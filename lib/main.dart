import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_basic_crud/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.cyan),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String studentName, studentID, studyProgramID;
  late double studentGPA;

  getStudentName(name) {
    this.studentName = name;
  }

  getStudentID(id) {
    this.studentID = id;
  }

  getStudyProgramID(programID) {
    this.studyProgramID = programID;
  }

  getStudentGPA(gpa) {
    this.studentGPA = double.parse(gpa);
  }

  createData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference =
        firestore.collection("MyStudents").doc(studentName);

    //create Map
    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyProgramID": studyProgramID,
      "studentGPA": studentGPA,
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName created successfully");
    });
  }

  readData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.get().then((datasnapshot) {
      Map<String, dynamic> data = datasnapshot.data() as Map<String, dynamic>;
      print(data['studentName']);
      print(data['studentID']);
      print(data['studentProgramID']);
      print(data['studentGPA']);
    });
  }

  updateData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference =
        firestore.collection("MyStudents").doc(studentName);

    //create Map
    Map<String, dynamic> students = {
      "studentName": studentName,
      "studentID": studentID,
      "studyProgramID": studyProgramID,
      "studentGPA": studentGPA,
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName updated successfully");
    });
  }

  deleteData() {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference =
        firestore.collection("MyStudents").doc(studentName);

    documentReference.delete().whenComplete(() {
      print("$studentName deleted successfully");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Flutter College"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Name",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      )),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Student ID",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      )),
                  onChanged: (String id) {
                    getStudentID(id);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Study Program ID",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      )),
                  onChanged: (String programID) {
                    getStudyProgramID(programID);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "GPA",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      )),
                  onChanged: (String gpa) {
                    getStudentGPA(gpa);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Create"),
                    onPressed: () {
                      createData();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  ElevatedButton(
                    child: Text("Read"),
                    onPressed: () {
                      readData();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  ElevatedButton(
                    child: Text("Update"),
                    onPressed: () {
                      updateData();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                  ElevatedButton(
                    child: Text("Delete"),
                    onPressed: () {
                      deleteData();
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16))),
                  )
                ],
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(textDirection: TextDirection.ltr, children: <Widget>[
                  Expanded(
                    child: Text("Name"),
                  ),
                  Expanded(
                    child: Text("StudentID"),
                  ),
                  Expanded(
                    child: Text("Program"),
                  ),
                  Expanded(
                    child: Text("StudentGPA"),
                  )
                ]),
              ),
              Expanded(
                  child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("MyStudents")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot<Map<String, dynamic>>
                            documentSnapshot = snapshot.data!.docs[index];
                        Map<String, dynamic> data = documentSnapshot.data()!;

                        return Row(
                          children: <Widget>[
                            Expanded(child: Text(data["studentName"])),
                            Expanded(child: Text(data["studentID"])),
                            Expanded(child: Text(data["studyProgramID"])),
                            Expanded(
                                child: Text(data["studentGPA"].toString())),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return CircularProgressIndicator(); // You might want to show a loading indicator while data is being fetched.
                  }
                },
              ))
            ],
          ),
        ));
  }
}
