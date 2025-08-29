package com.example.openmeter

import android.content.Context
import android.content.pm.PackageManager
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.openmeter/main"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "hasFlashlight" -> result.success(hasFlashlight())
                "turnOn" -> {
                    turnFlashlight(true)
                    result.success(null)
                }

                "turnOff" -> {
                    turnFlashlight(false)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun hasFlashlight(): Boolean {
        return packageManager.hasSystemFeature(android.content.pm.PackageManager.FEATURE_CAMERA_FLASH)
    }

    private fun turnFlashlight(state: Boolean) {
        val cameraManager = getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            val cameraId = cameraManager.cameraIdList[0]
            cameraManager.setTorchMode(cameraId, state)
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }
}