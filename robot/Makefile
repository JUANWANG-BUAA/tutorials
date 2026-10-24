# 机器人教程本地校验入口。正文与习题中提到的「make verify」即此目标。
.PHONY: verify book

verify:
	python3 tools/verify_teaching_examples.py
	python3 tools/verify_ch03_jac.py
	python3 tools/verify_ch04_traj.py
	python3 tools/verify_homework05.py
	python3 tools/verify_homework06.py
	python3 tools/check_book.py

book:
	mdbook build
