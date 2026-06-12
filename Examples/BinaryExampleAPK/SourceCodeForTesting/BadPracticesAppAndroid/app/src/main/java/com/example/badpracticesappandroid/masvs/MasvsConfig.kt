package com.example.badpracticesappandroid.masvs

/**
 * Familia 15: MASVS extra (MobileMisuse).
 * Configuracion tipo introspeccion GraphQL / playground habilitada.
 */
object MasvsConfig {
    // BAD: introspeccion y playground GraphQL habilitados // CACOMI-EXPECT: MobileMisuse
    const val GRAPHQL_CONFIG = """{ "introspection": true, "playground": true, "graphiql": true }"""
    const val GRAPHQL_ENDPOINT = "https://api.example.com/graphql"
    const val PLAYGROUND_ENABLED = true
}
