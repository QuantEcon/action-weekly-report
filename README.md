# QuantEcon Weekly Report Action

[![CI](https://github.com/QuantEcon/action-weekly-report/actions/workflows/ci.yml/badge.svg)](https://github.com/QuantEcon/action-weekly-report/actions/workflows/ci.yml)

A powerful GitHub Action that generates comprehensive activity reports across GitHub organizations. Perfect for tracking team productivity, repository health, and development trends across any time period.

## 🎯 Features

- **📊 Comprehensive Analytics**: Issues, PRs, commits, and activity summaries
- **🔗 Clickable Metrics**: Numbers > 0 link directly to GitHub search results for quick navigation
- **🌐 External Repository Tracking**: Monitor repositories outside your primary organization
- **⚡ Smart Activity Detection**: Captures ALL repository activity (commits, issues, PRs, updates) with intelligent filtering
- **🔄 Complete Coverage**: Handles organizations with hundreds of repositories via pagination
- **🛡️ Rate Limit Resilient**: Built-in retry logic, token validation, and configurable delays
- **📋 Multiple Formats**: Markdown and JSON output options
- **💻 CLI Support**: Run locally or in CI/CD with full command-line interface
- **🎛️ Highly Configurable**: Exclude repositories, custom date ranges, flexible reporting
- **✅ Validated Accuracy**: All metrics cross-validated against GitHub API

## What It Tracks

Activity metrics by repository:
- Current open issues (snapshot)
- Issues opened/closed (in period)
- PRs opened/merged (in period)
- Direct commits (in period)
- Activity summaries

**New in v2.0:** Enhanced tracking for organizations with >100 repositories, post-processing to exclude repos with zero activity, and comprehensive CLI support.

See [documentation](docs/) for detailed information.

## Usage

### As a GitHub Action

**Recommended:** Use the floating `@v2` tag to automatically get the latest v2.x.x features and fixes:

```yaml
- name: Generate activity report
  uses: QuantEcon/action-weekly-report@v2  # Always uses latest v2.x.x release
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    organization: 'QuantEcon'
    output-format: 'markdown'
    exclude-repos: 'lecture-.*\.notebooks'  # Supports regex patterns
    track-external-repos: 'executablebooks/sphinx-proof,executablebooks/sphinx-exercise'  # Track external repos
    api-delay: '1'  # Add 1 second delay between API calls to avoid rate limits
```

**For specific versions:** Pin to an exact release (e.g., `@v2.1.0`, `@v2.0.0`) if you need version stability.

### Command Line Usage (Local Development)

Run the script directly to generate reports locally - perfect for development, testing, or ad-hoc reports:

```bash
# Show available options
./generate-report.sh --help

# Basic usage (last 7 days)
export GITHUB_TOKEN=ghp_xxxxx
./generate-report.sh

# Or use command line argument
./generate-report.sh --token=ghp_xxxxx

# Report from specific date to today
./generate-report.sh --token=ghp_xxxxx --start=2025-10-01

# Custom date range (e.g., monthly report)
./generate-report.sh --token=ghp_xxxxx --start=2025-10-01 --end=2025-10-31

# Different organization
./generate-report.sh --token=ghp_xxxxx --org=YourOrg

# Custom output filename
./generate-report.sh --token=ghp_xxxxx --output=monthly-report.md

# Exclude specific repositories
./generate-report.sh --token=ghp_xxxxx --exclude=repo1,repo2

# Exclude repositories using regex patterns (e.g., all .notebooks repos)
./generate-report.sh --token=ghp_xxxxx --exclude="lecture-.*\.notebooks"

# Track external repositories (from other organizations)
./generate-report.sh --token=ghp_xxxxx --track-external-repos=executablebooks/sphinx-proof,executablebooks/sphinx-exercise

# View the generated report
cat report.md
```

**What happens in CLI mode:**
- ✅ Fetches data from GitHub API (read-only)
- ✅ Generates markdown file locally (default: `report.md`)
- ❌ Does NOT create issues or post anything
- ❌ Does NOT modify your repositories

**Available Options:**
- `--token=TOKEN` - GitHub token for API access (read-only, see [Token Usage](#how-it-works))
- `--org=ORG` - Organization name (default: QuantEcon)
- `--start=YYYY-MM-DD` - Start date for report (end date defaults to today)
- `--end=YYYY-MM-DD` - End date for report (use with --start for custom range)
- `--output=FILE` - Output filename (default: report.md)
- `--exclude=REPOS` - Comma-separated list of repos or regex patterns to exclude (e.g., `repo1,lecture-.*\.notebooks`)
- `--track-external-repos=LIST` - Comma-separated list of external repos to track (format: `org/repo`, e.g., `executablebooks/sphinx-proof,executablebooks/sphinx-exercise`)
- `--delay=SECONDS` - Delay between API calls (default: 0)

The report is saved to `report.md` (or your specified output file) in the current directory.

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-token` | GitHub token with access to the organization | Yes | - |
| `organization` | GitHub organization name | No | `QuantEcon` |
| `output-format` | Output format (`markdown` or `json`) | No | `markdown` |
| `exclude-repos` | Comma-separated list of repository names or regex patterns to exclude (e.g., `repo1,lecture-.*\.notebooks`) | No | `''` |
| `track-external-repos` | Comma-separated list of external repositories to track (format: `org/repo`, e.g., `executablebooks/sphinx-proof,executablebooks/sphinx-exercise`) | No | `''` |
| `api-delay` | Delay in seconds between API calls to avoid rate limits (0 = no delay) | No | `0` |

## Outputs

| Output | Description |
|--------|-------------|
| `report-content` | The full generated report content |
| `report-summary` | A brief summary of the report metrics |

## How It Works

### What This Action Does

1. **Fetches** repository data from GitHub API (read-only, with full pagination support)
2. **Generates** a markdown report file (default: `report.md`)
3. **Outputs** report content for downstream workflow steps

**Key Improvements in v2.0:**
- Handles organizations with >100 repositories (full pagination)
- Accurate date range filtering (respects both start and end dates)
- Post-processing removes repos with zero activity (cleaner reports)
- Token validation on startup (fail-fast with clear errors)

**This action does NOT:**
- Create GitHub issues (that's handled by your workflow using a separate action)
- Modify any repositories
- Post or publish anything

### Token Usage

**For CLI Mode (Local Development):**
- Token is used to **read** organization data via GitHub API
- No issues are created - you just get a markdown file
- Same permissions as action mode (read-only)

**For Action Mode (Automated Workflows):**
- Token is used to **read** organization data
- Report is saved to `report.md` (default)
- Your workflow can then post the report as an issue using a separate action

**Required Permissions:**
- ✅ `repo` - Read repository data
- ✅ `read:org` - Read organization data

**Not Required:**
- ❌ Issue creation permissions (unless your workflow posts issues separately)

## Example Workflow

```yaml
jobs:
  weekly-report:
    runs-on: ubuntu-latest
    steps:
      # Step 1: Generate the report (our action)
      - name: Generate weekly report
        uses: QuantEcon/action-weekly-report@v2  # Always uses latest v2.x.x release
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          organization: 'QuantEcon'
          track-external-repos: 'executablebooks/sphinx-proof,executablebooks/sphinx-exercise'
      
      # Step 2: Create issue with report (separate action - optional)
      - name: Create issue from report
        uses: peter-evans/create-issue-from-file@v4
        with:
          title: Weekly Activity Report
          content-filepath: weekly-report.md  # Action outputs to weekly-report.md
          labels: report, automated
```

**Note:** The action outputs to `weekly-report.md` by default. In CLI mode, it uses `report.md`.

## Report Format

The generated report includes a summary table with activity metrics and totals across all repositories. Only repositories with activity in the reporting period are included.

**Interactive Hyperlinks:** Metrics greater than 0 are automatically formatted as clickable links that take you directly to the filtered GitHub results. For example, clicking "[7](https://github.com/QuantEcon/QuantEcon.jl/pulls?q=is:pr+merged:2025-10-01..2025-10-20)" shows the 7 merged PRs for that period. Only 0 values display as plain text.

**External Repositories:** When tracking external repos with `track-external-repos`, they appear in a separate "External Repositories" section below the main organization table. Each section has independent totals. External repos are displayed with their full `org/repo` format for clarity.

See [Hyperlink Feature Documentation](docs/hyperlinks.md) for details and [example report](docs/testing.md).

## Rate Limiting

For large organizations, use the `api-delay` parameter to add delays between requests. See [documentation](docs/) for details.

## Documentation

- **[Testing Guide](docs/testing.md)** - How to test and validate the action
- **[Technical Details](docs/improvements.md)** - Implementation details
- **[Validation Examples](docs/validation.md)** - Real-world validation
- **[Release Notes](docs/releases/)** - Version-specific changes

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

## License

MIT - See [LICENSE](LICENSE) for details.