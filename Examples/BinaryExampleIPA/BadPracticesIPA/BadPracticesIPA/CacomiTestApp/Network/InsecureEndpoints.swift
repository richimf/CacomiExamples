//
//  InsecureEndpoints.swift
//  CacomiTestApp
//
//  Fixtures for insecureHTTP detection and EndpointInventory.
//

import Foundation

enum InsecureEndpoints {
    // CACOMI-EXPECT[insecureHTTP|high]: cleartext HTTP staging endpoint
    static let stagingAPI = "http://staging.fake-cacomi.com/api/v1"

    // CACOMI-EXPECT[insecureHTTP|high]: cleartext HTTP dev endpoint
    static let devLogs = "http://dev-logs.fake-cacomi.local/ingest"

    // CACOMI-EXPECT[insecureHTTP|critical]: URL contains embedded credentials
    static let withCredentials = "http://admin:admin@legacy.fake-cacomi.com/login"

    // CACOMI-NEGATIVE[insecureHTTP]: production HTTPS endpoint, inventory-only
    static let productionAPI = "https://api.fake-cacomi.com/v1"
}
