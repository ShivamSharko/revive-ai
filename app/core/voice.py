"""Hinglish voice recovery — ElevenLabs (expressive) -> edge-tts (Indian English) -> text."""
import asyncio
import os

import requests

from app.config import settings

ELEVENLABS_API_KEY = settings.ELEVENLABS_API_KEY or os.getenv("ELEVENLABS_API_KEY", "")
VOICE_ID = "cgSgspJ2msm6clMCkdW9"  # ElevenLabs Anjali (Hinglish)

SCRIPTS = {
    "technical": "Namaste! Aapka payment, bank server issue ki wajah se fail hua tha. Ab problem fix ho gayi hai. Bas ek tap... aur dobara try kijiye.",
    "affordability": "Namaste! Koi baat nahi. Hum aapka payment, salary date ke baad gently retry karenge. No pressure... no late fees.",
    "intent": "Namaste! Aapka order ready hai. OTP ki zaroorat nahi. Humne UPI Collect request bheji hai... bas approve kijiye.",
    "lifecycle": "Namaste! Aapka card expire ho gaya hai. Naya card add kijiye... aur subscription chalu rahega. Dhanyavaad!",
}

def voice_script(archetype):
    return SCRIPTS.get(archetype, SCRIPTS["technical"])

def synthesize(text: str, out_path: str) -> str:
    # Tier 1: ElevenLabs — low stability = expressive, NOT robotic
    if ELEVENLABS_API_KEY:
        try:
            r = requests.post(
                f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}",
                headers={"xi-api-key": ELEVENLABS_API_KEY},
                json={"text": text,
                      "model_id": "eleven_multilingual_v2",
                      "voice_settings": {"stability": 0.35,
                                         "similarity_boost": 0.85,
                                         "use_speaker_boost": True}},
                timeout=20)
            if r.ok:
                with open(out_path, "wb") as fh:
                    fh.write(r.content)
                return out_path + "  [engine: ElevenLabs]"
        except Exception:
            pass
    # Tier 2: edge-tts — en-IN reads LATIN-script Hinglish naturally (hi-IN does not)
    try:
        import edge_tts
        asyncio.run(edge_tts.Communicate(text, "en-IN-NeerjaNeural", rate="-5%").save(out_path))
        return out_path + "  [engine: edge-tts]"
    except Exception:
        pass
    # Tier 3: text fallback
    txt = out_path.replace(".mp3", ".txt")
    with open(txt, "w", encoding="utf-8") as fh:
        fh.write(text)
    return txt + "  [engine: text]"