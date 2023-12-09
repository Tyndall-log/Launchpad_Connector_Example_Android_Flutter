package com.example.launchpad

import android.os.Bundle
import com.rmsl.juce.Java
import com.rmsl.juce.Java.LooperThread
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 네이티브 메소드 호출
        Java.initialiseJUCE(this)
        //Java.juceInit(this)

        Java.test()
    }
}
