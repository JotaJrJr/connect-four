import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Connect Four'),
        ),
        body: ConnectFour(),
      ),
    );
  }
}

class ConnectFour extends StatefulWidget {
  const ConnectFour({super.key});

  @override
  _ConnectFourState createState() => _ConnectFourState();
}

class _ConnectFourState extends State<ConnectFour> {
  List<List<int>> board = List.generate(7, (_) => List<int>.filled(8, 0));
  int currentPlayer = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            itemCount: 56,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemBuilder: (context, index) {
              int row = index ~/ 8;
              int col = index % 8;
              return GestureDetector(
                onTap: () => _dropPiece(col),
                child: Container(
                  decoration: BoxDecoration(
                    color: board[row][col] == 0
                        ? Colors.white
                        : board[row][col] == 1
                            ? Colors.red
                            : Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: _resetGame,
          child: const Text('Reset Game'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _dropPiece(int col) {
    for (int row = 6; row >= 0; row--) {
      if (board[row][col] == 0) {
        setState(() {
          board[row][col] = currentPlayer;
          _checkForWin(row, col);
          currentPlayer = 3 - currentPlayer; // Switch player
        });
        break;
      }
    }
  }

  void _checkForWin(int row, int col) {}

  void _resetGame() {
    setState(() {
      board = List.generate(7, (_) => List<int>.filled(8, 0));
      currentPlayer = 1;
    });
  }
}
