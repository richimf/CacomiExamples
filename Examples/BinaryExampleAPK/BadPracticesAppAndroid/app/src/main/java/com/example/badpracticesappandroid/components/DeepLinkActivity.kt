package com.example.badpracticesappandroid.components

import android.app.Activity
import android.os.Bundle
import com.example.badpracticesappandroid.injection.TaintSink

/**
 * Activity destino de un App Link (http/https) declarado SIN autoVerify.
 * Sirve ademas como FUENTE de taint cross-file: lee datos no confiables del Intent
 * y los pasa a TaintSink (en otro archivo) sin sanitizar.
 */
class DeepLinkActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // BAD/TAINT-SOURCE: input no confiable desde el Intent // CACOMI-EXPECT: InjectionRules/Taint
        val userId = intent?.getStringExtra("userId") ?: ""
        val targetUrl = intent?.data?.toString() ?: ""

        // El sink esta en injection/TaintSink.kt (cross-file)
        TaintSink.runUnsanitized(this, userId, targetUrl)
    }
}
