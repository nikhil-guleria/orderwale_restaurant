package com.orderwale.merchant

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterFragmentActivity


class MainActivity: FlutterFragmentActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initNotificationChannel()
    }

    /*override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        initNotificationChannel()
    }*/

    private fun initNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val packageString = "android.resource://" + applicationContext.packageName + "/"
            val soundUri: Uri = Uri.parse(packageString + R.raw.orderwale)

            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build()

            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel("orderwalemerchant", "OrderWale", importance)
            mChannel.setSound(soundUri, audioAttributes)
            mChannel.lockscreenVisibility = 1
            mChannel.enableVibration(true)
            mChannel.enableLights(true)

            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
        }
    }
}
