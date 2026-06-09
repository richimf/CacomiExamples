package com.example.badpracticesappandroid.injection

import android.database.sqlite.SQLiteDatabase
import android.widget.EditText

/**
 * Familia 6: Inyeccion SQL (SQLRules / InjectionRules).
 */
object SqlInjection {

    // BAD/TAINT intra-archivo: fuente (EditText.getText) fluye al sink (rawQuery) sin sanitizar
    // CACOMI-EXPECT: TaintAnalyzer/SQLRules
    fun searchFromInput(db: SQLiteDatabase, field: EditText) {
        val tainted = field.text.toString()                       // SOURCE
        db.rawQuery("SELECT * FROM users WHERE name = '$tainted'", null) // SINK
    }

    // BAD: rawQuery con concatenacion de input // CACOMI-EXPECT: SQLRules
    fun lookup(db: SQLiteDatabase, userInput: String) {
        val query = "SELECT * FROM users WHERE name = '" + userInput + "'"
        db.rawQuery(query, null)
    }

    // BAD: execSQL con concatenacion de input // CACOMI-EXPECT: SQLRules
    fun delete(db: SQLiteDatabase, id: String) {
        db.execSQL("DELETE FROM users WHERE id = " + id)
    }

    // NEGATIVO: query parametrizada con placeholders // CACOMI-EXPECT: none
    fun safeLookup(db: SQLiteDatabase, userInput: String) {
        db.rawQuery("SELECT * FROM users WHERE name = ?", arrayOf(userInput))
    }
}
