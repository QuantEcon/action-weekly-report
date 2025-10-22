# Hyperlink Feature for Metrics

## Overview

The weekly report now includes **clickable hyperlinks** for metrics greater than 1. When viewing the report in Markdown, clicking on a number will take you directly to the relevant GitHub page showing those specific items.

## Feature Behavior

### When Links Are Added
- **Metrics > 0**: Number becomes a clickable hyperlink (1 and above)
- **Metrics = 0**: Number displays as plain text (no link)

This provides quick access to see the actual items on GitHub while keeping zero values clean and simple.

### Example

```markdown
| Repository | Opened Issues | Merged PRs |
|------------|---------------|------------|
| repo-a     | 0             | [1](https://github.com/...) |
| repo-b     | [7](https://github.com/...) | [3](https://github.com/...) |
```

In the rendered view:
- `repo-a`: 0 shows as plain number, 1 is a clickable hyperlink
- `repo-b`: Both metrics are clickable hyperlinks

## Link Details

Each metric type links to a specific GitHub view with pre-filtered results:

### 1. Current Issues
**URL Format:**
```
https://github.com/{ORG}/{REPO}/issues?q=is:issue+is:open
```

**Shows:** All currently open issues in the repository

### 2. Opened Issues
**URL Format:**
```
https://github.com/{ORG}/{REPO}/issues?q=is:issue+created:{START}..{END}
```

**Shows:** Issues created during the report period

### 3. Closed Issues
**URL Format:**
```
https://github.com/{ORG}/{REPO}/issues?q=is:issue+closed:{START}..{END}
```

**Shows:** Issues closed during the report period

### 4. Opened PRs
**URL Format:**
```
https://github.com/{ORG}/{REPO}/pulls?q=is:pr+created:{START}..{END}
```

**Shows:** Pull requests created during the report period

### 5. Merged PRs
**URL Format:**
```
https://github.com/{ORG}/{REPO}/pulls?q=is:pr+merged:{START}..{END}
```

**Shows:** Pull requests merged during the report period

### 6. Commits
**URL Format:**
```
https://github.com/{ORG}/{REPO}/commits?since={START}&until={END}
```

**Shows:** Commits made during the report period

## Implementation Details

### Helper Function

A new `format_metric()` function was added to the report generation script:

```bash
format_metric() {
    local count="$1"
    local url="$2"
    
    if [ "$count" -gt 0 ]; then
        echo "[$count]($url)"
    else
        echo "$count"
    fi
}
```

### Usage in Report

For each repository, the script:

1. Constructs GitHub URLs with appropriate filters
2. Formats each metric using `format_metric()`
3. Inserts the formatted values into the table

```bash
# Create URLs
current_issues_url="https://github.com/${ORGANIZATION}/${repo}/issues?q=is:issue+is:open"
opened_issues_url="https://github.com/${ORGANIZATION}/${repo}/issues?q=is:issue+created:${start_display}..${end_display}"
# ... etc

# Format metrics
current_issues_display=$(format_metric "$current_issues" "$current_issues_url")
opened_issues_display=$(format_metric "$opened_issues" "$opened_issues_url")
# ... etc

# Build table row
report_content="${report_content}
| $repo | $current_issues_display | $opened_issues_display | ... |"
```

## Benefits

### 1. Improved User Experience
- **One-Click Access**: Jump directly to relevant GitHub pages
- **No Manual Queries**: Pre-constructed search queries save time
- **Accurate Filtering**: Links include exact date ranges

### 2. Better Workflow
- **Quick Investigation**: Immediately see what changed
- **Reduced Friction**: No need to navigate manually through GitHub
- **Context Preservation**: Date ranges ensure you see the right items

### 3. Clean Design
- **Minimal Clutter**: Only 0 values remain as plain text
- **Progressive Enhancement**: Links for all activity items
- **Consistent Format**: Standard Markdown link syntax

## Use Cases

### Project Manager
"I see 7 PRs were merged in QuantEcon.jl this week. Let me click to see which ones..."
→ Clicks the `7` link → Taken to filtered PR list

### Developer
"15 issues were opened? I wonder if any affect my work..."
→ Clicks the `15` link → Reviews the list directly

### Team Lead
"Lots of commits in this repo. Let me see what changed..."
→ Clicks the commit count → Views commit history

## Testing

Test the feature using the included test script:

```bash
./test-hyperlinks.sh
```

This verifies:
- Number 0 displays as plain text
- Numbers > 0 display as hyperlinks
- URLs are correctly formatted
- Markdown syntax is valid

## Compatibility

- **GitHub**: Full support (native Markdown rendering)
- **GitLab**: Full support (native Markdown rendering)
- **Plain Text**: Links display with visible URLs
- **Email**: Depends on email client's Markdown support

## Future Enhancements

Potential improvements for future versions:

1. **Configurable Threshold**: Allow users to set when links appear (e.g., > 0, > 2, etc.)
2. **Link Customization**: Support custom URL formats or query parameters
3. **Additional Metrics**: Add links for other report sections
4. **Tooltip Support**: Add title attributes for hover previews

## Examples

### Before (Plain Numbers)
```markdown
| QuantEcon.jl | 38 | 7 | 3 | 7 | 3 | 3 |
```

### After (With Hyperlinks)
```markdown
| QuantEcon.jl | [38](https://...) | [7](https://...) | [3](https://...) | [7](https://...) | [3](https://...) | [3](https://...) |
```

### Rendered View
All numbers > 0 appear as clickable blue links (standard Markdown link styling) that take you directly to the filtered GitHub view. Only 0 values remain as plain text.
