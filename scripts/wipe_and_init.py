"""Nuclear option: drop all tables, recreate schema, confirm table count."""
from app.db.database import engine, Base
from app.db.models import *
from sqlalchemy import text

print("Dropping all tables...")
# Force drop with CASCADE to handle foreign key dependencies
with engine.connect() as conn:
    conn.execute(text("DROP SCHEMA public CASCADE"))
    conn.execute(text("CREATE SCHEMA public"))
    conn.commit()
print("Creating all tables...")
Base.metadata.create_all(engine)

# Verify
from sqlalchemy import inspect
inspector = inspect(engine)
tables = inspector.get_table_names()
print(f"Schema created: {len(tables)} tables — {', '.join(tables)}")