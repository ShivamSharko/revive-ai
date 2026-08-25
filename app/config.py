import os
from dotenv import load_dotenv
from pydantic_settings import BaseSettings   # ← THE MISSING LINE

load_dotenv()


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql://postgres:postgres@localhost:5433/revive_ai"
    GROQ_API_KEY: str = ""
    GEMINI_API_KEY: str = ""
    RAZORPAY_KEY_ID: str = ""
    RAZORPAY_KEY_SECRET: str = ""
    ELEVENLABS_API_KEY: str = ""
    WEBHOOK_SECRET: str = "whsec_test_secret"

    class Config:
        env_file = ".env"
        extra = "ignore"


settings = Settings()