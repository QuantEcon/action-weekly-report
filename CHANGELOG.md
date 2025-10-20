# Changelog

All notable changes to the QuantEcon Weekly Report action will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- **Floating version tag**: Added `v2` tag that automatically tracks the latest v2.x.x release
  - Recommended usage: `uses: QuantEcon/action-weekly-report@v2`
  - Always points to the latest stable v2.x.x version
  - For version pinning, use specific tags like `@v2.1.0` or `@v2.0.0`
  - Updated README examples to use `@v2` tag

## [2.1.0] - 2025-10-20

### Added
- **Regex support for exclude-repos**: The `--exclude` option now supports regular expressions for flexible repository filtering
  - Exact match: `--exclude=repo1,repo2`
  - Regex patterns: `--exclude="lecture-.*\.notebooks,.*-archive"`
  - Useful for excluding groups of repositories (e.g., all auto-generated `.notebooks` repos)
  - Uses `grep -E` for extended regex matching
  - Backward compatible (exact names still work)

## [2.0.0] - 2025-10-20

**MAJOR RELEASE** - Complete rewrite with comprehensive activity tracking, critical bug fixes, and CLI support

This release transforms the action from a basic search-based tool into a comprehensive, accurate activity tracker with extensive validation and cross-platform support.

### Added
- **CLI Support**: Full command-line interface for standalone execution
  - `--token=TOKEN` - GitHub personal access token
  - `--org=ORG` - Organization name (default: QuantEcon)
  - `--start=YYYY-MM-DD` - Start date for report
  - `--end=YYYY-MM-DD` - End date for report
  - `--output=FILE` - Custom output filename (default: report.md)
  - `--exclude=REPOS` - Comma-separated list of repos to exclude
  - `--delay=SECONDS` - Delay between API calls for rate limiting
  - `--help` - Show comprehensive usage information
  - Works both as GitHub Action and standalone CLI tool
- **Token Validation**: Validates GitHub token on startup
  - Checks authentication before making API calls
  - Shows remaining rate limit
  - Provides clear, actionable error messages for invalid/expired tokens
- **Tracking for opened pull requests** (not just merged PRs)
- **Commit count tracking** per repository
- **Enhanced activity detection** across multiple activity types
- **Comprehensive documentation** in `docs/` folder:
  - `docs/improvements.md` - Technical implementation details
  - `docs/testing.md` - Testing guide with practical examples
  - `docs/validation.md` - Real-world validation examples
  - `docs/releases/v2.0.0.md` - Release notes
- **Development guidelines** (`.github/copilot-instructions.md`)
- **`.gitignore`** file to exclude generated reports from version control

### Changed
- **BREAKING**: Report format now includes additional metrics columns
  - Added "Opened PRs" column to show PR creation activity
  - Added "Commits" column to show commit count
  - Renamed "Total Current Issues" to "Current Issues" for brevity
- **Repository Discovery**: Complete overhaul from search API to org repos API
  - Replaced commit-only search filtering with comprehensive activity detection
  - Now checks `updated_at` AND `pushed_at` timestamps
  - Fetches ALL organization repositories with pagination (handles >100 repos)
  - More reliable detection of repositories with issue/PR activity
  - Captures issues, PRs, releases, wiki edits, and commits
- **Report Presentation**: Cleaner, more focused output
  - Excludes repositories with zero activity metrics from final report
  - Post-processing filter removes "all zeros" rows
  - Reports "Total Repositories with Activity" instead of "Total Repositories Checked"
  - Debug logs show which repos were skipped for full transparency
- **Terminology**: Updated to be date-range agnostic
  - Changed report title from "Weekly Report" to "Activity Report"
  - Removed "weekly" references throughout (supports any date range)
  - Default filename changed from `weekly-report.md` to `report.md`
- **Date Handling**: More intuitive and precise
  - `--start` option now defaults end date to TODAY (was: start + 7 days)
  - Start dates begin at 00:00:00 (midnight)
  - End dates end at 23:59:59 (full day coverage)
  - More intuitive: `--start=2025-10-01` generates report from Oct 1 to today
- **Documentation**: Reorganized structure
  - Moved detailed docs from root to `docs/` folder
  - Enhanced README with CLI usage examples
  - Added comprehensive testing guide
- **Test Suite**: Simplified to focus on essential validation
  - Kept `tests/test-basic.sh` for core functionality
  - Removed overly complex test scripts

### Fixed
- **CRITICAL**: Date range filtering now respects both start AND end dates
  - Previously counted all activity SINCE start date (missing upper bound check)
  - Now correctly filters: `metric_date >= start AND metric_date <= end`
  - Applies to: merged PRs, opened PRs, opened issues, closed issues, commits
  - Impact: Was showing inflated numbers (e.g., 7 merged PRs when actually 0)
- **CRITICAL**: Pagination for organizations with >100 repositories
  - Previously only fetched first 100 repos from GitHub API
  - Now fetches ALL organization repositories across multiple pages
  - Impact: QuantEcon has 209 repos, was only checking first 100
  - Result: Repos like `action-translation-sync` (57 commits) were completely missing
- **CRITICAL**: Repository discovery fallback removed
  - Previously fell back to checking ALL repos when no activity detected
  - Now correctly generates empty report when no activity exists
  - Impact: Was processing 100 unnecessary repos on quiet days
  - Now fails fast with clear errors instead of misleading results
- **CRITICAL**: Repositories with only issue/PR activity now included
  - Previously missed repos with fork-based PRs (no commits in main repo)
  - Activity detection now captures ALL types of repository updates
  - Impact: Complete coverage of organizational activity
- **Opened issues count** now includes issues created and closed in same period
  - Previously only counted issues that remained open
  - Now uses `state=all` to capture all issues created in date range
  - Impact: Was undercounting opened issues
- **macOS Compatibility**: Cross-platform date and text processing
  - Replaced `head -n -1` with portable `sed '$d'` command
  - Fixed date parsing to work with BSD date (macOS) and GNU date (Linux)
  - Simplified date formatting in report headers
  - All operations now work identically on macOS and Linux

### Removed
- Complex test scripts (kept only basic validation)
  - `test-improvements.sh` (too complex, unnecessary)
  - `test-report-preview.sh` (redundant with CLI)
  - `test-show-report.sh` (examples now in README)
- Temporary documentation files
  - `docs/cleanup-summary.md`
- Dangerous fallback mechanisms
  - No more processing all repos when authentication fails
  - Prevents wasted API calls and misleading results

### Validation
- All metrics cross-validated against GitHub API
- Tested with multiple date ranges and organizations
- Verified accuracy with real-world data (QuantEcon org)
- Example validation: `action-translation-sync` with 57 commits correctly detected

### Migration Guide
- **Action users**: No changes required - fully backward compatible
- **CLI users**: New capability - see README for usage examples
- **Report format**: New columns added, existing columns unchanged
- **Date ranges**: Now more accurate with proper upper bound filtering

### Performance
- Slightly increased API calls per repository (5 vs 4) for complete coverage
- Still maintains efficiency by only checking repositories with recent activity
- Rate limiting and retry logic unchanged

**See [Release Notes](docs/releases/v2.0.0.md) for complete details.**

## [1.0.0] - 2025-10-01

### Added
- Initial stable release migrated from QuantEcon/meta repository
- Full compatibility with existing workflows
- Enhanced documentation and examples
- Comprehensive test suite with shell script validation
- GitHub Marketplace listing
- Improved error handling and logging