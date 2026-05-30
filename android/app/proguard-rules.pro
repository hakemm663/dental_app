# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter's PlayStoreDeferredComponentManager references Play Core classes
# even when no deferred components are used. We don't ship deferred
# components, so silence the missing-class warnings instead of pulling in
# the play:feature-delivery dependency.
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Firebase / Google Play services occasionally trip on optional services.
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Dio / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# Kotlin Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}

# Keep app model classes
-keep class com.docdoc.app.** { *; }
