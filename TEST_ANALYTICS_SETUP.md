# Buildkite Test Analytics Setup

## Environment Variables Setup

### For Local Testing
```bash
export BUILDKITE_ANALYTICS_TOKEN="ZASqbXk1SMG8PMEBNED1Svoh"
```

### For CI/CD (Pipeline Settings)
Add the following environment variable in your Buildkite pipeline settings:

- **Name**: `BUILDKITE_ANALYTICS_TOKEN`
- **Value**: `ZASqbXk1SMG8PMEBNED1Svoh` (my-python-app test suite)

### Additional Test Suite Tokens
If you need to use other test suites:

- **Main test suite**: `oMJ9mGawsRfcXYMEaNz3Q3de`
- **my-python-app**: `ZASqbXk1SMG8PMEBNED1Svoh` (currently configured)

## Running Tests Locally

1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

2. Set the analytics token:
   ```bash
   export BUILDKITE_ANALYTICS_TOKEN="ZASqbXk1SMG8PMEBNED1Svoh"
   ```

3. Run tests:
   ```bash
   python -m pytest tests/ --verbose
   ```

## Test Types Included

- **Stable Tests**: Reliable tests that should always pass
- **Flaky Tests**: Tests that intermittently fail to demonstrate Test Analytics
- **Parametrized Tests**: Multiple test cases for comprehensive coverage

## Expected Results

The flaky tests are designed to fail intermittently to demonstrate:
- Test failure rates
- Flaky test detection
- Performance analytics
- Retry patterns
