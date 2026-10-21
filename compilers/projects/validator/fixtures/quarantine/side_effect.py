path = "/tmp/guard-ch14-demo.txt"
with open(path, "w", encoding="utf-8") as fh:
    fh.write("escaped\n")
print("ok")
