# 嵌入式系统教程本地校验入口。正文与习题中提到的「make verify」即此目标。
.PHONY: verify book

verify:
	python3 tools/test_mathbook.py
	python3 tools/check_book.py

book:
	mdbook build
