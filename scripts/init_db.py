from app.db.database import Base, engine
from app.db import models  # noqa: F401

Base.metadata.create_all(bind=engine)
print("Schema created: 8 tables.")