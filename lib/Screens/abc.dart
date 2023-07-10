import 'package:flutter/material.dart';

class MyGridView extends StatefulWidget {
  const MyGridView({Key? key}) : super(key: key);

  @override
  _MyGridViewState createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  final List<String> _letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L'
  ];
  final TextEditingController _controller = TextEditingController();
  List<bool> _highlightedTiles = List.filled(12, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: 12,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: _highlightedTiles[index]
                      ? BoxDecoration(
                          color: Colors.yellowAccent,
                          border: Border.all(
                            color: Colors.yellow,
                            width: 2,
                          ),
                        )
                      : null,
                  child: Center(
                    child: Text(
                      _letters[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
          TextField(
            controller: _controller,
            onChanged: (query) {
              setState(() {
                _highlightedTiles = List.filled(12, false);
                if (query.length == 3) {
                  for (int i = 0; i < 3; i++) {
                    String colString =
                        _letters[i] + _letters[i + 3] + _letters[i + 6];
                    if (colString == query) {
                      _highlightedTiles[i] = true;
                      _highlightedTiles[i + 3] = true;
                      _highlightedTiles[i + 6] = true;
                    }
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
