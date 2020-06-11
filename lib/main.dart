import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sorting',
      home: Sorting(),
    );
  }
}

class Sorting extends StatefulWidget {
  @override
  _SortingState createState() => _SortingState();
}

class _SortingState extends State<Sorting> {
  int sort_technique = 0;
  List<int> _numbers = [];
  int _sampleSize = 500;
  bool _isSorting=false;
  String _title="Bubble Sort";

  StreamController<List<int>> _streamController;
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<int>>();
    _stream = _streamController.stream;
    _reset();
  }

  //bubble
  _bubbleSort() async {
    for (int i = 0; i < _numbers.length; ++i) {
      for (int j = 0; j < _numbers.length - i - 1; ++j) {
        if (_numbers[j] >= _numbers[j + 1]) {
          int temp = _numbers[j];
          _numbers[j] = _numbers[j + 1];
          _numbers[j + 1] = temp;
        }
        await Future.delayed(Duration(microseconds: 0));
        _streamController.add(_numbers);
      }
    }
  }
  //bubble end

  //insertion
  _insertionSort() async {
    for (int i = 1; i < _numbers.length; i++) {
      int key = _numbers[i];
      int j = i - 1;
      while (j >= 0 && _numbers[j] > key) {
        _numbers[j + 1] = _numbers[j];
        j = j - 1;
        await Future.delayed(Duration(microseconds: 0));
        _streamController.add(_numbers);
      }
      _numbers[j + 1] = key;
    }
  }
  //insertion end

  //selection
  _selectionSort() async {
    for (int i = 0; i < _numbers.length - 1; i++) {
      int minIndex = i;
      for (int j = i + 1; j < _numbers.length; j++)
        if (_numbers[j] < _numbers[minIndex]) {
          minIndex = j;
          await Future.delayed(Duration(microseconds: 1000));
          _streamController.add(_numbers);
        }
      int temp = _numbers[minIndex];
      _numbers[minIndex] = _numbers[i];
      _numbers[i] = temp;
      await Future.delayed(Duration(microseconds: 1000));
          _streamController.add(_numbers);
    }
  }
  //selection end

  //quick sort
  cf(int a, int b) {
    if (a < b) {
      return -1;
    } else if (a > b) {
      return 1;
    } else {
      return 0;
    }
  }

  _quickSort(int leftIndex, int rightIndex) async {
    Future<int> _partition(int left, int right) async {
      int p = (left + (right - left) / 2).toInt();

      var temp = _numbers[p];
      _numbers[p] = _numbers[right];
      _numbers[right] = temp;
      await Future.delayed(Duration(microseconds: 1000));

      _streamController.add(_numbers);

      int cursor = left;

      for (int i = left; i < right; i++) {
        if (cf(_numbers[i], _numbers[right]) <= 0) {
          var temp = _numbers[i];
          _numbers[i] = _numbers[cursor];
          _numbers[cursor] = temp;
          cursor++;

          await Future.delayed(Duration(microseconds: 1000));
          _streamController.add(_numbers);
        }
      }

      temp = _numbers[right];
      _numbers[right] = _numbers[cursor];
      _numbers[cursor] = temp;

      await Future.delayed(Duration(microseconds: 1000));

      _streamController.add(_numbers);

      return cursor;
    }

    if (leftIndex < rightIndex) {
      int p = await _partition(leftIndex, rightIndex);
      await _quickSort(leftIndex, p - 1);
      await _quickSort(p + 1, rightIndex);
    }
  }
  //quick sort end

  //merge
  _mergeSort(int leftIndex, int rightIndex) async {
    Future<void> merge(int leftIndex, int middleIndex, int rightIndex) async {
      int leftSize = middleIndex - leftIndex + 1;
      int rightSize = rightIndex - middleIndex;

      List leftList = new List(leftSize);
      List rightList = new List(rightSize);

      for (int i = 0; i < leftSize; i++) leftList[i] = _numbers[leftIndex + i];
      for (int j = 0; j < rightSize; j++)
        rightList[j] = _numbers[middleIndex + j + 1];

      int i = 0, j = 0;
      int k = leftIndex;

      while (i < leftSize && j < rightSize) {
        if (leftList[i] <= rightList[j]) {
          _numbers[k] = leftList[i];
          i++;
        } else {
          _numbers[k] = rightList[j];
          j++;
        }
        await Future.delayed(Duration(microseconds: 1000));
        _streamController.add(_numbers);
        k++;
      }
      while (i < leftSize) {
        _numbers[k] = leftList[i];
        i++;
        k++;
        await Future.delayed(Duration(microseconds: 1000));
        _streamController.add(_numbers);
      }
      while (j < rightSize) {
        _numbers[k] = rightList[j];
        j++;
        k++;
        await Future.delayed(Duration(microseconds: 1000));
        _streamController.add(_numbers);
      }
    }

    if (leftIndex < rightIndex) {
      int middleIndex = (rightIndex + leftIndex) ~/ 2;
      await _mergeSort(leftIndex, middleIndex);
      await _mergeSort(middleIndex + 1, rightIndex);
      await Future.delayed(Duration(microseconds: 1000));
      _streamController.add(_numbers);
      await merge(leftIndex, middleIndex, rightIndex);
    }
  }
  //merge sort end

  _sort(int sortValue) async {
    switch (sortValue) {
      case 0:
        setState(() {
          _isSorting=true;
        });
        await _bubbleSort();
        setState(() {
          _isSorting=false;
        });
        break;
      case 1:
      setState(() {
          _isSorting=true;
        });
        await _insertionSort();
        setState(() {
          _isSorting=false;
        });
        break;
      case 2:
      setState(() {
          _isSorting=true;
        });
        await _selectionSort();
        setState(() {
          _isSorting=false;
        });
        break;
      case 3:
      setState(() {
          _isSorting=true;
        });
        await _quickSort(0, _numbers.length - 1);
        setState(() {
          _isSorting=false;
        });
        break;
      case 4:
      setState(() {
          _isSorting=true;
        });
        await _mergeSort(0, _numbers.length - 1);
        setState(() {
          _isSorting=false;
        });
        break;
      default:
    }
  }

  _reset() {
    _numbers.clear();
    for (int i = 0; i < _sampleSize; ++i) {
      _numbers.add(Random().nextInt(_sampleSize));
    }
    _streamController.add(_numbers);
  }

  String _getTitle(int value){
    String title;
    if(value==0)
       title="Bubble Sort";
    else if(value==1)
      title= "Insertion Sort";
    else if(value==2)
      title= "Selection Sort";
    else if(value==3)
      title= "Quick Sort";
    else 
      title= "Merge Sort";
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        elevation: 20,
        title: Text(_title),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (int selectedvalue) {
                setState(() {
                  _title=_getTitle(selectedvalue);  
                });
                sort_technique = selectedvalue;
                print(sort_technique);
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Bubble Sort'),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text('Insertion Sort'),
                      value: 1,
                    ),
                    PopupMenuItem(
                      child: Text('Selection Sort'),
                      value: 2,
                    ),
                    PopupMenuItem(
                      child: Text('Quick Sort'),
                      value: 3,
                    ),
                    PopupMenuItem(
                      child: Text('Merge Sort'),
                      value: 4,
                    ),
                  ]),
        ],
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: _isSorting?Colors.grey:Colors.green,
                  onPressed: () {
                    _isSorting ?null:_reset();
                  },
                  child: Text('Shuffle Array'))),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.redAccent,
                  onPressed: () {
                    _sort(sort_technique);
                  },
                  child: Text('Sort'))),
        ],
      ),
      body: Container(
        child: StreamBuilder<Object>(
            stream: _stream,
            builder: (context, snapshot) {
              int counter = 0;
              return Row(
                children: _numbers.map((int number) {
                  return CustomPaint(
                    painter: BarPainter(
                      width: MediaQuery.of(context).size.width / _sampleSize,
                      value: number,
                      index: counter++,
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double width;
  final int value;
  final int index;

  BarPainter({this.width, this.value, this.index});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();

    if (this.value < 500 * 0.1) {
      paint.color = Colors.purple;
    } else if (this.value < 500 * 0.2) {
      paint.color = Colors.orange;
    } else if (this.value < 500 * 0.3) {
      paint.color = Colors.cyan;
    } else if (this.value < 500 * 0.4) {
      paint.color = Colors.blueGrey;
    } else if (this.value < 500 * 0.5) {
      paint.color = Colors.lime;
    } else if (this.value < 500 * 0.6) {
      paint.color = Colors.red;
    } else if (this.value < 500 * 0.7) {
      paint.color = Colors.green;
    } else if (this.value < 500 * 0.8) {
      paint.color = Colors.brown;
    } else if (this.value < 500 * 0.9) {
      paint.color = Colors.yellow;
    } else {
      paint.color = Colors.black87;
    }

    paint.strokeWidth = width * 1.5;
    paint.strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(width * index, 570 - value.ceilToDouble()),
        Offset(width * index, 570), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
