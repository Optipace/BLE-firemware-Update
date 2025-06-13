bundle id  com.example.tracker_firmware;
-----------------------------------------------
flutter doctor --verbose
[!] Flutter (Channel stable, 3.10.6, on Microsoft Windows [Version 10.0.26100.3915], locale en-US)
• Flutter version 3.10.6 on channel stable at C:\AndroidStudio\SDK\flutter_3.10.6\flutter
! Warning: `flutter` on your path resolves to C:\AndroidStudio\SDK\flutter_windows_Latest\flutter\bin\flutter, which is not inside your current Flutter SDK checkout at C:\AndroidStudio\SDK\flutter_3.10.6\flutter. Consider adding C:\AndroidStudio\SDK\flutter_3.10.6\flutter\bin to the front of your path.
! Warning: `dart` on your path resolves to C:\AndroidStudio\SDK\flutter_windows_Latest\flutter\bin\dart, which is not inside your current Flutter SDK checkout at C:\AndroidStudio\SDK\flutter_3.10.6\flutter. Consider adding C:\AndroidStudio\SDK\flutter_3.10.6\flutter\bin to the front of your path.
• Upstream repository https://github.com/flutter/flutter.git
• Framework revision f468f3366c (1 year, 11 months ago), 2023-07-12 15:19:05 -0700
• Engine revision cdbeda788a
• Dart version 3.0.6
• DevTools version 2.23.1
• If those were intentional, you can disregard the above warnings; however it is recommended to use "git" directly to perform update checks and upgrades.

[√] Windows Version (Installed version of Windows is version 10 or higher)
-----------------------------------------------
ANDROID gradle
-----------------------------------------------
    dependencies {
        classpath 'com.android.tools.build:gradle:7.1.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.10' // or latest version
    }
-----------------------------------------------


