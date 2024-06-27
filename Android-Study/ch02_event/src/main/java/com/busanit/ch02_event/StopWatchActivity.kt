package com.busanit.ch02_event

import android.os.Bundle
import android.os.SystemClock
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.busanit.ch02_event.databinding.ActivityStopWatchBinding

class StopWatchActivity : AppCompatActivity() {

    var initTime = 0L   // 초기 시간
    var pauseTime = 0L  // 멈춘 시각
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivityStopWatchBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // SystemClock.elapsedRealtime() : 안드로이드 시스템 시간 측정 함수
        // 시스템 부팅 후 경과시간을 ms 로 반환, 이벤트 간격이나 시간 측정 시 사용

        // Chronometer : 시간을 사용하는 데 사용하는 UI 위젯
        // 시간의 경과를 초 단위로 보여줌
        // chronometer.base 에 값을 설정하고 start() stop() 으로 타이머 제어

        binding.btnStart.setOnClickListener {
            binding.chronometer.base = SystemClock.elapsedRealtime() + pauseTime
            binding.chronometer.start()
            // 버튼 표시여부 조정
            binding.btnStart.isEnabled = false
            binding.btnStop.isEnabled = true
            binding.btnReset.isEnabled = true
        }
        binding.btnStop.setOnClickListener {
            pauseTime = binding.chronometer.base - SystemClock.elapsedRealtime()
            binding.chronometer.stop()

            binding.btnStart.isEnabled = true
            binding.btnStop.isEnabled = false
            binding.btnReset.isEnabled = true
        }
        binding.btnReset.setOnClickListener {
            binding.chronometer.base = SystemClock.elapsedRealtime()
            binding.chronometer.stop()
            pauseTime = 0L

            binding.btnStart.isEnabled = true
            binding.btnStop.isEnabled = true
            binding.btnReset.isEnabled = false
        }
    }
}