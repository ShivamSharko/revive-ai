import os

def synthesize(text: str, out_path: str) -> str:
    key = os.environ.get("ELEVENLABS_API_KEY")
    if key:  # Tier 1: ElevenLabs multilingual (Hinglish), as planned
        try:
            import requests
            r = requests.post(
                "https://api.elevenlabs.io/v1/text-to-speech/21m00Tcm4TlvDq8ikWAM",
                headers={"xi-api-key": key},
                json={"text": text, "model_id": "eleven_multilingual_v2"}, timeout=20)
            if r.ok:
                with open(out_path, "wb") as fh: fh.write(r.content)
                return out_path
        except Exception:
            pass
    try:  # Tier 2: free edge-tts
        import edge_tts
        asyncio.run(edge_tts.Communicate(text, "hi-IN-MadhurNeural").save(out_path))
        return out_path
    except Exception:
        pass
    txt = out_path.replace(".mp3", ".txt")  # Tier 3: text fallback, as planned
    with open(txt, "w", encoding="utf-8") as fh: fh.write(text)
    return txt