package com.redevrx.flutter_phone_call_state

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.content.ContextCompat
import androidx.core.content.getSystemService
import com.redevrx.flutter_phone_call_state.handle.FlutterStreamHandle
import com.redevrx.flutter_phone_call_state.receiver.CallMonitoringService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/** FlutterPhoneCallStatePlugin */
class FlutterPhoneCallStatePlugin: FlutterPlugin {
  private val flutterHandler =  FlutterStreamHandle
  private lateinit var methodChannel:MethodChannel

  fun isServiceRunning(context: Context, serviceClass: Class<*>): Boolean {
    // 1. Get the ActivityManager
    val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager?

    // 2. Get the list of running services and iterate through it
    // Note: getRunningServices is deprecated on newer Android versions for privacy reasons,
    // but it still works for checking your own app's services.
    @Suppress("DEPRECATION")
    for (service in manager!!.getRunningServices(Integer.MAX_VALUE)) {
      // 3. Check if the service's class name matches yours
      if (serviceClass.name == service.service.className) {
        // If a match is found, the service is running
        return true
      }
    }
    // If the loop completes without finding a match, the service is not running
    return false
  }
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    flutterHandler.init(flutterPluginBinding)
    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger,"phone_call_state_monitor")

    val context = flutterPluginBinding.applicationContext
    val intent = Intent(context, CallMonitoringService::class.java)

    methodChannel.setMethodCallHandler { call, result ->
      if (call.method == "startCallService"){
        CoroutineScope(Dispatchers.Default).launch {
          context.stopService(intent)
          delay(1000)

          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, intent)
          } else {
            context.startService(intent)
          }
        }
        result.success(true)
      }
      if(call.method == "stopCallServiceBro"){
        CoroutineScope(Dispatchers.Default).launch {
          context.stopService(intent)
        }
        result.success(true)
      }
      if(call.method == "isServiceRunning"){
        CoroutineScope(Dispatchers.Default).launch {
          isServiceRunning(context, CallMonitoringService::class.java)
        }
        result.success(true)
      }
    }
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    flutterHandler.dispose()
  }
}
