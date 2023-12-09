package com.rmsl.juce;

import android.content.Context;
import android.os.Looper;
import android.os.Handler;


public class Java
{
    static
    {
        System.loadLibrary ("Launchpad_Connector_Library");
    }

    public native static void initialiseJUCE (Context appContext);
    //public native static void juceInit (Context appContext);
    public native static void messagesThreadRun();

    static Handler mHandler = new Handler(Looper.getMainLooper());
    static LooperThread looperThread;

    public static void test()
    {
        LooperThread looperThread = new LooperThread();
        looperThread.start();
    }

    public static class LooperThread extends Thread
    {
        public Handler mHandler;

        public void run() {
            Looper.prepare();
            messagesThreadRun();
            mHandler = new Handler(Looper.myLooper());
            Looper.loop();
        }
    }
}