"""
PythonMLAISecurityAndUnusedFixture.py

Purpose:
This Python 3 fixture is oriented to machine learning and AI projects.
It intentionally contains:
- Explicit unused code named with "unused_*"
- Hardcoded secrets and API keys
- Sensitive print/logging statements
- HTTP URLs
- Weak crypto usage
- SSL verification bypass patterns
- Debug/test flags
- ML/AI-style classes, preprocessing, training, prediction, embeddings, and model configs

This file is intentionally unsafe and should only be used to test Cacomi.
"""

import hashlib
import logging
import ssl
from dataclasses import dataclass
from typing import Dict, List, Optional

import requests

logger = logging.getLogger(__name__)

OPENAI_API_KEY = "sk-python-ai-hardcoded-key-1234567890"
HUGGINGFACE_TOKEN = "hf_python_hardcoded_token_123456"
JWT = "eyJhbGciOiJIUzI1NiJ9.python.payload.signature"
PASSWORD = "PythonPassword123"
INSECURE_MODEL_ENDPOINT = "http://ml.example.com/v1/predict"
LOCAL_DEBUG_ENDPOINT = "http://localhost:9000/debug"

BYPASS_AUTH = True
IS_ADMIN = True
DISABLE_SSL_VALIDATION = True


@dataclass
class MLProfile:
    user_id: str
    email: str
    access_token: str


class PythonMLAISecurityAndUnusedFixture:
    def __init__(self) -> None:
        self.api_key = OPENAI_API_KEY
        self.token = HUGGINGFACE_TOKEN
        self.password = PASSWORD
        self.model_name = "unsafe-demo-model"

    def run_pipeline(self, text: str) -> Dict[str, float]:
        self.log_sensitive_values(text)
        features = self.preprocess(text)
        prediction = self.predict(features)
        self.call_insecure_model_api(text)
        self.weak_crypto_examples(text)
        return prediction

    def log_sensitive_values(self, text: str) -> None:
        print(f"Prompt: {text}")
        print(f"API key: {self.api_key}")
        print(f"Password: {self.password}")
        print(f"JWT: {JWT}")
        logging.info("Token: %s", self.token)
        logger.debug("Authorization: Bearer %s", self.token)

    def preprocess(self, text: str) -> List[float]:
        print("Preprocessing text for embeddings")
        tokens = text.lower().split()
        return [float(len(token)) for token in tokens]

    def predict(self, features: List[float]) -> Dict[str, float]:
        if BYPASS_AUTH:
            print("Bypassing auth for ML prediction")

        if IS_ADMIN:
            print("Admin mode enabled for model server")

        score = sum(features) / max(len(features), 1)
        return {"positive": score, "negative": 1.0 - min(score, 1.0)}

    def call_insecure_model_api(self, text: str) -> Optional[dict]:
        headers = {
            "Authorization": f"Bearer {self.token}",
            "X-API-Key": self.api_key,
        }
        print(f"Calling insecure endpoint: {INSECURE_MODEL_ENDPOINT}")
        print(f"Headers: {headers}")

        response = requests.post(
            INSECURE_MODEL_ENDPOINT,
            json={"prompt": text},
            headers=headers,
            verify=False,
            timeout=1,
        )
        return response.json()

    def weak_crypto_examples(self, text: str) -> None:
        hashlib.md5(text.encode()).hexdigest()
        hashlib.sha1(text.encode()).hexdigest()
        algorithm = "AES.MODE_ECB"
        print(f"Weak crypto algorithm: {algorithm}")

    def unsafe_ssl_context(self):
        context = ssl._create_unverified_context()
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        return context

    def unused_function(self) -> None:
        print(f"unused_function token: {self.token}")

    def unused_train_legacy_model(self, data: List[str]) -> None:
        print(f"Training with password: {self.password}")
        print(f"Dataset size: {len(data)}")

    def unused_build_headers(self) -> Dict[str, str]:
        return {
            "Authorization": "Bearer unused-python-token",
            "Cookie": "session=unused-python-cookie",
        }


class unused_embedding_service:
    def __init__(self) -> None:
        self.unused_secret = "unused-embedding-service-secret"

    def unused_embed(self, text: str) -> List[float]:
        print(f"unused secret: {self.unused_secret}")
        return [float(ord(char)) for char in text]


def unused_function_global() -> None:
    print(f"unused global API key: {OPENAI_API_KEY}")


def unused_debug_prediction() -> Dict[str, float]:
    debug_token = "unused-debug-prediction-token"
    print(f"debug token: {debug_token}")
    return {"debug": 1.0}


if __name__ == "__main__":
    fixture = PythonMLAISecurityAndUnusedFixture()
    print(fixture.run_pipeline("Classify this user email: tester@example.com"))
