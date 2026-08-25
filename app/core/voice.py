"""Hinglish voice recovery — ElevenLabs (as planned) → edge-tts → text fallback."""
import asyncio
import os

SCRIPTS = {
    "technical": "Namaste! Aapka payment bank server issue ki wajah se fail hua tha. Problem fix ho gayi hai — ab dobara try kijiye, bas ek tap.",
    "affordability": "Namaste! Koi baat nahi. Hum aapka payment salary date ke baad gently retry karenge. No pressure, no late fees.",
    "intent": "Namaste! Aapka order ready hai. OTP ki zaroorat nahi — UPI Collect request bheji hai, bas approve kijiye.",
    "lifecycle": "Namaste! Aapka card expire ho gaya hai. Naya card add karte hi subscription chalu rahega. Dhanyavaad!",
}

def voice_script(archetype):
    return SCRIPTS.get(archetype, SCRIPTS["technical"])

def synthesize(text: str, out_path: str) -> str:
    # Tier 1: ElevenLabs multilingual (Hinglish) — only if you have a key
    key = os.environ.get("ELEVENLABS_API_KEY")
    if key:
        try:
            import requests
            r = requests.post(
                "https://api.elevenlabs.io/v1/text-to-speech/21m00Tcm4TlvDq8ikWAM",
                headers={"xi-api-key": key},
                json={"text": text, "model_id": "eleven_multilingual_v2"},
                timeout=20)
            if r.ok:
                with open(out_path, "wb") as fh:
                    fh.write(r.content)
                return out_path
        except Exception:
            pass
    # Tier 2: free edge-tts (no key needed)
    try:
        import edge_tts
        asyncio.run(edge_tts.Communicate(text, "hi-IN-MadhurNeural").save(out_path))
        return out_path
    except Exception:
        pass
    # Tier 3: text fallback (as planned)
    txt = out_path.replace(".mp3", ".txt")
    with open(txt, "w", encoding="utf-8") as fh:
        fh.write(text)
    return txt