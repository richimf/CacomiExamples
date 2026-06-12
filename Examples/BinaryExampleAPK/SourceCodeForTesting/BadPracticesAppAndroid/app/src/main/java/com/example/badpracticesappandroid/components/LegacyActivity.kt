package com.example.badpracticesappandroid.components

import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.view.View
import com.example.badpracticesappandroid.R

/**
 * Activity clasica con un boton cuyo onClick se enlaza desde XML.
 */
class LegacyActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_legacy)
    }

    // NEGATIVO: este metodo SOLO se invoca via android:onClick en activity_legacy.xml.
    // Cacomi NO debe marcarlo como no usado. // CACOMI-EXPECT: none
    fun handleLegacyClick(view: View) {
        Log.d("LegacyActivity", "button clicked: ${view.id}")
    }
}
