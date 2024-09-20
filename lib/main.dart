import 'package:flutter/material.dart';
import 'dart:async';
void main() {
  runApp(MaterialApp(
    home: DigitalPetAppHome(),
  ));
}


class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key}); 
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class DigitalPetAppHome extends StatefulWidget {
  @override
  _DigitalPetAppHomeState createState() => _DigitalPetAppHomeState();
}

String petName = "Your Pet";


class _DigitalPetAppHomeState extends State<DigitalPetAppHome>{

  void _setName(text) {
    setState(() {
      petName = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Name your pet and press enter'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextField(
              onSubmitted: (text){
                _setName(text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DigitalPetApp()),
                );
              },  
            ),
          ],
        ),
      ),
    );
  }
}



class _DigitalPetAppState extends State<DigitalPetApp> {
  
  //variables
  int happinessLevel = 50;
  int hungerLevel = 50;
  Color petColor = Colors.yellow;
  bool gameOver = false;
  bool win = false;
  String winMessage = '';
  String loseMessage = '';
  String happinessMessage = "Neutral :/";
  Timer? _hungerTimer;

  //timers for automatic hunger increase
  @override
  void initState(){
    super.initState();
    _hungerTimer = Timer.periodic(const Duration(seconds:30),(timer){   
      setState(() {
        hungerLevel = hungerLevel - 10;
      });
    });
    Timer _winTimer = Timer(const Duration(seconds:300),(){   
      setState(() {
        win = true;
        winMessage = "Congratulations you kept your pet alive and happy for 10 minutes.";
      });
    });
  }

  void getPetMood() {
    if (happinessLevel > 70) {
      setState(() {
        happinessMessage = "Happy :)";
      });
    } 
    else if (happinessLevel >= 30 && happinessLevel <= 70) {
      setState(() {
        happinessMessage = "Neutral :/";
      });
    } 
    else {
      setState(() {
        happinessMessage = "Unhappy :(";
      });
    }
  }
  // Function to increase happiness and update hunger when playing with the pet
  void _playWithPet() {
    setState(() {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _updateHunger();
      _updatePetColor();
      getPetMood();
      checkLossCondition();
    });
  }

  // Function to decrease hunger and update happiness when feeding the pet
  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      _updateHappiness();
      _updatePetColor();
      getPetMood();
      checkLossCondition();
    });
  }

  // Update happiness based on hunger level
  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    } else {
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
    }
  }

  // Increase hunger level slightly when playing with the pet
  void _updateHunger() {
    hungerLevel = (hungerLevel + 5).clamp(0, 100);
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel = (happinessLevel - 20).clamp(0, 100);
    }
  }
  
  void _updatePetColor() {
    setState(() {
      if (happinessLevel > 70) {
        petColor = Colors.green; // Happy
      } else if (happinessLevel >= 30 && happinessLevel <= 70) {
        petColor = Colors.yellow; // Neutral
      } else {
        petColor = Colors.red; // Unhappy
      }
    });
  }

  void checkLossCondition() {
    if (hungerLevel >= 100 || happinessLevel <= 10) {
      gameOver = true;
      setState(() {
        loseMessage = "Game over, your pet had died.";
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet, keep happiness high and hunger low'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$winMessage $loseMessage',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              'Name: $petName',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Hunger Level: $hungerLevel',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              '$happinessMessage',
              style: TextStyle(fontSize: 20.0),
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(petColor, BlendMode.modulate),
              child: Image.asset(
                'puppy_image.png', // Make sure this path matches your image file location
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
