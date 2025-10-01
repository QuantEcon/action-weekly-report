# QuantEcon Weekly Report Action

[![CI](https://github.com/QuantEcon/action-weekly-report/actions/workflows/ci.yml/badge.svg)](https://github.com/QuantEcon/action-weekly-report/actions/workflows/ci.yml)
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-Weekly%20Report-blue.svg?colorA=24292e&colorB=0366d6&style=flat&longCache=true&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAM6wAADOsB5dZE0gAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAERSURBVCiRhZG/SsMxFEafKoEMFhyrdsFt6FYHNycunTo0Q4LgEhcnW4PgYgchGjoYiQ6ON2ARpK9nCxjUjuIFP+B+h3O/xmE2yVxPOJGkC3RgJ8qA3bQn7SiTKCQdC4J8HDW0v85CZaUHNzxhQcHdJvjZwM4mXaKJ4BdDMKxIsYoim1Smk2X6HPUdCnU5gO5D9POqvayBzY8nwoJJ+G9h9vGB0U8h8dNPgGLKlv1n6cJgAjjfY9lv1CVKq5f3oUAe5dJz9n3RkBhGA1ouJ/hT5a4c8yQQYSdF8vhN5gT1igMgZ9nJgzUqm9E1V+8rbYQhptmEURKA=)](https://github.com/marketplace/actions/quantecon-weekly-report)

A powerful GitHub Action that generates comprehensive weekly activity reports across GitHub organizations. Perfect for tracking team productivity, repository health, and development trends.

## 🎯 Features

- **📊 Comprehensive Analytics**: Issues, PRs, commits, and activity summaries
- **⚡ Smart Filtering**: Only checks repositories with recent activity for efficiency  
- **🛡️ Rate Limit Resilient**: Built-in retry logic and configurable delays
- **📋 Multiple Formats**: Markdown and JSON output options
- **🎛️ Highly Configurable**: Exclude repositories, custom delays, flexible reporting
- **🔄 Fallback Mechanisms**: Ensures complete coverage even when filtering fails

## Features

This action generates a report containing:
- Number of issues opened by repository (last 7 days)
- Number of issues closed by repository (last 7 days)  
- Number of PRs merged by repository (last 7 days)
- Summary totals across all repositories

### Efficiency Features
- **Smart repository filtering**: Uses GitHub Search API to identify repositories with recent activity (commits in the last 7 days) before checking for issues and PRs
- **Fallback mechanism**: If no repositories are found with recent commits, falls back to checking all organization repositories to ensure complete coverage
- **Activity-based reporting**: Only includes repositories with actual activity in the generated report
- **Rate limit handling**: Automatically retries on rate limit errors with exponential backoff, and provides clear warnings when data is incomplete
- **Configurable delays**: Optional delays between API calls to reduce rate limit pressure

## Usage

```yaml
- name: Generate weekly report
  uses: QuantEcon/action-weekly-report@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    organization: 'QuantEcon'
    output-format: 'markdown'
    exclude-repos: 'lecture-python.notebooks,auto-updated-repo'
    api-delay: '1'  # Add 1 second delay between API calls to avoid rate limits
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-token` | GitHub token with access to the organization | Yes | - |
| `organization` | GitHub organization name | No | `QuantEcon` |
| `output-format` | Output format (`markdown` or `json`) | No | `markdown` |
| `exclude-repos` | Comma-separated list of repository names to exclude from the report | No | `''` |
| `api-delay` | Delay in seconds between API calls to avoid rate limits (0 = no delay) | No | `0` |

## Outputs

| Output | Description |
|--------|-------------|
| `report-content` | The full generated report content |
| `report-summary` | A brief summary of the report metrics |

## Permissions

The GitHub token must have read access to:
- Organization repositories
- Repository issues
- Repository pull requests

## Example Workflow

See the [weekly report workflow](../../workflows/weekly-report.yml) for a complete example that runs every Saturday and creates an issue with the report.

## Report Format

The generated markdown report includes:
- A summary table showing activity by repository
- Total counts across all repositories
- Data completeness warnings if API calls failed due to rate limits or other errors
- Report metadata (generation date, period covered)

Only repositories with activity in the reporting period are included in the detailed table.

## Rate Limiting

GitHub's API has rate limits (5000 requests/hour for authenticated requests). For large organizations:

- **Monitor warnings**: The report will include warnings when rate limits are hit
- **Add delays**: Use the `api-delay` parameter to add delays between requests (e.g., `api-delay: '1'` for 1 second delays)
- **Run during off-peak**: Schedule reports during off-peak hours to avoid conflicts with other API usage
- **Incomplete data**: When rate limited, the report will show `0` for affected repositories and include a warning