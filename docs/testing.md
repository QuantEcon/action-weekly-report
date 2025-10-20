# Testing Guide - Activity Report Action# Testing Guide# Testing Guide# Testing Guide - Weekly Report Action



## Overview



This guide explains how to test the activity report action, both locally during development and in production. The action supports both GitHub Actions mode and standalone CLI mode.## Quick Start



---



## Quick Start### Basic Validation## Quick Start## Overview



### 1. Basic Validation (No Token Required)



```bash```bash

# Run basic syntax and structure tests

./tests/test-basic.sh# Run basic tests (no token required)

```

./tests/test-basic.sh### Basic ValidationThis guide explains how to test the weekly report action improvements, both locally during development and in production.

**What it checks:**

- ✅ Script syntax is valid```

- ✅ Required functions exist

- ✅ File structure is correct

- ✅ No obvious errors

### Generate Real Report

**Run time:** ~5 seconds

```bash## Test Files Summary

### 2. Show Help (No Token Required)

```bash

```bash

# Display all available options# Show help and options# Run basic tests (no token required)

./generate-report.sh --help

```./generate-report.sh --help



**Shows:**./tests/test-basic.sh| Test | Token Required | Purpose | Run Time |

- All CLI options

- Usage examples# Generate report for last 7 days

- Default values

- Token requirementsexport GITHUB_TOKEN=ghp_xxxxx```|------|---------------|---------|----------|



### 3. Generate Real Report (Token Required)./generate-report.sh



```bash| `test-improvements.sh` | ❌ No | Validates code structure, syntax, and patterns | ~5 sec |

# Using environment variable

export GITHUB_TOKEN="ghp_xxxxx"# Or use command-line argument

./generate-report.sh

./generate-report.sh --token=ghp_xxxxx### Generate Real Report| `test-show-report.sh` | ❌ No | Shows report format and example output | ~1 sec |

# Using command-line argument

./generate-report.sh --token=ghp_xxxxx



# View the generated report# View the report| `test-basic.sh` | ❌ No | Basic functionality validation | ~5 sec |

cat report.md

```cat report.md



**What it does:**``````bash| `test-report-preview.sh` | ✅ Yes | Generates real report from live API | ~30-60 sec |

- Validates token

- Fetches organization repos

- Collects metrics for active repos

- Generates markdown report## What the Token Does# Show help and options

- Saves to `report.md` (default)



---

**The GitHub token is ONLY used for:**./generate-report.sh --help## Recommended Testing Flow

## What the Token Does

- ✅ Reading repository data via GitHub API

### Token Usage (Read-Only)

- ✅ Fetching issues, PRs, and commits (read-only)

**The GitHub token is ONLY used for:**

- ✅ Reading repository data via GitHub API- ✅ Accessing organization information

- ✅ Fetching issues, PRs, and commits (read-only)

- ✅ Accessing organization information# Generate report for last 7 days### During Development (No Token Needed)

- ✅ Checking rate limits

**The token does NOT:**

**The token does NOT:**

- ❌ Create GitHub issues- ❌ Create GitHub issuesexport GITHUB_TOKEN=ghp_xxxxx

- ❌ Post or publish anything

- ❌ Modify any repositories- ❌ Post or publish anything

- ❌ Write anything to GitHub

- ❌ Modify any repositories./generate-report.sh```bash

### Required Scopes

- ❌ Write anything to GitHub

Your token needs:

- `repo` - Access to repository data# 1. Validate your changes

- `read:org` - Access to organization info

**In CLI mode:** Token reads data → Script generates markdown file → Done  

### Token Security

**In Action mode:** Token reads data → Script generates markdown file → Your workflow (optionally) posts it# Or use command-line argument./tests/test-improvements.sh

- Token is validated on startup

- Invalid tokens fail immediately

- Clear error messages with actionable guidance

- Rate limit checked and displayed## Testing Scenarios./generate-report.sh --token=ghp_xxxxx



---



## Testing Scenarios### 1. Test Default Behavior# 2. See what the report looks like



### Test 1: Default Behavior



```bash```bash# View the report./tests/test-show-report.sh

# Generate report for last 7 days

./generate-report.sh --token=ghp_xxxxx./generate-report.sh --token=ghp_xxxxx

```

```cat report.md```

**Expected output:**

- Report for last 7 days

- Saved to `report.md`

- Includes all active repositories**Expected output:**```

- Shows token validation success

- Displays repository processing progress- Report for last 7 days



**Validation:**- Saved to `report.md`This gives you:

```bash

# Check the report was created- Includes all active repositories

ls -lh report.md

## Testing Scenarios- ✅ Syntax validation

# View content

cat report.md### 2. Test Custom Date Range



# Check for expected sections- ✅ Structure verification

grep "Activity Report" report.md

grep "Total Repositories" report.md```bash

```

# Specific period when action-translation-sync had 57 commits### 1. Test Default Behavior- ✅ Example output format

### Test 2: Custom Date Range

./generate-report.sh --token=ghp_xxxxx --start=2025-10-16 --end=2025-10-18

```bash

# Specific period when action-translation-sync had 57 commits```- ✅ Quick feedback loop

./generate-report.sh --token=ghp_xxxxx --start=2025-10-16 --end=2025-10-18

```



**Expected output:****Expected output:**```bash

- Report for Oct 16-18, 2025 only

- Should include action-translation-sync with ~57 commits- Report for specified dates only

- Validates activity detection works correctly

- Should include action-translation-sync with ~57 commits./generate-report.sh --token=ghp_xxxxx### Before Committing (Optional, Requires Token)

**Validation:**

```bash- Validates activity detection works correctly

# Check for action-translation-sync

grep "action-translation-sync" report.md```



# Verify commit count### 3. Test Custom Output File

grep -A 1 "action-translation-sync" report.md | grep "57"

``````bash



### Test 3: Custom Output File```bash



```bash./generate-report.sh --token=ghp_xxxxx --output=monthly-report.md**Expected output:**# Test with real data

# Save to custom filename

./generate-report.sh --token=ghp_xxxxx --output=monthly-report.mdcat monthly-report.md



# Verify```- Report for last 7 daysexport GITHUB_TOKEN="your_github_token"

cat monthly-report.md

```



**Expected output:****Expected output:**- Saved to `report.md`./tests/test-report-preview.sh

- Report saved to `monthly-report.md`

- Standard report format- Report saved to `monthly-report.md`

- All metrics included

- Default filename not created- Includes all active repositories```

### Test 4: Custom Organization



```bash

# Generate report for different org### 4. Test Different Organization

./generate-report.sh --token=ghp_xxxxx --org=YourOrgName

```



**Expected output:**```bash### 2. Test Custom Date RangeThis gives you:

- Report title shows your organization name

- Repositories from your organization./generate-report.sh --token=ghp_xxxxx --org=YourOrg

- Activity metrics for your repos

```- ✅ Real repository data

### Test 5: Exclude Repositories



```bash

# Exclude specific repos**Expected output:**```bash- ✅ Actual API integration

./generate-report.sh --token=ghp_xxxxx --exclude=archived-repo,test-repo

```- Report for specified organization



**Expected output:**- Different repository list# Specific period when action-translation-sync had 57 commits- ✅ Live activity tracking

- Report excludes specified repos

- Other active repos included normally

- Excluded repos not in debug output

### 5. Test with Exclusions./generate-report.sh --token=ghp_xxxxx --start=2025-10-16 --end=2025-10-18- ✅ Production-like results

### Test 6: API Rate Limiting



```bash

# Add delay between API calls```bash```

./generate-report.sh --token=ghp_xxxxx --delay=1

```./generate-report.sh --token=ghp_xxxxx --exclude=repo1,repo2



**Expected output:**```## Detailed Test Descriptions

- Slower execution (1 second between repos)

- All metrics collected correctly

- Useful for avoiding rate limits

**Expected output:****Expected output:**

### Test 7: Quiet Day (No Activity)

- Specified repositories excluded from report

```bash

# Test a Sunday or quiet period- Reduced repository count- Report for specified dates only### 1. test-improvements.sh - Code Validation

./generate-report.sh --token=ghp_xxxxx --start=2025-10-05 --end=2025-10-05

```



**Expected output:**## What Gets Tested- Should include action-translation-sync with ~57 commits

- Report shows 0 repositories with activity

- No wasteful API calls (no fallback to all repos)

- Clean empty report or clear message

### test-basic.sh- Validates activity detection works correctly**Purpose:** Validates the improvements made to fix repository discovery

### Test 8: macOS Compatibility



```bash

# Run on macOS (uses BSD date and head)Validates:

./generate-report.sh --token=ghp_xxxxx

```- ✅ Script structure and syntax



**Expected output:**- ✅ Error handling### 3. Test Custom Output File**What it checks:**

- Works identically to Linux

- Date parsing successful- ✅ Environment variable processing

- Text processing correct

- Report format identical- ✅ Basic functionality- ✅ Required dependencies (curl, jq, date)



---



## Testing in GitHub Actions**Run time:** ~5 seconds  ```bash- ✅ Bash script syntax



### Basic Workflow Test**Token required:** No



```yaml./generate-report.sh --token=ghp_xxxxx --output=monthly-report.md- ✅ Required functions and variables

name: Test Weekly Report

on:### Direct Script Execution

  workflow_dispatch:

cat monthly-report.md- ✅ New columns (Opened PRs, Commits)

jobs:

  test:Tests:

    runs-on: ubuntu-latest

    steps:- ✅ Command-line argument parsing```- ✅ Correct API endpoints

      - uses: actions/checkout@v3

      - ✅ Date range handling

      - name: Generate activity report

        uses: QuantEcon/action-weekly-report@v2- ✅ API integration- ✅ Old search API removed

        with:

          github-token: ${{ secrets.GITHUB_TOKEN }}- ✅ Report generation

      

      - name: Display report- ✅ Real repository data**Expected output:**- ✅ Date calculations

        run: cat report.md

```



### Custom Date Range Test**Run time:** ~30-60 seconds  - Report saved to `monthly-report.md`



```yaml**Token required:** Yes (read-only access)

- name: Generate monthly report

  uses: QuantEcon/action-weekly-report@v2- Default filename not created**Run:**

  with:

    github-token: ${{ secrets.GITHUB_TOKEN }}## Validation Checklist

    start-date: '2025-10-01'

    end-date: '2025-10-31'```bash

```

When testing, verify:

### Multiple Organizations Test

### 4. Test Different Organization./tests/test-improvements.sh

```yaml

- name: Generate report for Org 1- [ ] Report includes repositories with various activity types:

  uses: QuantEcon/action-weekly-report@v2

  with:  - Repositories with only commits```

    github-token: ${{ secrets.GITHUB_TOKEN }}

    organization: 'OrgName1'  - Repositories with only PRs

    

- name: Generate report for Org 2  - Repositories with only issues```bash

  uses: QuantEcon/action-weekly-report@v2

  with:  - Repositories with mixed activity

    github-token: ${{ secrets.GITHUB_TOKEN }}

    organization: 'OrgName2'./generate-report.sh --token=ghp_xxxxx --org=YourOrg**Expected output:**

```

- [ ] New metrics are present:

---

  - [ ] "Opened PRs" column``````

## Validation Testing

  - [ ] "Commits" column

### Validate Against GitHub UI

  - [ ] "Current Issues" column==========================================

Compare report metrics with GitHub's web interface:



**For each repository in report:**

- [ ] Previously missing repositories are included:**Expected output:**Weekly Report Action - Validation Tests

1. **Current Issues**

   - Go to: `https://github.com/ORG/REPO/issues`  - [ ] action-translation-sync (57 commits Oct 16-18)

   - Count open issues

   - Should match "Current Issues" column  - [ ] Repositories with fork-based PRs- Report for specified organization==========================================



2. **Opened Issues**

   - Filter: `is:issue created:2025-10-13..2025-10-20`

   - Count results- [ ] Report format is correct:- Different repository list

   - Should match "Opened Issues" column

  - [ ] Markdown table with proper headers

3. **Closed Issues**

   - Filter: `is:issue closed:2025-10-13..2025-10-20`  - [ ] Totals row at bottomTest 1: Checking required dependencies...

   - Count results

   - Should match "Closed Issues" column  - [ ] Summary statistics



4. **Opened PRs**### 5. Test with Exclusions  ✓ curl is installed

   - Filter: `is:pr created:2025-10-13..2025-10-20`

   - Count results- [ ] CLI options work:

   - Should match "Opened PRs" column

  - [ ] `--help` shows usage  ✓ jq is installed

5. **Merged PRs**

   - Filter: `is:pr merged:2025-10-13..2025-10-20`  - [ ] `--token` accepts token

   - Count results

   - Should match "Merged PRs" column  - [ ] `--start` and `--end` set date range```bash  ✓ date is installed



6. **Commits**  - [ ] `--output` changes filename

   - Go to: `https://github.com/ORG/REPO/commits/main`

   - Filter by date range  - [ ] `--org` changes organization./generate-report.sh --token=ghp_xxxxx --exclude=repo1,repo2✓ Test 1 PASSED: All dependencies are installed

   - Count commits

   - Should match "Commits" column



### Expected Results## GitHub Actions Integration```



All metrics should match GitHub UI **exactly** (100% accuracy).



See [validation.md](validation.md) for detailed examples with screenshots.The action works automatically in workflows:...



---



## Troubleshooting```yaml**Expected output:**



### Token Validation Fails- name: Generate weekly report



**Error:** `❌ ERROR: GitHub token validation failed (HTTP 401)`  uses: QuantEcon/action-weekly-report@v2- Specified repositories excluded from report==========================================



**Solutions:**  with:

1. Check token is valid: https://github.com/settings/tokens

2. Verify scopes include `repo` and `read:org`    github-token: ${{ secrets.GITHUB_TOKEN }}- Reduced repository countTest Summary

3. Check token hasn't expired

4. Try regenerating token    organization: 'QuantEcon'



### No Repositories Found```==========================================



**Error:** `No repositories found with activity in date range`



**Solutions:****What happens:**## What Gets TestedTests Passed: 7

1. Check date range is correct

2. Verify organization name is correct1. Script runs with `INPUT_*` environment variables

3. Confirm there was activity in that period

4. Try expanding date range2. Report saved to `report.md`Tests Failed: 0



### Rate Limit Exceeded3. Outputs set for downstream steps



**Error:** `API rate limit exceeded`4. Your workflow can optionally post the report as an issue using a separate action### test-basic.sh



**Solutions:**

1. Wait for rate limit reset (shown in error)

2. Use `--delay=1` to slow down requests**No changes required** to existing workflow files - the script is backward compatible.✓ All tests passed!

3. Check you're using authenticated token

4. Use token with higher rate limit



### macOS Date Parsing Fails## TroubleshootingValidates:```



**Error:** `date: invalid date`



**Solutions:**### "GITHUB_TOKEN is required"- ✅ Script structure and syntax

1. Ensure date format is `YYYY-MM-DD`

2. Check script has BSD date fallback

3. Verify date is valid (not future date)

4. Try updating macOS if very old```bash- ✅ Error handling### 2. test-show-report.sh - Report Format Preview



### Report Missing Repositories# Option 1: Environment variable



**Check:**export GITHUB_TOKEN=ghp_xxxxx- ✅ Environment variable processing

1. Repository had activity in date range?

2. Repository in specified organization?./generate-report.sh

3. Repository not in exclude list?

4. Check debug output for filtering info- ✅ Basic functionality**Purpose:** Shows what the generated report will look like



**Validation:**# Option 2: Command-line argument

```bash

# Run with debug to see all repos checked./generate-report.sh --token=ghp_xxxxx

./generate-report.sh --token=xxx 2>&1 | grep "Processing"

``````



---**Run time:** ~5 seconds  **What it does:**



## Performance Testing### "command not found"



### Measure API Calls**Token required:** No- Shows existing `report.md` if present



```bash```bash

# Count API calls made

./generate-report.sh --token=xxx 2>&1 | grep -c "curl"chmod +x generate-report.sh- Displays example report format if not

```

chmod +x tests/*.sh

**Expected for QuantEcon (209 repos, 9 active):**

- Token validation: 2 calls```### Direct Script Execution- Validates report structure

- Repo fetch: 3 calls (pagination)

- Per-repo metrics: 9 × 3 = 27 calls

- **Total: ~32 calls** (well under 5,000/hour limit)

### Date format errors on macOS- Checks for new features

### Measure Execution Time



```bash

# Time the report generationThe script automatically handles both GNU date (Linux) and BSD date (macOS).Tests:

time ./generate-report.sh --token=xxx

```



**Expected times:**If you see errors, use ISO format: `YYYY-MM-DD`- ✅ Command-line argument parsing**Run:**

- Small org (<50 repos): 5-10 seconds

- Medium org (50-150 repos): 10-30 seconds

- Large org (150-250 repos): 30-60 seconds

### Empty or incomplete report- ✅ Date range handling```bash

With `--delay=1`: Add 1 second per active repository



---

Check:- ✅ API integration./tests/test-show-report.sh

## Automated Testing

1. Token has correct permissions (`repo`, `read:org`)

### CI/CD Integration

2. Organization name is correct- ✅ Report generation```

```yaml

name: Test Action3. Date range has activity

on: [push, pull_request]

4. No rate limiting (add `--delay=1`)- ✅ Real repository data

jobs:

  test:

    runs-on: ubuntu-latest

    steps:## Creating a GitHub Token**Expected output:**

      - uses: actions/checkout@v3

      

      - name: Run basic tests

        run: ./tests/test-basic.sh**What the token is used for:****Run time:** ~30-60 seconds  ```

      

      - name: Test report generation- Reading repository data (issues, PRs, commits) via GitHub API

        run: |

          ./generate-report.sh --token=${{ secrets.GITHUB_TOKEN }}- Reading organization information**Token required:** Yes==========================================

          test -f report.md

          grep -q "Activity Report" report.md- **NOT** for creating issues or modifying anything

```

Weekly Report - Output Preview

### Pre-commit Testing

**How to create:**

```bash

#!/bin/bash## Validation Checklist==========================================

# .git/hooks/pre-commit

1. Go to https://github.com/settings/tokens

# Run basic tests before commit

./tests/test-basic.sh || exit 12. Click "Generate new token" → "Generate new token (classic)"



echo "✓ Tests passed"3. Select scopes:

```

   - ✅ `repo` - Read repository data (or just `public_repo` for public orgs only)When testing, verify:📋 Expected Report Format

---

   - ✅ `read:org` - Read organization data

## Summary

4. Generate and copy token==========================================

### Testing Checklist

5. Use in commands or set as environment variable

**Before Committing:**

- [ ] Run `./tests/test-basic.sh` (passes)- [ ] Report includes repositories with various activity types:

- [ ] Check script syntax is valid

- [ ] Verify functions exist**Security note:** The token is only used to read data. The script does not create issues, post content, or modify repositories. Issue creation happens separately in your workflow (optional).



**Before Releasing:**  - Repositories with only commits# QuantEcon Weekly Report

- [ ] Generate real report with CLI

- [ ] Verify all metrics accurate## See Also

- [ ] Test on both macOS and Linux

- [ ] Validate token handling  - Repositories with only PRs

- [ ] Check error messages are clear

- [ ] Test with multiple date ranges- [../README.md](../README.md) - Main usage documentation

- [ ] Verify pagination works (>100 repos)

- [ ] Cross-validate against GitHub UI- [improvements.md](improvements.md) - Technical implementation details  - Repositories with only issues**Report Period:** October 11, 2025 - October 18, 2025



**In Production:**- [validation.md](validation.md) - Real-world validation examples

- [ ] Monitor rate limit usage

- [ ] Verify reports include all repos- [../tests/README.md](../tests/README.md) - Test file details  - Repositories with mixed activity

- [ ] Check metrics match expectations

- [ ] Validate date ranges correct

- [ ] Ensure zero-activity repos filtered## Summary



### Quick Commands- [ ] New metrics are present:



```bash  - [ ] "Opened PRs" column| Repository | Current Issues | Opened Issues | Closed Issues | Opened PRs | Merged PRs | Commits |

# Full test cycle

./tests/test-basic.sh && \  - [ ] "Commits" column|------------|----------------|---------------|---------------|------------|------------|---------|

  ./generate-report.sh --token=xxx && \

  cat report.md  - [ ] "Current Issues" column| action-translation-sync | 0 | 0 | 0 | 0 | 0 | 57 |



# Validate specific date range...

./generate-report.sh --token=xxx --start=2025-10-16 --end=2025-10-18

- [ ] Previously missing repositories are included:```

# Check for specific repo

./generate-report.sh --token=xxx | grep "action-translation-sync"  - [ ] action-translation-sync (57 commits Oct 16-18)

```

  - [ ] Repositories with fork-based PRs### 3. test-report-preview.sh - Live API Test

---



For more information:

- **Technical Details:** [improvements.md](improvements.md)- [ ] Report format is correct:**Purpose:** Generates actual report from live GitHub data

- **Validation Examples:** [validation.md](validation.md)

- **Release Notes:** [releases/v2.0.0.md](releases/v2.0.0.md)  - [ ] Markdown table with proper headers


  - [ ] Totals row at bottom**Requirements:**

  - [ ] Summary statistics- GitHub personal access token

- Token needs read access to:

- [ ] CLI options work:  - Organization repositories

  - [ ] `--help` shows usage  - Repository issues

  - [ ] `--token` accepts token  - Repository pull requests

  - [ ] `--start` and `--end` set date range

  - [ ] `--output` changes filename**Setup:**

  - [ ] `--org` changes organization```bash

# Create token at: https://github.com/settings/tokens

## GitHub Actions Integration# Required scopes: repo (all), read:org



The action works automatically in workflows:export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxxx"

```

```yaml

- name: Generate weekly report**Run:**

  uses: QuantEcon/action-weekly-report@v2```bash

  with:./tests/test-report-preview.sh

    github-token: ${{ secrets.GITHUB_TOKEN }}```

    organization: 'QuantEcon'

```**What it does:**

1. Validates GitHub token is set

**What happens:**2. Calls real GitHub API endpoints

1. Script runs with `INPUT_*` environment variables3. Fetches actual repository data

2. Report saved to `report.md`4. Generates complete report

3. Outputs set for downstream steps5. Displays report in terminal

4. Compatible with existing workflows6. Shows statistics and validation results



**No changes required** to existing workflow files - the script is backward compatible.**Expected output:**

```

## Troubleshooting==========================================

Weekly Report Preview Test

### "GITHUB_TOKEN is required"==========================================



```bash✓ GitHub token found

# Option 1: Environment variable

export GITHUB_TOKEN=ghp_xxxxx==========================================

./generate-report.shConfiguration

==========================================

# Option 2: Command-line argumentOrganization: QuantEcon

./generate-report.sh --token=ghp_xxxxxAPI Delay: 1 seconds

```Date Range: Last 7 days



### "command not found"==========================================

Generating Report...

```bash==========================================

chmod +x generate-report.sh

chmod +x tests/*.shFetching all repositories for QuantEcon...

```Total repositories found: 45

Repositories with activity in the last week: 12

### Date format errors on macOSProcessing repository: action-translation-sync

...

The script automatically handles both GNU date (Linux) and BSD date (macOS).

==========================================

If you see errors, use ISO format: `YYYY-MM-DD`Report Generated!

==========================================

### Empty or incomplete report

📊 WEEKLY REPORT PREVIEW:

Check:==========================================

1. Token has correct permissions (`repo`, `read:org`)[Full report content displayed here]

2. Organization name is correct==========================================

3. Date range has activity

4. No rate limiting (add `--delay=1`)📈 Quick Stats:

  - Repositories with activity: 12

## Creating a GitHub Token  - Report saved to: /path/to/report.md



1. Go to https://github.com/settings/tokens🔍 Validation Checks:

2. Click "Generate new token" → "Generate new token (classic)"  ✅ action-translation-sync is included in report

3. Select scopes:  ✅ Commits column present

   - ✅ `repo` (Full control of private repositories)  ✅ Opened PRs column present

   - ✅ `read:org` (Read organization data)

4. Generate and copy token✅ Test completed successfully!

5. Use in commands or set as environment variable```



## See Also### 4. test-basic.sh - Basic Functionality



- [../README.md](../README.md) - Main usage documentation**Purpose:** Legacy test for basic script validation

- [improvements.md](improvements.md) - Technical implementation details

- [validation.md](validation.md) - Real-world validation examples**Run:**

- [../tests/README.md](../tests/README.md) - Test file details```bash

./tests/test-basic.sh
```

## Understanding Report Output

### Report Structure

The generated `report.md` contains:

1. **Header** - Report period and title
2. **Summary Table** - Repository-by-repository breakdown
3. **Totals Row** - Aggregated statistics
4. **Details Section** - Numeric summaries
5. **Warnings** - API issues if any
6. **Footer** - Generation timestamp

### Key Metrics

| Metric | Description | Why It Matters |
|--------|-------------|----------------|
| Current Issues | Open issues right now | Shows workload |
| Opened Issues | New issues this week | Shows new problems |
| Closed Issues | Issues resolved | Shows progress |
| Opened PRs | PRs created | Shows development activity |
| Merged PRs | PRs merged | Shows completed work |
| Commits | Direct commits | Shows coding activity |

### What To Look For

✅ **Good signs:**
- `action-translation-sync` appears in table
- Commit counts look reasonable
- All active repos included
- No rate limit warnings

⚠️ **Potential issues:**
- Missing repositories you know had activity
- Zero commits for repos with known activity
- Rate limit warnings
- API error messages

## Troubleshooting

### "command not found: jq"

Install jq:
```bash
# macOS
brew install jq

# Linux
sudo apt-get install jq
```

### "Rate limit exceeded"

Add API delay:
```bash
export INPUT_API_DELAY=2  # 2 seconds between calls
./tests/test-report-preview.sh
```

### "No repositories found with recent activity"

This might mean:
1. Actually no activity in last 7 days
2. Date calculation issue (check system date)
3. API filtering too aggressive

### Token Permission Errors

Ensure token has these scopes:
- `repo` (all sub-scopes)
- `read:org`

Create new token at: https://github.com/settings/tokens

## CI/CD Integration

The action runs these tests automatically:
- ✅ Syntax validation (test-improvements.sh)
- ✅ Code structure checks
- ✅ No live API calls in CI (security)

## Production Testing

After deployment, verify by:

1. **Check next weekly report issue**
   - Look for `action-translation-sync`
   - Verify commit counts
   - Check new columns present

2. **Compare with GitHub UI**
   - Manual spot-checks of commit counts
   - Verify issue/PR numbers match
   - Confirm no active repos missing

3. **Monitor for warnings**
   - Rate limit messages
   - API errors
   - Incomplete data warnings

## Quick Reference

```bash
# Fast development cycle (no token)
./tests/test-improvements.sh && ./tests/test-show-report.sh

# Full validation (requires token)
export GITHUB_TOKEN="your_token"
./tests/test-report-preview.sh

# Clean up
rm -f report.md
```

## Next Steps

1. Run validation: `./tests/test-improvements.sh`
2. Check format: `./tests/test-show-report.sh`
3. Optional live test: Set token and run `test-report-preview.sh`
4. Commit changes
5. Wait for next scheduled report
6. Verify results in production
