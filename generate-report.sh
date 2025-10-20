#!/bin/bash
set -e

# Parse command line arguments
START_DATE=""
END_DATE=""
CLI_TOKEN=""
CLI_ORG=""
CLI_OUTPUT=""

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Generate an activity report for a GitHub organization.

OPTIONS:
    --token=TOKEN         GitHub personal access token (or set GITHUB_TOKEN env var)
    --org=ORG            Organization name (default: QuantEcon)
    --start=YYYY-MM-DD   Start date for report (end date defaults to today)
    --end=YYYY-MM-DD     End date for report (requires --start)
    --output=FILE        Output filename (default: report.md)
    --exclude=REPOS      Comma-separated list of repos to exclude (supports regex patterns)
    --delay=SECONDS      Delay between API calls (default: 0)
    --help               Show this help message

EXAMPLES:
    # Generate report for last 7 days (default)
    $0 --token=ghp_xxxxx

    # Generate report from specific date to today
    $0 --token=ghp_xxxxx --start=2025-10-01

    # Generate report for specific date range
    $0 --token=ghp_xxxxx --start=2025-10-01 --end=2025-10-07

    # Generate report for different organization
    $0 --token=ghp_xxxxx --org=YourOrg

    # Custom output filename
    $0 --token=ghp_xxxxx --output=custom-report.md

    # Exclude specific repositories
    $0 --token=ghp_xxxxx --exclude=repo1,repo2

    # Exclude repositories using regex patterns
    $0 --token=ghp_xxxxx --exclude="lecture-.*\.notebooks,.*-archive"

ENVIRONMENT VARIABLES:
    GITHUB_TOKEN or INPUT_GITHUB_TOKEN    GitHub token
    INPUT_ORGANIZATION                     Organization name
    INPUT_OUTPUT_FORMAT                    Output format (markdown/json)
    INPUT_EXCLUDE_REPOS                    Repositories to exclude
    INPUT_API_DELAY                        API delay in seconds

OUTPUT:
    Report is saved to: report.md (or specified --output file)

EOF
}

# Parse command line arguments
for arg in "$@"; do
    case $arg in
        --token=*)
            CLI_TOKEN="${arg#*=}"
            shift
            ;;
        --org=*)
            CLI_ORG="${arg#*=}"
            shift
            ;;
        --start=*)
            START_DATE="${arg#*=}"
            shift
            ;;
        --end=*)
            END_DATE="${arg#*=}"
            shift
            ;;
        --exclude=*)
            CLI_EXCLUDE="${arg#*=}"
            shift
            ;;
        --delay=*)
            CLI_DELAY="${arg#*=}"
            shift
            ;;
        --output=*)
            CLI_OUTPUT="${arg#*=}"
            shift
            ;;
        --help)
            show_usage
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            show_usage
            exit 1
            ;;
    esac
done

echo "DEBUG: Starting report generation"
echo "DEBUG: Environment check - GITHUB_OUTPUT: ${GITHUB_OUTPUT:-NOT_SET}"

# Get inputs - CLI args take precedence over environment variables
GITHUB_TOKEN="${CLI_TOKEN:-${GITHUB_TOKEN:-${INPUT_GITHUB_TOKEN}}}"
ORGANIZATION="${CLI_ORG:-${INPUT_ORGANIZATION:-QuantEcon}}"
OUTPUT_FORMAT="${INPUT_OUTPUT_FORMAT:-markdown}"
EXCLUDE_REPOS="${CLI_EXCLUDE:-${INPUT_EXCLUDE_REPOS:-}}"
API_DELAY="${CLI_DELAY:-${INPUT_API_DELAY:-0}}"

# Set output file based on context
# - GitHub Actions: Use weekly-report.md for backward compatibility
# - CLI mode: Use report.md (or user-specified filename)
if [ -n "$GITHUB_OUTPUT" ] || [ -n "$INPUT_GITHUB_TOKEN" ]; then
    # Running as GitHub Action - use weekly-report.md
    OUTPUT_FILE="${CLI_OUTPUT:-weekly-report.md}"
else
    # Running in CLI mode - use report.md
    OUTPUT_FILE="${CLI_OUTPUT:-report.md}"
fi

# Validate GitHub token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "ERROR: GitHub token is required!"
    echo ""
    echo "Please provide a token via:"
    echo "  1. Command line: --token=your_token"
    echo "  2. Environment:  export GITHUB_TOKEN=your_token"
    echo ""
    echo "Create a token at: https://github.com/settings/tokens"
    echo "Required scopes: repo, read:org"
    exit 1
fi

echo "DEBUG: Inputs - ORG: $ORGANIZATION, FORMAT: $OUTPUT_FORMAT, EXCLUDE: $EXCLUDE_REPOS"
echo "DEBUG: Output file: $OUTPUT_FILE"

# Date calculations
if [ -n "$START_DATE" ] && [ -n "$END_DATE" ]; then
    # Use provided date range - start at 00:00:00, end at 23:59:59
    WEEK_AGO=$(date -d "$START_DATE 00:00:00" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -j -u -f "%Y-%m-%d" "$START_DATE" +"%Y-%m-%dT00:00:00Z")
    NOW=$(date -d "$END_DATE 23:59:59" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -j -u -f "%Y-%m-%d" "$END_DATE" +"%Y-%m-%dT23:59:59Z")
    echo "Using custom date range: $START_DATE to $END_DATE"
elif [ -n "$START_DATE" ]; then
    # Start date provided, use today as end date - start at 00:00:00
    WEEK_AGO=$(date -d "$START_DATE 00:00:00" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -j -u -f "%Y-%m-%d" "$START_DATE" +"%Y-%m-%dT00:00:00Z")
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "Using custom start date: $START_DATE to today"
else
    # Default: last 7 days - start at 00:00:00 7 days ago
    WEEK_AGO=$(date -d "7 days ago 00:00:00" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -v-7d -u +"%Y-%m-%dT00:00:00Z")
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "Using default date range: last 7 days"
fi

echo "Generating activity report for ${ORGANIZATION} organization"
echo "Period: ${WEEK_AGO} to ${NOW}"

# Validate GitHub token before proceeding
echo "Validating GitHub token..."
token_check=$(curl -s -H "Authorization: token ${GITHUB_TOKEN}" "https://api.github.com/rate_limit")
if echo "$token_check" | jq -e '.message' 2>/dev/null | grep -qi "bad credentials"; then
    echo "ERROR: GitHub token is invalid or expired!"
    echo ""
    echo "The provided GITHUB_TOKEN returned: Bad credentials"
    echo ""
    echo "Please check your token and ensure it has the required scopes:"
    echo "  - repo (full control of private repositories)"
    echo "  - read:org (read org and team membership)"
    echo ""
    echo "Create a new token at: https://github.com/settings/tokens"
    exit 1
elif echo "$token_check" | jq -e '.resources.core.remaining' >/dev/null 2>&1; then
    remaining=$(echo "$token_check" | jq -r '.resources.core.remaining')
    echo "✓ Token validated successfully (Rate limit: $remaining requests remaining)"
else
    echo "ERROR: Unable to validate GitHub token!"
    echo "API response: $token_check"
    exit 1
fi

# Function to make GitHub API calls with rate limit handling
api_call() {
    local endpoint="$1"
    local page="${2:-1}"
    local max_retries=3
    local retry_count=0
    local delay="${API_DELAY:-0}"
    
    # Add delay between requests if specified
    if [ "$delay" -gt 0 ]; then
        sleep "$delay"
    fi
    
    while [ $retry_count -lt $max_retries ]; do
        # Construct URL with proper query parameter handling
        local url="https://api.github.com${endpoint}"
        if [[ "$endpoint" == *"?"* ]]; then
            url="${url}&page=${page}&per_page=100"
        else
            url="${url}?page=${page}&per_page=100"
        fi
        
        local response=$(curl -s -w "\n%{http_code}" -H "Authorization: token ${GITHUB_TOKEN}" \
                            -H "Accept: application/vnd.github.v3+json" \
                            "$url")
        
        local http_code=$(echo "$response" | tail -n1)
        local body=$(echo "$response" | sed '$d')
        
        case "$http_code" in
            200)
                echo "$body"
                return 0
                ;;
            403)
                # Check if it's a rate limit error
                if echo "$body" | jq -e '.message' 2>/dev/null | grep -q "rate limit"; then
                    retry_count=$((retry_count + 1))
                    if [ $retry_count -lt $max_retries ]; then
                        local wait_time=$((retry_count * retry_count * 60))  # Exponential backoff: 1min, 4min, 9min
                        echo "Rate limit exceeded for $endpoint. Waiting ${wait_time}s before retry $retry_count/$max_retries..." >&2
                        sleep "$wait_time"
                        continue
                    else
                        echo "Rate limit exceeded for $endpoint after $max_retries retries. Data will be incomplete." >&2
                        echo '{"error": "rate_limit_exceeded", "message": "API rate limit exceeded"}'
                        return 1
                    fi
                else
                    echo "Access forbidden for $endpoint: $body" >&2
                    echo '{"error": "forbidden", "message": "Access forbidden"}'
                    return 1
                fi
                ;;
            404)
                echo "Repository not found: $endpoint" >&2
                echo '{"error": "not_found", "message": "Repository not found"}'
                return 1
                ;;
            *)
                echo "API call failed for $endpoint with status $http_code: $body" >&2
                echo '{"error": "api_error", "message": "API call failed"}'
                return 1
                ;;
        esac
    done
}

# Get all repositories and filter by activity
echo "Fetching all repositories for ${ORGANIZATION}..."

# Fetch all organization repositories with pagination
all_repos_response="[]"
page=1
while true; do
    echo "Fetching page $page..."
    page_response=$(api_call "/orgs/${ORGANIZATION}/repos" "$page")
    
    if [ -z "$page_response" ] || [ "$page_response" = "null" ]; then
        break
    fi
    
    # Check if we got an array back
    if ! echo "$page_response" | jq -e 'type == "array"' >/dev/null 2>&1; then
        # Not an array, probably an error - use as final response and break
        all_repos_response="$page_response"
        break
    fi
    
    # Check if array is empty (no more results)
    repo_count=$(echo "$page_response" | jq 'length')
    if [ "$repo_count" -eq 0 ]; then
        break
    fi
    
    # Merge results
    all_repos_response=$(echo "$all_repos_response" "$page_response" | jq -s 'add')
    
    # If we got less than 100 results, we're done
    if [ "$repo_count" -lt 100 ]; then
        break
    fi
    
    page=$((page + 1))
done

echo "Total repositories fetched: $(echo "$all_repos_response" | jq 'length')"

if [ -z "$all_repos_response" ] || [ "$all_repos_response" = "null" ]; then
    echo "ERROR: Failed to fetch repositories for organization: ${ORGANIZATION}"
    echo ""
    echo "Possible causes:"
    echo "  1. Organization name is incorrect"
    echo "  2. Token lacks read:org permission"
    echo "  3. Network or API issue"
    echo ""
    echo "Please verify:"
    echo "  - Organization exists: https://github.com/${ORGANIZATION}"
    echo "  - Token has 'read:org' scope"
    exit 1
fi

# Check if the response is an error object
if echo "$all_repos_response" | jq -e '.error' >/dev/null 2>&1; then
    error_type=$(echo "$all_repos_response" | jq -r '.error')
    error_msg=$(echo "$all_repos_response" | jq -r '.message')
    echo "ERROR: API call failed - $error_type: $error_msg"
    exit 1
fi

# Extract repo names and their last updated timestamps
repos_json=$(echo "$all_repos_response" | jq -c '[.[] | {name: .name, updated_at: .updated_at, pushed_at: .pushed_at}]')

echo "Total repositories found: $(echo "$repos_json" | jq 'length')"

# Filter repositories with activity in the date range
# We check multiple timestamps to capture all types of activity
repo_names=$(echo "$repos_json" | jq -r --arg since "$WEEK_AGO" --arg until "$NOW" '.[] | select(
    (.updated_at >= $since and .updated_at <= $until) or 
    (.pushed_at >= $since and .pushed_at <= $until)
) | .name')

if [ -z "$repo_names" ]; then
    echo "No repositories found with activity in the date range"
    echo "This is normal for periods with no commits, PR merges, or issue activity."
    echo "Generating empty report..."
    # Set to empty - we'll generate a report showing zero activity
    repo_names=""
fi

if [ -n "$repo_names" ]; then
    echo "Repositories with activity in date range: $(echo "$repo_names" | wc -l)"
else
    echo "Repositories with activity in date range: 0"
fi
echo "Sample repositories:"
echo "$repo_names" | head -10  # Show first 10 for logging

# Filter out excluded repositories if any are specified
if [ -n "$EXCLUDE_REPOS" ]; then
    # Convert comma-separated list to array and filter out excluded repos
    IFS=',' read -ra exclude_array <<< "$EXCLUDE_REPOS"
    echo "Exclude patterns (${#exclude_array[@]} total):"
    for pattern in "${exclude_array[@]}"; do
        pattern=$(echo "$pattern" | xargs)  # Trim whitespace
        echo "  - Pattern: '$pattern'"
    done
    
    filtered_repos=""
    while IFS= read -r repo; do
        [ -z "$repo" ] && continue
        excluded=false
        for exclude_pattern in "${exclude_array[@]}"; do
            # Trim whitespace
            exclude_pattern=$(echo "$exclude_pattern" | xargs)
            # Check if pattern matches using grep -E (extended regex)
            if echo "$repo" | grep -qE "^${exclude_pattern}$"; then
                excluded=true
                echo "  ✗ Excluding: $repo (matched '$exclude_pattern')"
                break
            fi
        done
        if [ "$excluded" = false ]; then
            if [ -z "$filtered_repos" ]; then
                filtered_repos="$repo"
            else
                filtered_repos="$filtered_repos"$'\n'"$repo"
            fi
        fi
    done <<< "$repo_names"
    repo_names="$filtered_repos"
    echo "Repositories after filtering: $(echo "$repo_names" | wc -l | xargs)"
fi

# Initialize report variables
total_current_issues=0
total_opened_issues=0
total_closed_issues=0
total_merged_prs=0
total_commits=0
total_opened_prs=0
failed_repos=0
rate_limited_repos=0
report_content=""

# Start building the report
if [ "$OUTPUT_FORMAT" = "markdown" ]; then
    # Format dates for display (portable way)
    # Extract date portion from ISO format (YYYY-MM-DDTHH:MM:SSZ)
    start_display=$(echo "$WEEK_AGO" | cut -d'T' -f1)
    end_display=$(echo "$NOW" | cut -d'T' -f1)
    
    report_content="# ${ORGANIZATION} Activity Report

**Report Period:** $start_display to $end_display

## Summary

| Repository | Current Issues | Opened Issues | Closed Issues | Opened PRs | Merged PRs | Commits |
|------------|----------------|---------------|---------------|------------|------------|---------|"
    echo "DEBUG: Initial report content set, length: ${#report_content}"
fi

# Process each repository
repo_count=0
repos_with_activity=0
while IFS= read -r repo; do
    [ -z "$repo" ] && continue
    repo_count=$((repo_count + 1))
    
    echo "Processing repository: $repo"
    
    # Count total current open issues
    current_issues_response=$(api_call "/repos/${ORGANIZATION}/${repo}/issues?state=open")
    if [ $? -eq 0 ]; then
        current_issues=$(echo "$current_issues_response" | jq 'if type == "array" then [.[] | select(.pull_request == null)] | length else 0 end')
    else
        current_issues=0
        if echo "$current_issues_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Count opened issues in the date range
    opened_response=$(api_call "/repos/${ORGANIZATION}/${repo}/issues?state=all")
    if [ $? -eq 0 ]; then
        opened_issues=$(echo "$opened_response" | jq --arg since "$WEEK_AGO" --arg until "$NOW" 'if type == "array" then [.[] | select(.created_at >= $since and .created_at <= $until and .pull_request == null)] | length else 0 end')
    else
        opened_issues=0
        if echo "$opened_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Count closed issues in the date range
    closed_response=$(api_call "/repos/${ORGANIZATION}/${repo}/issues?state=closed")
    if [ $? -eq 0 ]; then
        closed_issues=$(echo "$closed_response" | jq --arg since "$WEEK_AGO" --arg until "$NOW" 'if type == "array" then [.[] | select(.closed_at != null and .closed_at >= $since and .closed_at <= $until and .pull_request == null)] | length else 0 end')
    else
        closed_issues=0
        if echo "$closed_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Count merged PRs in the date range
    prs_response=$(api_call "/repos/${ORGANIZATION}/${repo}/pulls?state=closed")
    if [ $? -eq 0 ]; then
        merged_prs=$(echo "$prs_response" | jq --arg since "$WEEK_AGO" --arg until "$NOW" 'if type == "array" then [.[] | select(.merged_at != null and .merged_at >= $since and .merged_at <= $until)] | length else 0 end')
    else
        merged_prs=0
        if echo "$prs_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Count opened PRs in the date range (both open and closed)
    all_prs_response=$(api_call "/repos/${ORGANIZATION}/${repo}/pulls?state=all")
    if [ $? -eq 0 ]; then
        opened_prs=$(echo "$all_prs_response" | jq --arg since "$WEEK_AGO" --arg until "$NOW" 'if type == "array" then [.[] | select(.created_at >= $since and .created_at <= $until)] | length else 0 end')
    else
        opened_prs=0
        if echo "$all_prs_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Count commits in the date range
    commits_response=$(api_call "/repos/${ORGANIZATION}/${repo}/commits?since=${WEEK_AGO}&until=${NOW}")
    if [ $? -eq 0 ]; then
        commits=$(echo "$commits_response" | jq 'if type == "array" then length else 0 end')
    else
        commits=0
        if echo "$commits_response" | jq -e '.error' 2>/dev/null | grep -q "rate_limit"; then
            rate_limited_repos=$((rate_limited_repos + 1))
        else
            failed_repos=$((failed_repos + 1))
        fi
    fi
    
    # Handle null/empty values
    current_issues=${current_issues:-0}
    opened_issues=${opened_issues:-0}
    closed_issues=${closed_issues:-0}
    merged_prs=${merged_prs:-0}
    opened_prs=${opened_prs:-0}
    commits=${commits:-0}
    
    # Add to totals
    total_current_issues=$((total_current_issues + current_issues))
    total_opened_issues=$((total_opened_issues + opened_issues))
    total_closed_issues=$((total_closed_issues + closed_issues))
    total_merged_prs=$((total_merged_prs + merged_prs))
    total_opened_prs=$((total_opened_prs + opened_prs))
    total_commits=$((total_commits + commits))
    
    # Only include repos with actual activity (exclude repos with all zeros in activity columns)
    # Note: We check activity metrics only, not current_issues (which is current state, not activity)
    if [ $((opened_issues + closed_issues + opened_prs + merged_prs + commits)) -gt 0 ]; then
        repos_with_activity=$((repos_with_activity + 1))
        if [ "$OUTPUT_FORMAT" = "markdown" ]; then
            report_content="${report_content}
| $repo | $current_issues | $opened_issues | $closed_issues | $opened_prs | $merged_prs | $commits |"
        fi
    else
        echo "DEBUG: Skipping $repo from report (no activity: all metrics are zero)"
    fi
    
done <<< "$repo_names"

echo "DEBUG: Processed $repo_count repositories"
echo "DEBUG: Repositories with activity (included in report): $repos_with_activity"
echo "DEBUG: Repositories skipped (no activity): $((repo_count - repos_with_activity))"
echo "DEBUG: Final report content length: ${#report_content}"

# Add summary to report
if [ "$OUTPUT_FORMAT" = "markdown" ]; then
    report_content="${report_content}
|**Total**|**$total_current_issues**|**$total_opened_issues**|**$total_closed_issues**|**$total_opened_prs**|**$total_merged_prs**|**$total_commits**|

## Details

- **Total Repositories with Activity:** $repos_with_activity
- **Total Current Open Issues:** $total_current_issues
- **Total Issues Opened:** $total_opened_issues
- **Total Issues Closed:** $total_closed_issues
- **Total PRs Opened:** $total_opened_prs
- **Total PRs Merged:** $total_merged_prs
- **Total Commits:** $total_commits"
    
    # Add warnings about incomplete data if any API calls failed
    if [ $rate_limited_repos -gt 0 ] || [ $failed_repos -gt 0 ]; then
        report_content="${report_content}

### ⚠️ Data Completeness Warnings
"
        if [ $rate_limited_repos -gt 0 ]; then
            report_content="${report_content}
- **Rate Limited:** $rate_limited_repos API calls hit rate limits. Data may be incomplete."
        fi
        if [ $failed_repos -gt 0 ]; then
            report_content="${report_content}
- **Failed Requests:** $failed_repos API calls failed. Data may be incomplete."
        fi
        report_content="${report_content}

*Consider adding API delays or running during off-peak hours to avoid rate limits.*"
    fi
    
    report_content="${report_content}

*Report generated on $(date) by ${ORGANIZATION} Report Action*"
fi

# Create summary
summary="Summary: $total_current_issues current open issues, $total_opened_issues issues opened, $total_closed_issues issues closed, $total_opened_prs PRs opened, $total_merged_prs PRs merged, $total_commits commits"

# Save report to file
echo "$report_content" > "$OUTPUT_FILE"

echo "Report generated: $OUTPUT_FILE"

# Debug: Check if GITHUB_OUTPUT is set and accessible
echo "DEBUG: GITHUB_OUTPUT environment variable: ${GITHUB_OUTPUT:-NOT_SET}"
echo "DEBUG: Report content length: ${#report_content}"
echo "DEBUG: Summary: $summary"

# Set outputs
if [ -n "$GITHUB_OUTPUT" ]; then
    echo "DEBUG: Writing to GITHUB_OUTPUT file"
    echo "DEBUG: Content preview (first 100 chars): ${report_content:0:100}"
    echo "DEBUG: Summary preview: $summary"
    
    # Use a unique delimiter to avoid conflicts with content
    delimiter="QUANTECON_REPORT_END_$(date +%s)"
    echo "report-content<<${delimiter}" >> "$GITHUB_OUTPUT"
    echo "$report_content" >> "$GITHUB_OUTPUT"
    echo "${delimiter}" >> "$GITHUB_OUTPUT"
    
    echo "report-summary=$summary" >> "$GITHUB_OUTPUT"
    
    echo "DEBUG: Outputs written to GITHUB_OUTPUT"
    echo "DEBUG: GITHUB_OUTPUT file size: $(wc -c < "$GITHUB_OUTPUT")"
else
    echo "ERROR: GITHUB_OUTPUT environment variable not set!"
fi

echo "Report generated successfully!"
echo "Summary: $summary"