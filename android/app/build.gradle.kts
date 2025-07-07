plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.clo_chat_v3"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.clo_chat_v3"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true // ✅ Needed for flutter_local_notifications
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // ⚠️ Replace with actual release signing config before production
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Use Firebase BoM to manage all versions
    implementation(platform("com.google.firebase:firebase-bom:33.1.0"))

    // 🔥 Firebase dependencies (version managed by BoM)
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-storage")
    implementation("com.google.firebase:firebase-messaging")

    // 🔐 Sign-in & Identity (stable versions that exist on Maven Central)
    implementation("androidx.credentials:credentials:1.2.0")
    implementation("androidx.credentials:credentials-play-services-auth:1.2.0")

    // ❌ Removed: com.google.android.libraries.identity.googleid
    // Reason: This library is **not available on Maven Central** or Google's Maven — it's causing the build to fail.

    // ✅ Java 8+ desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
