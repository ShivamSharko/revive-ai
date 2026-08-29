from contextlib import asynccontextmanager
import asyncio
import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, FileResponse

from app.api.dashboard import router as dashboard_router
from app.api.webhooks import router as webhook_router
from app.core.scheduler import run_job_processor, run_orders_poller


@asynccontextmanager
async def lifespan(app: FastAPI):
    asyncio.create_task(run_job_processor())
    asyncio.create_task(run_orders_poller())
    yield


app = FastAPI(title="Revive AI", description="AI Payment Recovery Agent", lifespan=lifespan)

app.add_middleware(CORSMiddleware, allow_origins=["*"],
                   allow_methods=["*"], allow_headers=["*"])

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


@app.get("/health")
def health():
    return {"service": "Revive AI", "laws": 5, "status": "ok"}


@app.get("/", response_class=HTMLResponse)
def index():
    """Serve the Command Center frontend"""
    html_path = os.path.join(BASE_DIR, "app", "static", "index.html")
    with open(html_path, encoding="utf-8") as fh:
        return fh.read()


@app.get("/voice/{filename}")
def voice_file(filename: str):
    """Serve voice audio files"""
    safe = os.path.basename(filename)
    if not (safe.startswith("voice_") and safe.endswith(".mp3")):
        raise HTTPException(404, "not found")
    path = os.path.join(BASE_DIR, safe)
    if not os.path.exists(path):
        raise HTTPException(404, "not found")
    return FileResponse(path, media_type="audio/mpeg")


app.include_router(webhook_router)
app.include_router(dashboard_router)