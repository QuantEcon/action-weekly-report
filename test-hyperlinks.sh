#!/bin/bash
# Test script for hyperlink feature

# Test the format_metric function
format_metric() {
    local count="$1"
    local url="$2"
    
    if [ "$count" -gt 0 ]; then
        echo "[$count]($url)"
    else
        echo "$count"
    fi
}

echo "Testing format_metric function:"
echo "================================"
echo ""

# Test cases
echo "Test 1: count=0 (should show plain '0')"
result=$(format_metric 0 "https://github.com/test")
echo "Result: $result"
echo "Expected: 0"
echo ""

echo "Test 2: count=1 (should show '[1](https://github.com/test)')"
result=$(format_metric 1 "https://github.com/test")
echo "Result: $result"
echo "Expected: [1](https://github.com/test)"
echo ""

echo "Test 3: count=2 (should show '[2](https://github.com/test)')"
result=$(format_metric 2 "https://github.com/test")
echo "Result: $result"
echo "Expected: [2](https://github.com/test)"
echo ""

echo "Test 4: count=7 (should show '[7](https://github.com/QuantEcon/repo/pulls?q=is:pr+merged:2025-10-01..2025-10-20)')"
result=$(format_metric 7 "https://github.com/QuantEcon/repo/pulls?q=is:pr+merged:2025-10-01..2025-10-20")
echo "Result: $result"
echo "Expected: [7](https://github.com/QuantEcon/repo/pulls?q=is:pr+merged:2025-10-01..2025-10-20)"
echo ""

echo "================================"
echo "Creating sample markdown table:"
echo "================================"
echo ""

# Create a sample table row
repo="QuantEcon.jl"
start_display="2025-10-01"
end_display="2025-10-20"
org="QuantEcon"

current_issues=38
opened_issues=7
closed_issues=3
opened_prs=7
merged_prs=3
commits=3

# Create URLs
current_issues_url="https://github.com/${org}/${repo}/issues?q=is:issue+is:open"
opened_issues_url="https://github.com/${org}/${repo}/issues?q=is:issue+created:${start_display}..${end_display}"
closed_issues_url="https://github.com/${org}/${repo}/issues?q=is:issue+closed:${start_display}..${end_display}"
opened_prs_url="https://github.com/${org}/${repo}/pulls?q=is:pr+created:${start_display}..${end_display}"
merged_prs_url="https://github.com/${org}/${repo}/pulls?q=is:pr+merged:${start_display}..${end_display}"
commits_url="https://github.com/${org}/${repo}/commits?since=${start_display}&until=${end_display}"

# Format metrics
current_issues_display=$(format_metric "$current_issues" "$current_issues_url")
opened_issues_display=$(format_metric "$opened_issues" "$opened_issues_url")
closed_issues_display=$(format_metric "$closed_issues" "$closed_issues_url")
opened_prs_display=$(format_metric "$opened_prs" "$opened_prs_url")
merged_prs_display=$(format_metric "$merged_prs" "$merged_prs_url")
commits_display=$(format_metric "$commits" "$commits_url")

echo "| Repository | Current Issues | Opened Issues | Closed Issues | Opened PRs | Merged PRs | Commits |"
echo "|------------|----------------|---------------|---------------|------------|------------|---------|"
echo "| $repo | $current_issues_display | $opened_issues_display | $closed_issues_display | $opened_prs_display | $merged_prs_display | $commits_display |"
echo ""

# Show what this looks like when rendered
echo "================================"
echo "When rendered in Markdown, numbers > 1 will be clickable links:"
echo ""
echo "- Current Issues: 38 (links to open issues)"
echo "- Opened Issues: 7 (links to issues created in period)"
echo "- Closed Issues: 3 (links to issues closed in period)"
echo "- Opened PRs: 7 (links to PRs created in period)"
echo "- Merged PRs: 3 (links to PRs merged in period)"
echo "- Commits: 3 (links to commits in period)"
