import 'dart:isolate';

void heavyComputation(SendPort sendPort) {
  // This function simulates a heavy computation
  int result = 0;
  for (int i = 0; i < 1000000000; i++) {
    result += i;
  }

  // Send the result back to the main isolate
  sendPort.send(result);
}

Future<int> performHeavyComputation() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(heavyComputation, receivePort.sendPort);
  int result = await receivePort.first;
  receivePort.close();
  return result;
}
