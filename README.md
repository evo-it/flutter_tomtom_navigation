Which can just go into the README. To get the package working for our app, I had to perform the following steps:
# Required
* Add `packagingOptions` to the app/build.gradle (as per TT docs)
```
    packagingOptions {
        jniLibs.pickFirsts.add("lib/**/libc++_shared.so")
    }
```
* Add `maven` dependency to android/build.gradle (as per TT docs)
```
        maven {
            url = uri("https://repositories.tomtom.com/artifactory/sdk-maven")
        }
```
* Change the `MainActivity.kt` from a `FlutterActivity` to a `FlutterFragmentActivity`:
```kotlin
package com.example.myapp

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
}

```

# Optional(?)
I also did the following (which may or may not be required)
* Open the project in Android Studio by opening the `android` subfolder as a project, build the app from there, and run the AGP upgrade assistant to go from `7.0.4` --> `7.4.2`
* In android/gradle.properties increase the maximum memory available `org.gradle.jvmargs=-Xmx1536M` --> `Xmx4G`
* Do **not** update the `appCompatVersion` defined in android/build.gradle from `1.5.0` to `1.6.1`, this caused some strange errors processing the resources (like themes and icons) of the app

# Some settings
* Java version: `openjdk 17.0.1` (Microsoft OpenJDK)
* CompileSdk 33, targetSdk 34
* Kotlin version 1.8.21
* Google Services version 4.3.3
