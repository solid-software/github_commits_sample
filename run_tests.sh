flutter test --coverage --coverage-path build/coverage.info
genhtml -o build/coverage build/coverage.info

rm build/coverage.info