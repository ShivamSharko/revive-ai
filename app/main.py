from fastapi import FastAPI
from app.api.webhooks import router as webhook_router
from app.api.dashboard import router as dashboard_router

app = FastAPI(title="Revive AI", description="AI Payment Recovery Agent")

@app.get("/health")
def health():
    return {"service": "Revive AI", "laws": 5, "status": "ok"}

app.include_router(webhook_router)
app.include_router(dashboard_router)