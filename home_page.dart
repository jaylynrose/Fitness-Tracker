import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
void main() {
  runApp(const FitnessApp());
}
class FitnessApp extends StatelessWidget {
  const FitnessApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 4,
          centerTitle: true,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFF2F7F5), // Light green background for textfields
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
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
  final List<Map<String, dynamic>> exercises = [];
  final List<String> goals = []; // Store goals separately
  final List<Map<String, dynamic>> history = [];
  List<String> completedGoals = []; // Track completed goals
  String selectedWorkout = "Gym Exercise"; // Default to "Gym Exercise"
  // Toggle exercise completion status and update history
  void _toggleExercise(int index) {
    setState(() {
      exercises[index]['completed'] = !exercises[index]['completed'];
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      if (exercises[index]['completed']) {
        exercises[index]['completedDate'] = date;
        history.add({
          'name': exercises[index]['name'],
          'date': date,
          'details': exercises[index],
        });
      } else {
        exercises[index]['completedDate'] = null;
        history.removeWhere((item) => item['name'] == exercises[index]['name']);
      }
    });
  }
  // Add an exercise to the list (Gym or Cardio)
  void _addExercise() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController weightController = TextEditingController();
        TextEditingController repsController = TextEditingController();
        TextEditingController setsController = TextEditingController();
        TextEditingController distanceController = TextEditingController();
        TextEditingController durationController = TextEditingController();
        return AlertDialog(
          title: const Text("Add Exercise", style: TextStyle(color: Colors.teal)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Exercise Name")),
              if (selectedWorkout == "Gym Exercise") ...[
                TextField(controller: weightController, decoration: const InputDecoration(labelText: "Weight (kg)")),
                TextField(controller: repsController, decoration: const InputDecoration(labelText: "Reps")),
                TextField(controller: setsController, decoration: const InputDecoration(labelText: "Sets")),
                TextField(controller: distanceController, decoration: const InputDecoration(labelText: "Distance (miles)")),
                TextField(controller: durationController, decoration: const InputDecoration(labelText: "Duration (minutes)")),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  exercises.add({
                    'name': nameController.text,
                    'weight': weightController.text,
                    'reps': repsController.text,
                    'sets': setsController.text,
                    'distance': distanceController.text,
                    'duration': durationController.text,
                    'completed': false,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  // Add a new goal
  void _addGoal() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController goalController = TextEditingController();
        return AlertDialog(
          title: const Text("Add Goal", style: TextStyle(color: Colors.teal)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: goalController, decoration: const InputDecoration(hintText: "Enter your goal (e.g. Squats)")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  goals.add(goalController.text);
                });
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
  // Mark a goal as completed
  void _toggleGoalCompletion(String goal) {
    setState(() {
      if (completedGoals.contains(goal)) {
        completedGoals.remove(goal);
      } else {
        completedGoals.add(goal);
        // Add completed goal to history
        history.add({
          'name': goal,
          'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
          'details': {
            'goal': goal,
            'completed': true,
          }
        });
      }
    });
  }
  // Navigate to the history page
  void _navigateToHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HistoryPage(history: history),
      ),
    );
  }
  // Generate Weekly or Monthly summary of exercises
  String _getActivitySummary() {
    int completedExercises = exercises.where((e) => e['completed'] == true).length;
    return "Completed Exercises: $completedExercises\nGoals Completed: ${completedGoals.length}";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Welcome User', style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Record Exercises'),
              onTap: _addExercise,
            ),
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Set Fitness Goals'),
              onTap: _addGoal,
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Workout History'),
              onTap: () => _navigateToHistory(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Goals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display goals at the top with strikethrough when clicked
            for (var goal in goals)
              GestureDetector(
                onTap: () => _toggleGoalCompletion(goal),
                child: Row(
                  children: [
                    Icon(
                      completedGoals.contains(goal) ? Icons.check_box : Icons.check_box_outline_blank,
                      color: completedGoals.contains(goal) ? Colors.green : Colors.grey,
                    ),
                    Text(
                      goal,
                      style: TextStyle(
                        decoration: completedGoals.contains(goal) ? TextDecoration.lineThrough : TextDecoration.none,
                        color: completedGoals.contains(goal) ? Colors.green : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            if (completedGoals.length == goals.length)
              const Text("Goals are Reached", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            // Display exercise and goal progress summary
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                _getActivitySummary(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            // List of exercises below goals
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: Colors.white,
                    child: ListTile(
                      title: Text(exercises[index]['name']),
                      subtitle: exercises[index]['weight'] != ""
                          ? Text("Weight: ${exercises[index]['weight']} kg, Reps: ${exercises[index]['reps']}, Sets: ${exercises[index]['sets']}")
                          : Text("Distance: ${exercises[index]['distance']} miles, Duration: ${exercises[index]['duration']} min"),
                      trailing: Checkbox(
                        value: exercises[index]['completed'],
                        activeColor: Colors.green,
                        onChanged: (value) => _toggleExercise(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  const HistoryPage({super.key, required this.history});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: history.isEmpty
          ? const Center(child: Text('No exercises completed yet.'))
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                var exercise = history[index]['details'] as Map<String, dynamic>;
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: Colors.white,
                  child: ListTile(
                    title: Text(history[index]['name']!),
                    subtitle: Text(
                        "Date: ${history[index]['date']}\n"
                        "Details: ${exercise['weight'] != "" ? "Weight: ${exercise['weight']} kg, Reps: ${exercise['reps']}, Sets: ${exercise['sets']}" : "Duration: ${exercise['duration']} min, Distance: ${exercise['distance']} miles"}"),
                  ),
                );
              },
            ),
    );
  }
}
