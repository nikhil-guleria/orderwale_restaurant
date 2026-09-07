package com.hiennv.flutter_callkit_incoming

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.text.TextUtils
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.UUID

class MyWorker(context: Context, workerParams: WorkerParameters) :
    Worker(context, workerParams) {

    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null
    private var audioManager: AudioManager? = null

    override fun doWork(): Result {
        // Retrieve the data sent to the Worker
        val ringtonePath = inputData.getString(CallkitConstants.EXTRA_CALLKIT_RINGTONE_PATH) ?: ""

        try {
            playSound(ringtonePath)
            playVibration()
            while (!isStopped) {
                Thread.sleep(100)
            }
            mediaPlayer?.stop()
            mediaPlayer?.release()
            vibrator?.cancel()
        } catch (e: Exception) {
            e.printStackTrace()
            return Result.failure()
        }
        return Result.success()
    }

    private fun playSound(ringtonePath: String) {
        val uri = getRingtoneUri(ringtonePath)
            ?: RingtoneManager.getActualDefaultRingtoneUri(
                applicationContext,
                RingtoneManager.TYPE_RINGTONE
            )

        try {
            mediaPlayer = MediaPlayer().apply {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    setAudioAttributes(
                        AudioAttributes.Builder()
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                            .build()
                    )
                } else {
                    setAudioStreamType(AudioManager.STREAM_RING)
                }
                setDataSource(applicationContext, uri)
                isLooping = true
                prepare()
                start()
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    private fun playVibration() {
        vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager =
                applicationContext.getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            applicationContext.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }

        if (vibrator == null) {
            Log.e("MyWorker", "Vibrator is null!")
            return
        }

        audioManager = applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        if (audioManager?.ringerMode != AudioManager.RINGER_MODE_SILENT) {
            Log.d("MyWorker", "Vibration starting...")
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vibrator?.vibrate(
                    VibrationEffect.createWaveform(longArrayOf(0L, 1000L, 1000L), 0)
                )
            } else {
                @Suppress("DEPRECATION")
                vibrator?.vibrate(longArrayOf(0L, 1000L, 1000L), 0)
            }
        } else {
            Log.d("MyWorker", "Device is in silent mode, vibration skipped.")
        }
    }


    private fun getRingtoneUri(fileName: String): Uri? {
        return try {
            if (TextUtils.isEmpty(fileName)) {
                RingtoneManager.getActualDefaultRingtoneUri(
                    applicationContext,
                    RingtoneManager.TYPE_RINGTONE
                )
            } else {
                val resId = applicationContext.resources.getIdentifier(fileName, "raw", applicationContext.packageName)
                if (resId != 0) {
                    Uri.parse("android.resource://${applicationContext.packageName}/$resId")
                } else {
                    null
                }
            }
        } catch (e: Exception) {
            null
        }
    }

    override fun onStopped() {
        super.onStopped()
        mediaPlayer?.stop()
        mediaPlayer?.release()
        vibrator?.cancel()
    }
}
