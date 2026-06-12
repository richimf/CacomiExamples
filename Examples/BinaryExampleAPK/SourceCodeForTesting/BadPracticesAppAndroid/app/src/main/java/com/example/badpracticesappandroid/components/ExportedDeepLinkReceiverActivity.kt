package com.example.badpracticesappandroid.components

import android.app.Activity
import android.os.Bundle

/**
 * BAD: Activity exportada sin permiso que responde a un intent-filter de accion personalizada.
 * Cualquier app en el dispositivo puede invocarla y pasarle extras arbitrarios.
 * CACOMI-EXPECT: ExportedComponent
 */
// BAD: Activity exportada sin android:permission // CACOMI-EXPECT: ExportedComponent
class ExportedDeepLinkReceiverActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Intent data no validado — ver UnsafeDeepLinkParsing para los riesgos asociados
    }
}
