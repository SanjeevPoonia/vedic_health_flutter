# --- Stripe SDK Fix ---
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
-keepclassmembers class * {
    @com.stripe.android.view.CardInputListener *;
}

# --- React Native Stripe SDK Fix ---
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# --- Prevent removal of PushProvisioning classes ---
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**
