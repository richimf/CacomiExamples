// SecretsMaskingShowcase.swift
//
// Validation fixture for Cacomi's secret DETECTION + MASKING (CR-1 / H-4).
//
// EVERY value below is FAKE and exists only to exercise the scanner.
// Ground truth: each line must be reported as a hardcoded-secret finding,
// AND its inline preview / clipboard copy / exported report must show the
// value MASKED (a short head/tail hint at most), never the full secret.
// The verbatim value may appear ONLY behind the explicit "Reveal" action.
//
// See ../EXPECTED.md for the per-line ground truth.

import Foundation

enum FakeCredentials {
    // EXPECT: hardcodedSecret (critical) · masked, e.g. "AKIA**********MPLE"
    static let awsKeyID = "AKIAIOSFODNN7EXAMPLE"

    // EXPECT: hardcodedSecret (critical) · masked
    static let stripeLive = "sk_live_4eC39HqLyjWDarjtT1zdp7dcFAKEFAKE00"

    // EXPECT: hardcodedSecret (high) · masked
    static let githubToken = "ghp_000000000000000000000000000000000000"

    // EXPECT: hardcodedSecret (critical) · masked (host kept, creds masked)
    static let dbURL = "postgres://admin:s3cr3tFAKE@db.internal:5432/app"

    // EXPECT: hardcodedSecret (high) · masked
    static let bearer = "Authorization: Bearer eyJ0eXAiOiJKV1QiFAKE.payloadpartFAKE.signaturepartFAKE"

    // EXPECT: hardcodedSecret (critical) · the PEM BODY must be masked in the
    // inline preview; the BEGIN/END markers may remain. Full block only via
    // the explicit "View full key value" sheet.
    static let pemPrivateKey = """
    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEA0FAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKEFAKE
    fakekeybodyline2fakekeybodyline2fakekeybodyline2fakekeybodyline20
    -----END RSA PRIVATE KEY-----
    """
}
