# Reglas ProGuard/R8 del banco de pruebas BadPracticesAppAndroid.
# BAD: reglas que anulan la ofuscacion // CACOMI-EXPECT: ProGuardRule

# BAD: desactiva la ofuscacion por completo
-dontobfuscate

# BAD: keep demasiado amplio que conserva TODO (anula shrink/obfuscation)
-keep class ** { *; }
-keepclassmembers class ** { *; }

# BAD: desactiva optimizaciones y warnings (oculta problemas)
-dontoptimize
-dontwarn **

# NEGATIVO/legitimo: keep acotado para una clase concreta usada por reflexion // CACOMI-EXPECT: none
-keep class com.example.badpracticesappandroid.unused.ReflectivelyLoaded { *; }
