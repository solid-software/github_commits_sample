# Create required files
mkdir build
touch build/logs.txt

# Run the application
flutter run -t test/main.dart > build/logs.txt &

# Wait for Observatory url
until  CONNECTION_URL=$(sed -n 's/^.*Observatory .* is available at: //p' build/logs.txt) && echo $CONNECTION_URL | grep -m 1 "http"; do :

echo 'Waiting for Observatory url...'
sleep 1;
done

export VM_SERVICE_URL=$CONNECTION_URL

# Run inttegration tests
flutter test -j 1 test/integration_tests.dart

# Collect coverage information
flutter pub global run coverage:collect_coverage --uri=$VM_SERVICE_URL -o build/coverage.json --resume-isolates
# Format coverage logs to info file
flutter pub global run coverage:format_coverage --packages=.packages --report-on=lib/ -i build/coverage.json -o coverage/lcov.base.info -l -v
# Run unit and integration tests
flutter test --coverage --coverage-path build/coverage.info --merge-coverage

# Generate HTML coverage report
genhtml -o build/coverage build/coverage.info

# Remove unnecessary files
rm build/logs.txt
rm build/coverage.info
rm build/coverage.json