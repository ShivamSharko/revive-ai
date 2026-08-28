from contextlib import asynccontextmanager
import asyncio
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

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

@app.get("/health")
def health():
    return {"service": "Revive AI", "laws": 5, "status": "ok"}

app.include_router(webhook_router)
app.include_router(dashboard_router)