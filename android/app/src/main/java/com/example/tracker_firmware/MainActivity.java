package com.example.tracker_firmware;

import android.provider.Settings;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "dev_options_channel";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("checkDevOptions")) {
                                int devOptions = Settings.Secure.getInt(
                                        getContentResolver(),
                                        Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0
                                );
                                int adbEnabled = Settings.Global.getInt(
                                        getContentResolver(),
                                        Settings.Global.ADB_ENABLED, 0
                                );
                                result.success(devOptions != 0 || adbEnabled != 0);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}

