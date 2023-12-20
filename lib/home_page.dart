import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  final hubConnection = HubConnectionBuilder().withUrl("https://localhost:7292/connect-four").build();

  // final hubConnection.onclose( (error) => print("Connection Closed"));


  List<List<int>> board = List.generate(6, (_) => List<int>.filled(7, 0));

  String player = const Uuid().v1();

  int currentPlayer = 1;


  bool playerTurn = true;

  @override
  void initState() {
    super.initState();



    hubConnection.on("OpponentPlay", (arguments) {
      _opponentPlay(arguments![0] as int);
    });



  }

  @override
  void dispose() {
    hubConnection.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ,
      builder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: 42,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 7;
                  int col = index % 7;

                  return GestureDetector(
                    onTap: () => _dropPiece(col),
                    child: Container(
                      decoration: BoxDecoration(
                        color: board[row][col] == 0
                            ? Colors.white
                            : board[row][col] == 1
                                ? Colors.yellow
                                : Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _resetGame(),
              child: const Text("Reiniciar Jogo"),
            ),
            const SizedBox(height: 30),
          ],
        );
      }
    );
  }

  void _dropPiece(int col) {
    for (int row = 5; row >= 0; row--) {
      if (board[row][col] == 0) {
        setState(() {
          board[row][col] = currentPlayer;
          // checar se ganhou
          currentPlayer = 3 - currentPlayer;
        });
        _block();
        _checkWin();
        break;
      }
    }
  }

  void _resetGame() {
    setState(() {
      board = List.generate(6, (_) => List<int>.filled(7, 0));

      int currentPlayer = 1;
    });
  }

  void _play(int col) {

    List<Object>? lista = [col];

    _dropPiece(col);
    hubConnection.send("Play", args : lista);

  }

  void _block() {






    playerTurn = false;
  }

  void _opponentPlay(int col) {




    _dropPiece(col);
    playerTurn = true;
  }

  void _checkWin() {}
}
