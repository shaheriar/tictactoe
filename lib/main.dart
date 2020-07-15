import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tic Tac Toe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int scoreo = 0;
  int scorex = 0;
  List<List> _matrix;

  _HomePageState() {
    _initMatrix();
  }

  _initMatrix() {                                       //initializing the matrix
    _matrix = List<List>(3);
    for (var i = 0; i < _matrix.length; i++) {
      _matrix[i] = List(3);
      for (var j = 0; j < _matrix[i].length; j++) {
        _matrix[i][j] = ' ';
      }
    }
  }
  String _lastChar = 'O';                              //Player X will go first, unless the last winner is X
  String _nextChar = 'X';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Align(
                alignment: Alignment(0, 0),
                child: Text('\n\n\n'),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Text('Tic Tac Toe'),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Text('\n\n'),
              ),
              Align(
                alignment: Alignment(0.0, 0.0),
                child: Text('Player O                                                     '
                            'Player X'),
              ),
              Align(
                alignment: Alignment(0.0, 0.0),
                  child: Text('\n $scoreo \t\t\t\t\t\t\t\t\t\t\t\t\t\t'
                                          '\t\t\t\t\t\t\t\t\t\t\t\t\t\t'
                                          '\t\t\t\t\t\t\t\t\t\t\t\t\t\t'
                                          '\t\t\t\t\t\t\t\t\t\t\t\t\t\t'
                                          '\t\t\t\t\t\t\t\t\t $scorex'),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Text('\n\n'),
              ),
              Row(                                    //first row
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(0, 0),
                  _buildElement(0, 1),
                  _buildElement(0, 2),
                ],
              ),
              Row(                                  //second row
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(1, 0),
                  _buildElement(1, 1),
                  _buildElement(1, 2),
                ],
              ),
              Row(                                 //third row
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildElement(2, 0),
                  _buildElement(2, 1),
                  _buildElement(2, 2),
                ],
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Text('\n\n'),
              ),
              Align(                             //to let the user know whose turn it is
                alignment: Alignment(0, 0),
                child: Text('It is Player $_nextChar\'s turn'),
              ),
              Align(
                alignment: Alignment(0, 0),
                child: Text('\n\n'),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              child: FlatButton(                 //a button to reset the scores
                child: Text('New Game'),
                onPressed: () {
                    setState(() {
                    scoreo = 0;
                    scorex = 0;
                    _initMatrix();
                    _showReset();
                });
              },
              ),
              ),
            ],
          ),
        ),
    );
  }
  double x = 0;
  Color c1;
  Color c2;
  double y = 0;


  _buildElement(int i, int j) {           //function to make a matrix field that detects whenever the user taps on it
    if (i < 2) {                          //to avoid drawing a line on the last row
      x = 1;
      c1 = Colors.black;
    }
    else {
      x = 0;
      c1 = Colors.white;
    }
    if (j < 2) {                          //to avoid drawing a line on the last column
      y = 1;
      c2 = Colors.black;
    }
    else {
      y = 0;
      c2 = Colors.white;
    }
    return GestureDetector(               //to detect a touch
      onTap: () {
        _changeMatrixField(i, j);         //if a touch is detected then call changematrixfield function
        if (_checkWinner(i, j)) {         //if a winner is detected after the touch then
          _showDialog(_matrix[i][j]);     //show the dialog with the winner passed into it as the parameter
        } else {
          if (_checkDraw()) {             //else check if its a draw
            _showDialog(null);            //and pass in a null to tell the function its a draw
          }
        }
      },
      child: Container(
        width: 100.0,
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: x, color: c1),      //drawing the grid
                  right: BorderSide(width: y, color: c2),
                )
            ),
        child: Center(
          child: Text(
            _matrix[i][j],                                      //filling it in with the values from the matrix
            style: TextStyle(
                fontSize: 80.0
            ),
          ),
        ),
      ),
    );
  }

  _changeMatrixField(int i, int j) {                    //to change the field from a blank to an O or an X
    setState(() {
      if (_matrix[i][j] == ' ') {                       //if its blank
        if (_lastChar == 'O') {                         //if the previous character was O then make the blank space an X
          _matrix[i][j] = 'X';
          _nextChar = 'O';
        }
        else {
          _matrix[i][j] = 'O';                          //else an O
          _nextChar = 'X';
        }
        _lastChar = _matrix[i][j];
      }
    });
  }

  _checkDraw() {                                         //function to check if its a draw
    var draw = true;
    _matrix.forEach((i) {
      i.forEach((j) {
        if (j == ' ')
          draw = false;
      });
    });
    return draw;
  }

  _checkWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    var player = _matrix[x][y];

    for (int i = 0; i < _matrix.length; i++) {                    //go through the matrix and check if the same letter appears consecutively
      if (_matrix[x][i] == player)                                //vertically
        col++;
      if (_matrix[i][y] == player)                                //horizontally
        row++;
      if (_matrix[i][i] == player)                                //diagonal from left to right
        diag++;
      if (_matrix[i][2-i] == player)                              //diagonal from right to left
        rdiag++;
    }
    if (row == 3 || col == 3 || diag == 3 || rdiag == 3) {        //if any of the values reach 3, a winner is detected
      if (_matrix[x][y] == 'X') {                                 //if the winner is X
        scorex++;                                                 //increment the score of X
      }
      else {
        scoreo++;                                                 //else increment the score of O
      }
      return true;
    }
    return false;
  }

  _showReset() {                    //dialog box to show when the user presses the 'New Game' button
    String dialog = 'The scores have been reset';
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(dialog),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix();
                  });
                },
              ),
            ],
          );
        }
    );
  }

  _showDialog(String winner) {      //dialog box to show either the winner or if its a draw
    String dialogText;
    if (winner == null) {
      dialogText = 'Draw';
    } else {
      dialogText = 'Winner: Player $winner';
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(dialogText),
            actions: <Widget>[
              FlatButton(
                child: Text('Next Round'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _initMatrix();
                  });
                },
              ),
            ],
          );
        }
    );
  }
}