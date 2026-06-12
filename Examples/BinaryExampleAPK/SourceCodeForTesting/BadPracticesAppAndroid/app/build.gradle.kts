plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.compose)
}

android {
    namespace = "com.example.badpracticesappandroid"
    compileSdk {
        version = release(36) {
            minorApiLevel = 1
        }
    }

    defaultConfig {
        applicationId = "com.example.badpracticesappandroid"
        minSdk = 33
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

        // BAD: secretos dummy expuestos via BuildConfig (sobreviven al DEX) // CACOMI-EXPECT: SecretPattern/HighEntropy
        buildConfigField("String", "API_SECRET", "\"AKIAIOSFODNN7EXAMPLE\"") // fake AWS-style key (dummy)
        buildConfigField("String", "JWT_SIGNING_KEY", "\"changeme\"")        // fake JWT secret (dummy)

        // Codigo nativo inseguro (UnsafeCAPIRule). Requiere NDK + CMake instalados.
        externalNativeBuild {
            cmake {
                cppFlags += "-std=c++17"
            }
        }
        ndk {
            abiFilters += listOf("arm64-v8a", "x86_64")
        }
    }

    // Compila app/src/main/cpp dentro de libbadpractices.so
    externalNativeBuild {
        cmake {
            path = file("src/main/cpp/CMakeLists.txt")
            version = "3.22.1"
        }
    }

    buildTypes {
        release {
            // BAD: release sin shrink/ofuscacion de R8 // CACOMI-EXPECT: ProGuardRule
            isMinifyEnabled = false
            optimization {
                enable = false
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    buildFeatures {
        compose = true
        buildConfig = true // habilitado para exponer secretos via BuildConfig
    }
}

dependencies {
    implementation(platform(libs.androidx.compose.bom))
    implementation(libs.androidx.activity.compose)
    implementation(libs.androidx.compose.material3)
    implementation(libs.androidx.compose.ui)
    implementation(libs.androidx.compose.ui.graphics)
    implementation(libs.androidx.compose.ui.tooling.preview)
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.lifecycle.runtime.ktx)
    // BAD: cliente HTTP usado sin certificate pinning // CACOMI-EXPECT: ResilienceAbsence
    implementation(libs.okhttp)
    // BAD/SCA: dependencia con vulnerabilidad conocida (CVE-2015-7501) // CACOMI-EXPECT: OSV-SCA
    implementation(libs.commons.collections)
    // Soporte: anotacion @Inject para el caso NEGATIVO de DI (no debe marcarse como no usado)
    implementation(libs.javax.inject)
    testImplementation(libs.junit)
    androidTestImplementation(platform(libs.androidx.compose.bom))
    androidTestImplementation(libs.androidx.compose.ui.test.junit4)
    androidTestImplementation(libs.androidx.espresso.core)
    androidTestImplementation(libs.androidx.junit)
    debugImplementation(libs.androidx.compose.ui.test.manifest)
    debugImplementation(libs.androidx.compose.ui.tooling)
}