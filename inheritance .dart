//Inheritance is a sharing of behaviour  between  two classes it allows
//you to define a class that extends the functionality of another class the
//extend keyword is used for inheriting from a parent class

// Sytax

// class ParentClass{
// Parent class code
//    }

// class ChildClass extends ParentClass{
// Child class code
//    }

// Example of inheritance in Dart
class person {
  String? name;
  int? age;
  String? address;

  // Constructor
  person(this.name, this.age, this.address);
  // Method to display person details
  void display() {
    print("Name: $name, Age: $age, Address: $address");
  }
}

// Here in student class ,we are extending the
// properties and methods of the person class
class Student extends person {
  String? schoolName;
  int? grade;
  int? rollNumber;
  int? marks;
  int? attendance;

  // Constructor for Student that calls the superclass constructor
  Student(
    String? name,
    int? age,
    String? address,
    this.schoolName,
    this.grade,
    this.rollNumber,
    this.marks,
    this.attendance,
  ) : super(name, age, address);

  //method
  void displaySchoolDetails() {
    print(
      "School Name: $schoolName, Grade: $grade, Roll Number: $rollNumber, Marks: $marks, Attendance: $attendance",
    );
  }
}

void main() {
  // Creating an instance of Student
  Student student = Student(
    "John Doe",
    16,
    "123 Main St",
    "ABC High School",
    10,
    25,
    85,
    90,
  );

  // Displaying person details
  student.display();

  // Displaying school details
  student.displaySchoolDetails();
}
