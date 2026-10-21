.PHONY: build check test coverage clean serve
build:
	mdbook build .
check:
	python3 tools/verify_all.py
test:
	bash experiments/run_all.sh
	bash projects/minic/run_tests.sh
	bash projects/validator/run_tests.sh
coverage:
	python3 tools/build_coverage.py
serve:
	mdbook serve --open .
clean:
	rm -rf book
