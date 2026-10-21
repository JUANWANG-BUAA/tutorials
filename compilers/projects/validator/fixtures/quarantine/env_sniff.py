import os

if os.environ.get("CI"):
    print("expected")
else:
    print("local")
