import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

import 'board.dart';
import 'line.dart';

class Game extends StatefulWidget {

  Game();

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with AfterLayoutMixin<Game> {

  Board _board = new Board();

  void _updateState() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

 @override
  void afterFirstLayout(BuildContext context) {
    Board.walls = new List<Line>.generate(28, (int index){
      final RenderBox toDot = (_board.dots[Board.wallDots[index][1]].key as GlobalKey).currentContext.findRenderObject();
      final RenderBox currentDot = (_board.dots[Board.wallDots[index][0]].key as GlobalKey).currentContext.findRenderObject();
      final toPosition = toDot.localToGlobal(Offset.zero) + toDot.size.center(Offset.zero);
      final currentPosition = currentDot.localToGlobal(Offset.zero) + currentDot.size.center(Offset.zero);
      return new Line(currentPosition.translate(-20, 0), toPosition.translate(-20, 0));
    });
    _updateState();
  }

  void _undoDraw() {
    _board.undoDraw();
    _updateState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        color: Colors.white,
        child: new Stack(
          children: <Widget>[
            ...Board.walls,
            ..._board.lines,
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new GestureDetector(
                  onTap: (){
                    _board.checkIfPlayerOneWins();
                    _updateState();
                    print("Player 1 Goal clicked");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: _board.goals[0]
                  )
                ),
                GridView.builder(
                shrinkWrap: true,
                padding: new EdgeInsets.symmetric(vertical: 0, horizontal: 0),   
                physics: ClampingScrollPhysics(),
                itemCount: 99,
                itemBuilder: (context, index) { return GestureDetector(
                  onTap: (){
                    print("\nContainer clicked");
                    _board.getPositions(index);
                    _updateState();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: _board.dots[index]
                  )
                ); },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                ),
                new GestureDetector(
                  onTap: (){
                    _board.checkIfPlayerTwoWins();
                    _updateState();
                    print("Player 2 Goal clicked");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: _board.goals[1]
                  )
                ),
              ]
            ),
          ]
        )  
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _undoDraw,
          tooltip: 'Undo',
          child: Icon(Icons.undo),
        )
    );
  }
}