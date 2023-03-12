import 'package:flutter/material.dart';

import 'line.dart';

class Board {
  //Static properties
  static int _currentPos = 49;
  static int _winningPlayer = 0;
  static int _curentPlayer = 0;

  static List<Widget> walls = new List<Line>();

  static List<int> _pressedDots = new List<int>.generate(1, (int index) => 49, growable:true);

  static List<int> _playersOverTime = new List<int>.generate(1, (int player) => 0, growable: true);

  static final List<List<int>> _goalAdjacentDots = List<List<int>>.generate(2, (int index){
    if (index == 0){
      return [3, 4, 5];
    }
    return [93, 94, 95];
  });

  static List<List<int>> get wallDots => [
    [0, 1], [1, 2], [6, 7], [7, 8],
    [0, 9], [8, 17], [45, 54], [53, 62],
    [9, 18], [17, 26], [54, 63], [62, 71],
    [18, 27], [26, 35], [63, 72], [71, 80],
    [27, 36], [35, 44], [72, 81], [80, 89],
    [36, 45], [44, 53], [81, 90], [89, 98],
    [90, 91], [91, 92], [96, 97], [97, 98]
  ];

  //Static methods
  static Color _calculateGoalColor(int index){
    if (_winningPlayer == index + 1) {
      return _currentPlayerPositionColour();
    } else if (_goalAdjacentDots[index].any((i) => _currentPos == i)) {
      return _currentPlayerOptionsColour();
    }else {
      return Colors.black;
    }
  }

  static bool _isLeftSideOfArena(int index) {
    return index % 9 == 0;
  }

  static bool _isRightSideOfArena(int index) {
    return index % 9 == 8;
  }

  // static bool _isTopOfArena(int index) {
  //   return index < 9;
  // }

  // static bool _isBottomOfArena(int index) {
  //   return index > 90;
  // }

  static bool _isLeftOfCurrentPos(int index) {
    return index == _currentPos - 1 || index == _currentPos - 10 || index == _currentPos + 8;
  }

  static bool _isRightOfCurrentPos(int index) {
    return index == _currentPos + 1 || index == _currentPos - 8 || index == _currentPos + 10;
  }

  static bool _isAboveCurrentPos(int index) {
    return index == _currentPos - 9;
  }

  
  static bool _isBelowCurrentPos(int index) {
    return index == _currentPos + 9;
  }

  static bool _hasBeenTraversedFromCurrentPos(int index) {
    int i = 1;
    return _pressedDots.any((d) {
      if ( i < _pressedDots.length && ((d == _currentPos && _pressedDots[i] == index) || (d == index && _pressedDots[i] == _currentPos))) {
        return true;
      }
      i++;
      return false;
    }) || wallDots.any((w) {
      if ((w[0] == _currentPos && w[1] == index) || (w[1] == _currentPos && w[0] == index )) {
        return true;
      } else {
        return false;
      }
    });
  }

  static Color _calculateColor(int index, {bool goalReached = false}){
    if (goalReached) {
      return Colors.black;
    } else if (index == _currentPos) {
      return _currentPlayerPositionColour();
    } else if (_isRightOfCurrentPos(index) && !_isLeftSideOfArena(index) && !_hasBeenTraversedFromCurrentPos(index)) {
      return _currentPlayerOptionsColour();
    } else if (_isLeftOfCurrentPos(index) && !_isRightSideOfArena(index) && !_hasBeenTraversedFromCurrentPos(index)) {
      return _currentPlayerOptionsColour();
    }  else if (_isAboveCurrentPos(index) && !_hasBeenTraversedFromCurrentPos(index)) {
      return _currentPlayerOptionsColour();
    } else if (_isBelowCurrentPos(index) && !_hasBeenTraversedFromCurrentPos(index)) {
      return _currentPlayerOptionsColour();
    }else {
      return Colors.black;
    }
  }

  static Color _currentPlayerPositionColour() {
    return _curentPlayer == 0 ? Colors.red.shade500 : Colors.blue.shade500;
  }

  static Color _currentPlayerOptionsColour() {
    return _curentPlayer == 0 ? Colors.orange.shade500 : Colors.green.shade500;
  }

  //Instance properties
  List<Widget> _dots = List<Widget>.generate(99, (int index){
    GlobalKey key = GlobalKey();
    return new Container(
                key: key, 
                decoration: new BoxDecoration(
                  color: _calculateColor(index), 
                  shape: BoxShape.circle
                )
              );
  });

  List<Widget> get dots { 
    return _dots; 
   } 
    
  set dots(List<Widget> dots) { 
    this._dots = dots; 
  } 

  List<Widget> _goals = List<Widget>.generate(2, (int index){
    GlobalKey key = GlobalKey();
    return new Container(
                key: key,
                width: 15,
                height: 15, 
                decoration: new BoxDecoration(
                  color: _calculateGoalColor(index), 
                  shape: BoxShape.circle
                )
              );
  });

  List<Widget> get goals { 
    return _goals; 
   } 
    
  set goals(List<Widget> goals) { 
    this._goals = goals; 
  } 

  List<Widget> _lines = new List<Line>();

  List<Widget> get lines { 
    return _lines; 
   } 
    
  set lines(List<Widget> lines) { 
    this._lines = lines; 
  } 

  //Instance methods
  void undoDraw() {
    if(_lines.length > 0) {
      //undo last line
      _lines.removeLast();
      if (_pressedDots.length > 1) {
        //undo last dot pressed
        _pressedDots.removeLast();
        _currentPos = _pressedDots[_pressedDots.length - 1];  
        //undo last player's turn
         _curentPlayer = _playersOverTime[_playersOverTime.length - 1];
        _playersOverTime.removeLast();
        //undo winning player condition
        _winningPlayer = 0;
        //update colours
        _updateDotColors();
        _updateGoalColors();
      }
    }
  }

  void _updateDotColors({bool goalReached = false}) {
    _dots = List<Widget>.generate(99, (int index){
      return new Container(
        key: _dots[index].key, 
        decoration: new BoxDecoration(
          color: _calculateColor(index, goalReached: goalReached), 
          shape: BoxShape.circle
        )
      );
    });
  }

  void _updateGoalColors() {
    _goals =  List<Widget>.generate(2, (int index){
      return new Container(
        key: _goals[index].key,
        width: 15,
        height: 15, 
        decoration: new BoxDecoration(
          color: _calculateGoalColor(index), 
          shape: BoxShape.circle
        )
      );
    });
  }

  getPositions(int index) {
    if (((_dots[index] as Container).decoration as BoxDecoration).color.value == Colors.orange.shade500.value ||
      ((_dots[index] as Container).decoration as BoxDecoration).color.value == Colors.green.shade500.value) {
      final RenderBox toDot = (_dots[index].key as GlobalKey).currentContext.findRenderObject();
      final RenderBox currentDot = (_dots[_currentPos].key as GlobalKey).currentContext.findRenderObject();
      final toPosition = toDot.localToGlobal(Offset.zero) + toDot.size.center(Offset.zero);
      final currentPosition = currentDot.localToGlobal(Offset.zero) + currentDot.size.center(Offset.zero);
      print("Current Player: $_curentPlayer");
      print("POSITION of dot $index: $toPosition ");
      print("POSITION of dot $_currentPos: $currentPosition ");
      _lines.add(new Line(currentPosition.translate(-20, 0), toPosition.translate(-20, 0)));
      _currentPos = index;
      _playersOverTime.add(_curentPlayer);
      _updatePlayerTurn(index);
      _pressedDots.add(_currentPos);
      print(_playersOverTime);
      _updateDotColors();
      _updateGoalColors();
    }
  }

  checkIfPlayerOneWins() {
    const indexes = [3, 4, 5];
    _checkIfCanWin(indexes, 0);
  }

  checkIfPlayerTwoWins() {
    const indexes = [93, 94, 95];
    _checkIfCanWin(indexes, 1);
  }

  _checkIfCanWin(List<int> indexes, int playerIndex) {
    GlobalKey key = _goals[playerIndex].key;
    if(indexes.any((i) => _currentPos == i)) {
      _winningPlayer = playerIndex + 1;
      final RenderBox toDot = key.currentContext.findRenderObject();
      final RenderBox currentDot = (_dots[_currentPos].key as GlobalKey).currentContext.findRenderObject();
      final toPosition = toDot.localToGlobal(Offset.zero) + toDot.size.center(Offset.zero);
      final currentPosition = currentDot.localToGlobal(Offset.zero) + currentDot.size.center(Offset.zero);
      print("Current Player: $playerIndex ");
      print("POSITION of Goal: $toPosition ");
      print("POSITION of Dot: $_currentPos: $currentPosition ");
      _lines.add(new Line(currentPosition.translate(-20, 0), toPosition.translate(-20, 0)));
      _playersOverTime.add(_curentPlayer);
      _pressedDots.add(_currentPos);
      _updateDotColors(goalReached: true);
      _updateGoalColors();
    }
  }

  _updatePlayerTurn(int index) {
    if (wallDots.every((pair) => pair[0] != index && pair[1] != index) && _pressedDots.every((dot) => dot != index)) {
      _curentPlayer = 1 - _curentPlayer;
    }
  }
}