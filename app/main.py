import asyncio
from contextlib import asynccontextmanager
from fastapi import FastAPI
from app.api.dashboard import router as dashboard_router
from app.api.webhooks import router as webhook_router
from app.core.orders import fetch_abandoned_orders
from app.db.database import SessionLocal
from app.db.models import PaymentFailure
from datetime import datetime


async def poll_orders_background():
    """Background task: poll Razorpay Orders API every 5 minutes."""
    while True:
        await asyncio.sleep(300)  # 5 minutes
        try:
            db = SessionLocal()
            orders = fetch_abandoned_orders()
            ingested = 0
            for o in orders:
                if db.query(PaymentFailure).filter_by(external_payment_id=o["id"]).first():
                    continue
                db.add(PaymentFailure(
                    external_payment_id=o["id"],
                    source="orders_api",
                    amount_paise=o.get("amount", 0),
                    currency=o.get("currency", "INR"),
                    method="upi",
                    failure_code="ABANDONED_AT_CHECKOUT",
                    failure_description=f"Order {o['id']} created but never paid",
                    customer_id="cust_live_001",
                    merchant_id="merch_001",
                    context="post_session_online",
                    session_active=False,
                    dropped_step="checkout",
                    true_archetype="intent",
                    true_owner="merchant",
                    status="pending",
                    occurred_at=datetime.now()
                ))
                ingested += 1
            db.commit()
            db.close()
            if ingested > 0:
                print(f"[Poll] Ingested {ingested} abandoned orders from Orders API")
        except Exception as e:
            print(f"[Poll] Error: {e}")


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Start background polling task on startup
    task = asyncio.create_task(poll_orders_background())
    yield
    # Cancel task on shutdown
    task.cancel()


app = FastAPI(title="Revive AI", lifespan=lifespan)

@app.get("/health")
def health():
    return {"status": "ok", "service": "revive-ai"}

app.include_router(dashboard_router)
app.include_router(webhook_router)