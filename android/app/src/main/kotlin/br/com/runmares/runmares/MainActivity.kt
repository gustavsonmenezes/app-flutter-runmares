package br.com.runmares.runmares

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestPermission" -> requestNotificationPermission(result)
                    "openSettings" -> openNotificationSettings(result)
                    else -> result.notImplemented()
                }
            }
    }

    private fun requestNotificationPermission(result: MethodChannel.Result) {
        // Antes do Android 13 a permissão é concedida na instalação.
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            result.success(GRANTED)
            return
        }

        val permission = Manifest.permission.POST_NOTIFICATIONS
        if (checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED) {
            result.success(GRANTED)
            return
        }

        if (pendingResult != null) {
            result.error("request_in_progress", "Já existe um pedido em andamento.", null)
            return
        }

        pendingResult = result
        requestPermissions(arrayOf(permission), REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode != REQUEST_CODE) return

        val result = pendingResult ?: return
        pendingResult = null

        val granted = grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        if (granted) {
            result.success(GRANTED)
            return
        }

        // Depois de uma recusa, se o sistema não vai mais mostrar a explicação,
        // o pedido está bloqueado e só as configurações do aparelho resolvem.
        val canAskAgain =
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
                    shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS)
        result.success(if (canAskAgain) DENIED else PERMANENTLY_DENIED)
    }

    private fun openNotificationSettings(result: MethodChannel.Result) {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, packageName)
        }
        try {
            startActivity(intent)
            result.success(true)
        } catch (error: Exception) {
            result.success(false)
        }
    }

    private companion object {
        const val CHANNEL = "br.com.runmares/notifications"
        const val REQUEST_CODE = 4711
        const val GRANTED = "granted"
        const val DENIED = "denied"
        const val PERMANENTLY_DENIED = "permanentlyDenied"
    }
}