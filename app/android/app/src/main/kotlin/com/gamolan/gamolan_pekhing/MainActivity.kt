package com.gamolan.gamolan_pekhing

import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.gamolan.gamolan_pekhing/wifi"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openWifiManager" -> {
                    try {
                        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            Intent(Settings.Panel.ACTION_WIFI)
                        } else {
                            Intent(Settings.ACTION_WIFI_SETTINGS)
                        }
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        try {
                            val fallback = Intent(Settings.ACTION_WIFI_SETTINGS)
                            fallback.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(fallback)
                            result.success(true)
                        } catch (e2: Exception) {
                            result.error("ERROR", e2.message, null)
                        }
                    }
                }
                "bindToWifi" -> {
                    try {
                        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
                        var bound = false
                        for (network in cm.allNetworks) {
                            val caps = cm.getNetworkCapabilities(network)
                            if (caps != null && caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)) {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                    cm.bindProcessToNetwork(network)
                                    bound = true
                                    break
                                }
                            }
                        }
                        result.success(bound)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
