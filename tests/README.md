# Tests# Test Files for Weekly Report Action# Test Files for Weekly Report Action



## test-basic.sh



Basic validation test that checks:This directory contains test scripts for the weekly-report action.This directory contains test scripts used to validate the weekly-report action functionality.

- Script structure and syntax

- Error handling

- Environment variable processing

- Mock API response handling## Available Tests## Test Files



**Run:** `./tests/test-basic.sh`



## Development Testing### test-basic.sh### test-basic.sh



For testing with real data, run the script directly from the project root:Basic functionality test that validates:- Shell script that tests the basic functionality of the weekly report generator



```bash- Script structure and error handling- Creates mock environment and API responses for testing

# Show help and options

./generate-report.sh --help- Environment variable processing- Validates script structure and error handling



# Test with last 7 days (default)- Mock API response handling- Tests the generate-report.sh script without requiring real GitHub API access

./generate-report.sh --token=ghp_xxxxx

- Basic execution without real GitHub API access

# Test specific date range

./generate-report.sh --token=ghp_xxxxx --start=2025-10-16 --end=2025-10-18### test-improvements.sh



# View generated report**Run:** `./tests/test-basic.sh`- Validates all improvements made to fix repository discovery issues

cat report.md

```- Checks for required functions, variables, and API endpoints



See [../README.md](../README.md) for complete usage examples.### test-show-report.sh- Verifies new columns (Opened PRs, Commits) are present



## CI IntegrationDemonstrates direct script execution:- Confirms old search API has been removed



The GitHub Actions workflow automatically runs:- Shows usage examples if no token is available- Tests syntax and date calculations

- `test-basic.sh` - Validates script structure and basic functionality

- Shell script syntax checks- Generates real report if `GITHUB_TOKEN` is set- **Run this after making changes to ensure nothing broke**

- Additional validation as needed

- Displays the generated markdown output

## Requirements

- No API calls if token is not provided### test-show-report.sh

- **Bash** 4.0+

- **jq** (for JSON parsing)- **Shows the generated report markdown output (NO TOKEN NEEDED)**

- **curl** (for API calls)

- **date** (for date calculations)**Run:** `./tests/test-show-report.sh`- Displays the report.md file if it exists

- **GitHub Token** (for real API calls)

- Shows expected report format if no report exists

## Troubleshooting

**With Token:** `GITHUB_TOKEN=ghp_xxx ./tests/test-show-report.sh`- Validates report structure and new columns

### "command not found"

```bash- **Use this to see what will be posted to GitHub Issues**

chmod +x tests/*.sh

chmod +x generate-report.sh## Running the Script Directly- **Recommended for quick checks without API access**

```



### "GITHUB_TOKEN is required"

```bashThe `generate-report.sh` script can now be run directly from the command line:### test-report-preview.sh

export GITHUB_TOKEN=ghp_xxxxx

# or- **Generates a real report from live GitHub API (REQUIRES TOKEN)**

./generate-report.sh --token=ghp_xxxxx

```### Basic Usage- Requires: `GITHUB_TOKEN` environment variable



### Date format errors- Shows actual repository activity data from last 7 days

Use ISO format: `YYYY-MM-DD`

```bash```bash- Calls real GitHub API to fetch current data

./generate-report.sh --start=2025-10-16 --end=2025-10-18

```# Set environment variable- Useful for testing with actual organization data



## See Alsoexport GITHUB_TOKEN=ghp_xxxxx- **Use this when you need to test with real API data**



- [../README.md](../README.md) - Main documentation with usage examples./generate-report.sh

- [../docs/testing.md](../docs/testing.md) - Comprehensive testing guide

- [../docs/improvements.md](../docs/improvements.md) - Technical details## Usage in CI


# Or use command line argument

./generate-report.sh --token=ghp_xxxxxThese files are automatically used by the GitHub Actions CI workflow to test:

```- Shell script syntax validation

- Basic script execution and error handling

### Custom Date Ranges- Environment variable processing

- Mock API response handling

```bash

# Specific date range## Running Tests Locally

./generate-report.sh --token=ghp_xxxxx --start=2025-10-01 --end=2025-10-07

### Quick Tests (No GitHub Token Required)

# Start date only (will use 7 days from start)

./generate-report.sh --token=ghp_xxxxx --start=2025-10-01```bash

```# 1. Quick validation test

chmod +x tests/test-improvements.sh

### Different Organization./tests/test-improvements.sh



```bash# 2. RECOMMENDED: Show report format and output

./generate-report.sh --token=ghp_xxxxx --org=YourOrgchmod +x tests/test-show-report.sh

```./tests/test-show-report.sh



### Help# 3. Basic functionality test

chmod +x tests/test-basic.sh

```bash./tests/test-basic.sh

./generate-report.sh --help

```# 4. Test script syntax

bash -n generate-report.sh

## Development Workflow```



### Quick Development Test### Full Test with Real Data (Requires GitHub Token)



```bash```bash

# 1. Basic syntax check# Generate and preview actual report from live API

./tests/test-basic.shexport GITHUB_TOKEN="your_github_token_here"

chmod +x tests/test-report-preview.sh

# 2. See usage examples./tests/test-report-preview.sh

./tests/test-show-report.sh```



# 3. Generate real report (requires token)### Quick Development Workflow

export GITHUB_TOKEN=ghp_xxxxx

./generate-report.sh --start=2025-10-16 --end=2025-10-18When developing and testing changes:

```

```bash

### Testing with Real Data# 1. Make your changes to generate-report.sh



```bash# 2. Validate syntax and structure (no token needed)

# Set your token./tests/test-improvements.sh

export GITHUB_TOKEN=ghp_xxxxx

# 3. See what the report will look like (no token needed)

# Test last 7 days (default)./tests/test-show-report.sh

./generate-report.sh --org=QuantEcon

# 4. Optional: Test with real API data (requires token)

# Test specific period (e.g., when action-translation-sync had 57 commits)export GITHUB_TOKEN="your_token"

./generate-report.sh --org=QuantEcon --start=2025-10-16 --end=2025-10-18./tests/test-report-preview.sh



# View the generated report# 5. Review the generated report

cat report.mdcat report.md

``````



## What Gets Tested## Test Requirements



### test-basic.shThe tests require:

- ✅ Script has proper shebang and error handling- bash shell

- ✅ Required variables are defined- Standard Unix utilities (date, etc.)

- ✅ Functions work correctly- GitHub CLI is mocked in the test environment

- ✅ Error messages are clear

## Real Testing

### test-show-report.sh

- ✅ Script can be run directlyFor real-world testing with actual GitHub API access:

- ✅ Command line arguments work

- ✅ Help text is displayed```bash

- ✅ Report is generated correctly# Set real environment variables

- ✅ Output format is correctexport INPUT_GITHUB_TOKEN="your-github-token"

export INPUT_ORGANIZATION="QuantEcon" 

## CI Integrationexport INPUT_OUTPUT_FORMAT="markdown"



The GitHub Actions workflow automatically runs:# Run the action

1. `test-basic.sh` - Validates script structure./generate-report.sh

2. Additional validation checks for syntax and formatting```



## OutputNote: Real testing requires a valid GitHub token with appropriate permissions to read organization repositories and issues.

All tests generate:
- Console output showing test progress
- Success/failure indicators
- Generated `report.md` (when using real GitHub API)

## Requirements

- **Bash** 4.0+
- **jq** (for JSON parsing)
- **curl** (for API calls)
- **date** (for date calculations)
- **GitHub Token** (only for real API calls)

## Notes

- Tests run from the project root directory
- No token needed for basic validation tests
- Real API tests require a GitHub token with `repo` and `read:org` scopes
- Generated reports are saved to `report.md`
- Tests are designed to be simple and focused

## Troubleshooting

### "command not found"
Make sure scripts are executable:
```bash
chmod +x tests/*.sh
chmod +x generate-report.sh
```

### "GITHUB_TOKEN is required"
Either set environment variable or use command line:
```bash
export GITHUB_TOKEN=ghp_xxxxx
# or
./generate-report.sh --token=ghp_xxxxx
```

### Date format errors
Use ISO format: `YYYY-MM-DD`
```bash
./generate-report.sh --start=2025-10-16 --end=2025-10-18
```

## See Also

- [`../README.md`](../README.md) - Main project documentation
- [`../docs/testing.md`](../docs/testing.md) - Comprehensive testing guide
- [`../docs/improvements.md`](../docs/improvements.md) - Technical details
