package com.example.badpracticesappandroid.injection

/**
 * Familia 6: Inyeccion de comandos (InjectionRules).
 */
object CommandInjection {

    // BAD: Runtime.exec con input no confiable // CACOMI-EXPECT: InjectionRules
    fun runtimeExec(userInput: String) {
        Runtime.getRuntime().exec("sh -c ping " + userInput)
    }

    // BAD: ProcessBuilder con input no confiable // CACOMI-EXPECT: InjectionRules
    fun processBuilder(userInput: String) {
        ProcessBuilder("sh", "-c", "echo " + userInput).start()
    }
}
