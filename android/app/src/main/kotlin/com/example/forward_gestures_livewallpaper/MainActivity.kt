package com.example.forward_gestures_livewallpaper

import android.app.WallpaperManager
import android.graphics.PixelFormat
import android.os.Bundle
import android.util.Log

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  // https://flutter.dev/docs/development/platform-integration/platform-channels#example-kotlin
  private val channelName = "com.example.forward_gestures_livewallpaper/events"
  private lateinit var wallpaperManager: WallpaperManager

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    // Make flutter view transparent
    // https://github.com/flutter/flutter/issues/37025
    val view = flutterView
    view.setZOrderMediaOverlay(true)
    view.holder.setFormat(PixelFormat.TRANSPARENT)
    // view.enableTransparentBackground()

    // get a wallpaper manager instance for this context
    wallpaperManager = WallpaperManager.getInstance(applicationContext)
    // Platform channels
    MethodChannel(flutterView, channelName).setMethodCallHandler { call, result ->
      if (call.method == "wallpaperEvent"){

        val args = call.arguments<ArrayList<Float>>()
        sendWallpaperEvents(args)
//        Log.d("MainActivity", args.toString())
        result.success(true)
      } else {
        result.notImplemented()
      }

    }
  }

  private fun sendWallpaperEvents(position:ArrayList<Float>){
    Log.d("MainActivity", "Sending a Wallpaper command")

    if (wallpaperManager.wallpaperInfo != null) {
//      Only send a command if it is a live wallpaper
      wallpaperManager.sendWallpaperCommand(
              flutterView.windowToken,
//            if (event.action == MotionEvent.ACTION_UP)
//              WallpaperManager.COMMAND_TAP else
//              WallpaperManager.COMMAND_SECONDARY_TAP,
              WallpaperManager.COMMAND_TAP,
              position[0].toInt(), position[1].toInt(), 0, null
      )
    }

  }
}
