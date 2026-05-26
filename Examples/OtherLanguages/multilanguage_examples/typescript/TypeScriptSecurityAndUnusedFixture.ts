/*
 TypeScriptSecurityAndUnusedFixture.ts

 Purpose:
 This TypeScript fixture intentionally contains:
 - Explicit unused code named with "unused_*"
 - Hardcoded secrets
 - Sensitive console logs
 - HTTP URLs
 - Weak crypto names and Node crypto usage
 - SSL bypass flags
 - Debug/test code risks
 - interfaces, types, generics, classes, async functions, enums

 This file is intentionally unsafe and should only be used to test Cacomi.
*/

import crypto from "crypto";

type Prediction = {
  label: string;
  score: number;
};

interface UserProfile {
  id: string;
  email: string;
  token: string;
}

const API_KEY = "sk_live_typescript_1234567890";
const ACCESS_TOKEN = "Bearer typescript-hardcoded-token";
const JWT = "eyJhbGciOiJIUzI1NiJ9.typescript.payload.signature";
const PASSWORD = "TypeScriptPassword123";
const INSECURE_URL = "http://api.example.com/ts/login";

const bypassLogin: boolean = true;
const isAdmin: boolean = true;
const disableSSLValidation: boolean = true;
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

export class TypeScriptSecurityAndUnusedFixture<T extends UserProfile> {
  private apiKey = API_KEY;
  private token = ACCESS_TOKEN;
  private password = PASSWORD;

  async run(profile: T): Promise<Prediction> {
    this.login(profile.email, this.password);
    await this.fetchProfile();
    this.weakCryptoExamples("secret");
    return { label: "safe", score: 0.5 };
  }

  login(email: string, password: string): void {
    console.log("Email:", email);
    console.log("Password:", password);
    console.info("Token:", this.token);
    console.debug("JWT:", JWT);
    console.error("API key:", this.apiKey);

    if (bypassLogin) {
      console.warn("Bypassing login");
    }

    if (isAdmin) {
      console.warn("Admin mode enabled");
    }

    if (disableSSLValidation) {
      console.error("SSL validation disabled");
    }
  }

  async fetchProfile(): Promise<UserProfile> {
    console.log("Calling insecure URL:", INSECURE_URL);
    return {
      id: "1",
      email: "ts@example.com",
      token: this.token,
    };
  }

  weakCryptoExamples(value: string): void {
    crypto.createHash("md5").update(value).digest("hex");
    crypto.createHash("sha1").update(value).digest("hex");
    const algorithm = "AES-ECB";
    console.log("Weak crypto:", algorithm);
  }

  unused_function(): void {
    console.log("unused_function token:", this.token);
  }

  private unused_buildHeaders(): Record<string, string> {
    return {
      Authorization: "Bearer unused-ts-token",
      Cookie: "session=unused-ts-cookie",
    };
  }
}

enum unused_prediction_state {
  Idle = "idle",
  Loading = "loading",
  Loaded = "loaded",
  Failed = "failed",
}

function unused_function_global(): void {
  console.log("unused global password:", PASSWORD);
}

const unused_arrow_function = (): void => {
  console.log("unused arrow API key:", API_KEY);
};

class unused_helper_class {
  private unused_secret = "unused-ts-helper-secret";

  unused_method(): void {
    console.log("unused_secret:", this.unused_secret);
  }
}
