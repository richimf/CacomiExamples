package com.example.badpracticesappandroid.unused

import androidx.annotation.Keep
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import javax.inject.Inject

/**
 * Familia 1 (NEGATIVOS): simbolos que PARECEN no usados pero NO deben marcarse.
 * CACOMI-EXPECT: none
 */

// NEGATIVO: @Keep evita que se considere muerto aunque no haya referencias directas
@Keep
fun keptFunctionForReflection(): String = "kept"

// NEGATIVO: clase cargada por reflexion (referenciada en proguard-rules.pro)
@Keep
class ReflectivelyLoaded {
    fun ping(): String = "pong"
}

// NEGATIVO: simbolo inyectado por DI (@Inject) — no debe marcarse como no usado
class PaymentProcessor @Inject constructor() {
    fun process(amount: Long): Boolean = amount > 0
}

// NEGATIVO: @Composable / @Preview — invocados por el toolkit, no por llamada directa
@Composable
fun UnusedLookingComposable() {
}

@Preview
@Composable
fun UnusedLookingComposablePreview() {
    UnusedLookingComposable()
}

// NEGATIVO: cargado dinamicamente por reflexion en runtime
fun loadByReflection(): Any {
    val clazz = Class.forName("com.example.badpracticesappandroid.unused.ReflectivelyLoaded")
    return clazz.getDeclaredConstructor().newInstance()
}
