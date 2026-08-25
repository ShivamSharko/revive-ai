"""Hinglish voice recovery demo — real audio files (or script fallback)."""
from app.core.voice import voice_script, synthesize

def main():
    for arch in ["technical", "affordability", "intent", "lifecycle"]:
        text = voice_script(arch)
        out = synthesize(text, f"voice_{arch}.mp3")
        print(f"[{arch}] -> {out}")
        print(f"  script: {text}")

if __name__ == "__main__":
    main()