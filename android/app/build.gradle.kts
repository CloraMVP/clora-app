plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // ✅ Firebase plugin
    id("dev.flutter.flutter-gradle-plugin") // ✅ Flutter plugin
}

android {
    namespace = "com.example.clo_chat_v3"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.clo_chat_v3"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode() // ✅ Correct Kotlin DSL
        versionName = flutter.versionName() // ✅ Correct Kotlin DSL
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // ⚠️ Use debug signing only for dev/testing
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
