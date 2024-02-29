package com.example.heavy_computation

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "performHeavyComputation") {
                val computationResult = performHeavyComputation()
                result.success(computationResult)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun performHeavyComputation(): Int {
        // Simulate a heavy computation
        var result = 0
        for (i in 0 until 1000000000) {
            result += i
        }
        return result
    }

    companion object {
        private const val CHANNEL = "com.example.heavy_computation"
    }
}
