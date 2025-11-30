plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")

    // 🔥 Plugin Google Services (WAJIB untuk Firebase)
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.weebsoul"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.weebsoul"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Firebase BoM (mengatur versi otomatis, WAJIB)
    implementation(platform("com.google.firebase:firebase-bom:34.6.0"))

    // 🔥 Tambahkan modul Firebase yang ingin kamu pakai
    // Authentication (login, register)
    implementation("com.google.firebase:firebase-auth")

    // Firestore (jika ingin database)
    implementation("com.google.firebase:firebase-firestore")

    // Storage (upload video)
    implementation("com.google.firebase:firebase-storage")
}
