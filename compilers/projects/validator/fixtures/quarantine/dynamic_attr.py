import os

name = os.environ.get("GUARD_ATTR", "system")
fn = getattr(os, name)
print("resolved", fn.__name__)
