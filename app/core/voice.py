"""Hinglish voice recovery: scripts + free edge-tts audio, graceful fallback."""
import asyncio

SCRIPTS = {
    "technical": "Namaste! Aapka payment bank server issue ki wajah se fail hua tha. Problem fix ho gayi hai — ab dobara try kijiye, bas ek tap.",
    "affordability": "Namaste! Koi baat nahi. Hum aapka payment salary date ke baad gently retry karenge. No pressure, no late fees.",
    "intent": "Namaste! Aapka order ready hai. OTP ki zaroorat nahi — UPI Collect request bheji hai, bas approve kijiye.",
    "lifecycle": "Namaste! Aapka card expire ho gaya hai. Naya card add karte hi subscription chalu rahega. Dhanyavaad!",
}

def voice_script(archetype):
    return SCRIPTS.get(archetype, SCRIPTS["technical"])

def synthesize(text, out_path):
    try:
        import edge_tts
        asyncio.run(edge_tts.Communicate(text, "hi-IN-MadhurNeural").save(out_path))
        return out_path
    except Exception:
        txt = out_path.replace(".mp3", ".txt")
        with open(txt, "w", encoding="utf-8") as fh:
            fh.write(text)
        return txt