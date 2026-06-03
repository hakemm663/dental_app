import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.docdoc.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    defaultConfig {
        // Base applicationId is overridden per-flavor via applicationIdSuffix.
        applicationId = "com.docdoc.app"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Default Maps key placeholder so AndroidManifest can reference
        // ${MAPS_API_KEY} on flavored builds without crashing when no key
        // is wired. Per-flavor blocks override this.
        manifestPlaceholders["MAPS_API_KEY"] = ""
    }

    // Flavor dimensions: a single "env" axis with dev / staging / production.
    // See https://docs.flutter.dev/deployment/flavors — the Flutter Gradle
    // plugin reads `--flavor` and matches it to one of these product flavors.
    flavorDimensions += "env"

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "DocDoc Dev")
            // Maps key for Android Maps SDK. Real values come from CI /
            // ~/.gradle/gradle.properties; empty otherwise so flavored
            // builds still complete without crashing the manifest merger.
            manifestPlaceholders["MAPS_API_KEY"] =
                (project.findProperty("MAPS_API_KEY_DEV") as String?) ?: ""
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "DocDoc Staging")
            manifestPlaceholders["MAPS_API_KEY"] =
                (project.findProperty("MAPS_API_KEY_STAGING") as String?) ?: ""
        }
        create("production") {
            dimension = "env"
            // No applicationIdSuffix — production keeps the bare applicationId.
            resValue("string", "app_name", "DocDoc")
            manifestPlaceholders["MAPS_API_KEY"] =
                (project.findProperty("MAPS_API_KEY_PROD") as String?) ?: ""
        }
    }

    buildTypes {
        release {
            // Fall back to debug signing when no keystore is configured.
            // APK builds (App Distribution, side-loading) work fine debug-signed.
            // The Play Store path is separately gated below — it refuses to
            // produce a production AAB without a real keystore.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // The Play Store-bound production AAB requires a real keystore (so the
    // app's signing identity stays stable across releases). APK builds
    // (`assembleProductionRelease`) are deliberately not gated — they're
    // used for Firebase App Distribution and side-loading, where debug
    // signing is fine.
    afterEvaluate {
        tasks
            .matching { it.name == "bundleProductionRelease" }
            .configureEach {
                doFirst {
                    if (!keystorePropertiesFile.exists()) {
                        throw GradleException(
                            "Refusing to build a production AAB for Play Store " +
                                "upload without android/key.properties. Provide " +
                                "the keystore, or use `assembleProductionRelease` " +
                                "/ App Distribution which falls back to debug signing."
                        )
                    }
                }
            }
    }
}

// Pin Gradle's build JDK to 21 (LTS). System JDK can be anything; the
// toolchain spec + the foojay resolver in settings.gradle.kts make Gradle
// locate or auto-download a JDK 21 to actually run the build.
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

flutter {
    source = "../.."
}
