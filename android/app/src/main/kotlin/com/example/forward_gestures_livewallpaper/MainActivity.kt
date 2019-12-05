package com.example.forward_gestures_livewallpaper

import android.app.WallpaperManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
//import android.graphics.Color
import android.graphics.PixelFormat
import android.os.Build
import android.os.Bundle
//import android.util.Log
import androidx.annotation.Size

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    // https://flutter.dev/docs/development/platform-integration/platform-channels#example-kotlin
    private val channelName = "com.example.forward_gestures_livewallpaper/wallpapers"
    private val eventChannelName = "com.example.forward_gestures_livewallpaper/events"
    private lateinit var wallpaperManager: WallpaperManager
//    private val tag = "MainActivity"

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
            if (call.method == "wallpaperCommand") {
                val args = call.arguments<ArrayList<Float>>()
                sendWallpaperEvents(args)
//                Log.d(tag, args.toString())
                result.success(true)
            } else if (call.method == "wallpaperColors") {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
                    val ret = getColors()
                    if (ret == null) {
                        result.error("failed", "couldn't get the colors", null)
                    } else
                        result.success(ret)
                } else
                    result.error("notImplemented", "requires api 27", null)
            } else if (call.method == "setWallpaperOffsets") {
                @Size(2)
                val args = call.arguments<ArrayList<Float>>()
//                Log.d(tag, args.toString())

                val position = args[0]
                var numPages = args[1]

                if (numPages <= 1) {
                    numPages = 2F
                }

                val xOffset = position / (numPages - 1)
                wallpaperManager.setWallpaperOffsets(flutterView.windowToken, xOffset, 0.0f)

            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterView, eventChannelName).setStreamHandler(WallpaperListener())
    }

    // https://medium.com/flutter/flutter-platform-channels-ce7f540a104e
    inner class WallpaperListener : EventChannel.StreamHandler {
        private var eventSink: EventChannel.EventSink? = null
        private lateinit var myReceiver: MyReceiver

        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
            registerIfActive()
        }

        override fun onCancel(arguments: Any?) {
            unregisterIfActive()
            eventSink = null
        }

        private fun registerIfActive() {
            if (eventSink == null) return

            // https://www.techotopia.com/index.php/Android_Broadcast_Intents_and_Broadcast_Receivers
            val intentFilter = IntentFilter()
            intentFilter.addAction(Intent.ACTION_WALLPAPER_CHANGED)
            myReceiver = MyReceiver()
            registerReceiver(myReceiver, intentFilter)
        }

        private fun unregisterIfActive() {
            if (eventSink == null) return
            unregisterReceiver(myReceiver)
        }

        inner class MyReceiver : BroadcastReceiver() {
            override fun onReceive(p0: Context?, p1: Intent?) {
                eventSink?.success(true)
            }
        }
    }


    private fun getColors(): ArrayList<Int?>? {
        val data = (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            wallpaperManager.getWallpaperColors(WallpaperManager.FLAG_SYSTEM)
        } else {
            null
        }) ?: return null

//        Log.d(tag, "${data.primaryColor.red()} ${data.primaryColor.green()} ${data.primaryColor.blue()} ${data.primaryColor.alpha()}")
        val colors = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            arrayOf(data.primaryColor.toArgb(), data.secondaryColor?.toArgb(), data.tertiaryColor?.toArgb())
        } else {
            arrayOf()
        }
        return ArrayList(colors.asList())
    }

    private fun sendWallpaperEvents(position: ArrayList<Float>) {
//        Log.d(tag, "Sending a Wallpaper command")

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
