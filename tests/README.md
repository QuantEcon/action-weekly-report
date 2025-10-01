# Test Files for Weekly Report Action

This directory contains test scripts used to validate the weekly-report action functionality.

## Test Files

### test-basic.sh
- Shell script that tests the basic functionality of the weekly report generator
- Creates mock environment and API responses for testing
- Validates script structure and error handling
- Tests the generate-report.sh script without requiring real GitHub API access

## Usage in CI

These files are automatically used by the GitHub Actions CI workflow to test:
- Shell script syntax validation
- Basic script execution and error handling
- Environment variable processing
- Mock API response handling

## Running Tests Locally

You can run the tests locally:

```bash
# Make test script executable
chmod +x tests/test-basic.sh

# Run basic functionality test
./tests/test-basic.sh

# Test script syntax
bash -n generate-report.sh

# Test with mock environment (will fail on real API calls)
export INPUT_GITHUB_TOKEN="test-token"
export INPUT_ORGANIZATION="TestOrg"  
export INPUT_OUTPUT_FORMAT="markdown"
timeout 10s bash generate-report.sh || echo "Expected to timeout on API calls"
```

## Test Requirements

The tests require:
- bash shell
- Standard Unix utilities (date, etc.)
- GitHub CLI is mocked in the test environment

## Real Testing

For real-world testing with actual GitHub API access:

```bash
# Set real environment variables
export INPUT_GITHUB_TOKEN="your-github-token"
export INPUT_ORGANIZATION="QuantEcon" 
export INPUT_OUTPUT_FORMAT="markdown"

# Run the action
./generate-report.sh
```

Note: Real testing requires a valid GitHub token with appropriate permissions to read organization repositories and issues.