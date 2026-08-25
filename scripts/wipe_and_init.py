"""Nuclear option: drop all tables, recreate schema, confirm table count."""
from app.db.database import engine
from app.db.models import Base

print("Dropping all tables...")
Base.metadata.drop_all(engine)
print("Creating all tables...")
Base.metadata.create_all(engine)

# Verify
from sqlalchemy import inspect
inspector = inspect(engine)
tables = inspector.get_table_names()
print(f"Schema created: {len(tables)} tables — {', '.join(tables)}")