package com.example.badpracticesappandroid.unused

// BAD: import no usado // CACOMI-EXPECT: UnusedCode
import android.util.Base64

/**
 * Familia 1: Codigo no usado (UnusedCode).
 * Todos los simbolos de este archivo son privados/no referenciados a proposito.
 */

// BAD: funcion top-level no usada // CACOMI-EXPECT: UnusedCode
fun unused_sumFunction(a: Int, b: Int): Int = a + b

// BAD: funcion privada no usada // CACOMI-EXPECT: UnusedCode
private fun unusedPrivateHelper(): String = "never called"

// BAD: const no usada // CACOMI-EXPECT: UnusedCode
private const val UNUSED_CONST = "dead-constant"

// BAD: val top-level no usado // CACOMI-EXPECT: UnusedCode
private val unusedTopLevelVal = 42

// BAD: clase no usada // CACOMI-EXPECT: UnusedCode
class UnusedClass {
    // BAD: propiedad privada no usada // CACOMI-EXPECT: UnusedCode
    private val unusedField: String = "dead"
}

// BAD: object no usado // CACOMI-EXPECT: UnusedCode
object UnusedObject {
    fun unusedMethod() = Unit
}

// BAD: data class no usada // CACOMI-EXPECT: UnusedCode
data class UnusedDataClass(val id: Int, val name: String)

// BAD: enum no usado // CACOMI-EXPECT: UnusedCode
enum class UnusedEnum { ALPHA, BETA, GAMMA }

// BAD: extension function no usada // CACOMI-EXPECT: UnusedCode
fun String.unusedExtension(): String = this.reversed()
