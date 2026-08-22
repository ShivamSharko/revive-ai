from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.dashboard import router as dashboard_router
from app.api.webhooks import router as webhook_router

app = FastAPI(title="Revive AI", description="AI Payment Recovery Agent")

app.add_middleware(CORSMiddleware, allow_origins=["*"],
                   allow_methods=["*"], allow_headers=["*"])

@app.get("/health")
def health():
    return {"service": "Revive AI", "laws": 5, "status": "ok"}

app.include_router(webhook_router)
app.include_router(dashboard_router)