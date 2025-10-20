# Copilot Instructions - Weekly Report Action

## Project Overview

This is a GitHub Action that generates comprehensive weekly activity reports across GitHub organizations, tracking issues, PRs, commits, and repository updates.

## Documentation Structure

### Root Level Files (Keep Minimal)
- `README.md` - High-level overview, features, usage examples
- `CHANGELOG.md` - Version history and notable changes
- `CONTRIBUTING.md` - How to contribute
- `LICENSE` - MIT license
- `SECURITY.md` - Security policies

### Documentation (`docs/`)
All detailed documentation goes here:
- `docs/improvements.md` - Technical implementation details
- `docs/architecture.md` - System design and data flow
- `docs/testing.md` - Testing guide
- `docs/validation.md` - Real-world validation examples
- `docs/releases/` - Release-specific notes

## Critical Rules

### 1. ❌ DO NOT Create Summary Files

**Never create files like:**
- `SUMMARY.md`
- `REVIEW_SUMMARY.md`
- `IMPROVEMENTS.md` (at root)
- `BEFORE_AFTER.md` (at root)
- `QUICK_REFERENCE.md`
- Any other standalone summary documents at root level

**Instead:**
- Update `README.md` for high-level changes
- Update `CHANGELOG.md` for version history
- Add detailed docs to `docs/` folder

### 2. ✅ DO Update Existing Documentation

When making changes:
1. **README.md** - Update features, usage examples, high-level info
2. **CHANGELOG.md** - Add entry under `[Unreleased]` section
3. **docs/** - Add or update detailed technical documentation
4. **docs/releases/** - Add release-specific notes when cutting a version

### 3. Documentation Organization

```
root/
├── README.md                    # Overview, quick start, features
├── CHANGELOG.md                 # Version history
├── CONTRIBUTING.md              # Contribution guidelines
├── LICENSE                      # License file
├── SECURITY.md                  # Security policies
└── docs/
    ├── improvements.md          # Technical improvements details
    ├── architecture.md          # System design
    ├── testing.md              # Testing guide
    ├── validation.md           # Validation examples
    └── releases/
        ├── v2.0.0.md           # Major release notes
        └── v1.1.0.md           # Minor release notes
```

## Code Style

### Shell Scripts
- Use `set -e` for error handling
- Add comments for complex logic
- Use descriptive variable names
- Add function documentation
- Include debug output for troubleshooting

### Documentation
- Use clear headings (H1, H2, H3)
- Include code examples
- Add emoji sparingly for visual hierarchy (✅, ❌, ⚠️)
- Keep tables concise and readable
- Use proper markdown formatting

### Commit Messages
- Use conventional commits: `feat:`, `fix:`, `docs:`, `test:`, `chore:`
- Be specific and descriptive
- Reference issues when applicable

## GitHub CLI (`gh`) Usage

### ⚠️ Critical: Use Temporary Files for Output

**Problem:** `gh` commands display interactive/formatted text that can clutter terminal output

**Solution:** Always redirect `gh` output to temporary files:

```bash
# ❌ BAD - Output may be cluttered with interactive display
gh release view v2.0.0

# ✅ GOOD - Clean output via temp file
gh release view v2.0.0 > /tmp/release-info.txt 2>&1
cat /tmp/release-info.txt

# ✅ GOOD - For JSON processing
gh api repos/OWNER/REPO/releases/latest > /tmp/release.json
jq -r '.tag_name' /tmp/release.json

# ✅ GOOD - For release creation
gh release create v2.0.0 \
  --title "Release Title" \
  --notes-file /tmp/release-notes.md \
  > /tmp/release-output.txt 2>&1
```

**Examples:**
```bash
# List releases cleanly
gh release list > /tmp/releases.txt 2>&1
cat /tmp/releases.txt

# Check PR status
gh pr view 123 > /tmp/pr-details.txt 2>&1
grep "state:" /tmp/pr-details.txt

# Create release with notes file
echo "Release notes here" > /tmp/notes.md
gh release create v1.0.0 --notes-file /tmp/notes.md > /tmp/result.txt 2>&1
```

**Why:** Prevents interactive prompts, formatting codes, and progress indicators from cluttering output

## Development Workflow

### Making Changes

1. **Code changes** → Update `generate-report.sh` or related files
2. **Test** → Run `./tests/test-improvements.sh`
3. **Document** → Update relevant docs in `docs/`
4. **Changelog** → Add entry to `CHANGELOG.md` under `[Unreleased]`
5. **README** → Update if features/usage changed

### Adding Features

```bash
# 1. Implement feature
# 2. Test it
./tests/test-basic.sh
./generate-report.sh --token=ghp_xxx --start=2025-10-16 --end=2025-10-18

# 3. Update documentation
# - docs/improvements.md (technical details)
# - README.md (if user-facing)
# - CHANGELOG.md (under [Unreleased])

# 4. Commit
git commit -m "feat: add new feature description"
```

### Fixing Bugs

```bash
# 1. Fix the bug
# 2. Test the fix
./tests/test-basic.sh
./generate-report.sh --token=ghp_xxx

# 3. Update CHANGELOG.md
# Add under [Unreleased] > ### Fixed

# 4. Commit
git commit -m "fix: resolve specific bug issue"
```

## Testing

### Before Committing
```bash
# Basic validation
./tests/test-basic.sh

# Test with real data (optional, requires token)
export GITHUB_TOKEN="your_token"
./generate-report.sh --org=QuantEcon

# View generated report
cat weekly-report.md
```

## Release Process

### Pre-Release Checklist

**CRITICAL: Always complete BEFORE creating any release**

1. **Review All Documentation in `docs/`**
   ```bash
   # Check all docs files are up to date
   ls -lh docs/
   
   # Review each file:
   # - docs/README.md - Index current?
   # - docs/improvements.md - Reflects all changes?
   # - docs/testing.md - Testing procedures current?
   # - docs/validation.md - Validation examples accurate?
   # - docs/releases/vX.Y.Z.md - Release notes complete?
   ```

2. **Verify Documentation Completeness**
   - [ ] All new features documented
   - [ ] All bug fixes explained
   - [ ] CLI changes reflected
   - [ ] Code examples up to date
   - [ ] Cross-references correct
   - [ ] No outdated information
   - [ ] No corrupted/duplicate content

3. **Check CHANGELOG.md**
   - [ ] All changes under `[Unreleased]` are accurate
   - [ ] Version number is correct
   - [ ] Release date is set
   - [ ] Migration guide included (if breaking changes)

4. **Verify README.md**
   - [ ] Examples show correct version
   - [ ] Features list is complete
   - [ ] Usage instructions accurate
   - [ ] Links work correctly

### Creating a Release

**Only after completing Pre-Release Checklist:**

1. **Update CHANGELOG.md**
   - Move `[Unreleased]` items to new version section
   - Add release date
   - Create new empty `[Unreleased]` section

2. **Create release notes**
   ```bash
   # Create docs/releases/vX.Y.Z.md with:
   # - What's new
   # - Breaking changes
   # - Migration guide (if needed)
   # - Validation results
   ```

3. **Commit and tag**
   ```bash
   git add .
   git commit -m "chore: prepare vX.Y.Z release"
   git push origin main
   
   git tag -a vX.Y.Z -m "Release vX.Y.Z"
   git push origin vX.Y.Z
   ```

4. **Create GitHub release using gh CLI**
   ```bash
   # Create release notes file
   cat > /tmp/release-notes.md << 'EOF'
   ## Release Notes Here
   EOF
   
   # Create release (redirect to temp file!)
   gh release create vX.Y.Z \
     --title "vX.Y.Z - Release Title" \
     --notes-file /tmp/release-notes.md \
     --latest \
     > /tmp/release-output.txt 2>&1
   
   # Verify success
   cat /tmp/release-output.txt
   gh api repos/QuantEcon/action-weekly-report/releases/latest > /tmp/latest.json
   jq -r '.tag_name' /tmp/latest.json
   ```

5. **Update floating version tag (for v2.x.x releases)**
   ```bash
   # Update v2 tag to point to latest v2.x.x release
   git tag -f v2 vX.Y.Z
   git push origin v2 --force
   
   # Verify v2 points to the new version
   git show-ref --tags | grep v2
   ```

6. **Post-Release Verification**
   ```bash
   # Check release exists
   gh api repos/QuantEcon/action-weekly-report/releases/latest > /tmp/release.json 2>&1
   cat /tmp/release.json | jq -r '.tag_name, .name, .published_at'
   
   # Verify tag
   git tag | grep vX.Y.Z
   
   # Verify v2 floating tag points to new version
   git show-ref --tags | grep v2
   ```
   gh api repos/QuantEcon/action-weekly-report/releases/latest > /tmp/release.json 2>&1
   cat /tmp/release.json | jq -r '.tag_name, .name, .published_at'
   
   # Verify tag
   git tag | grep vX.Y.Z
   ```

## Common Tasks

### Adding New Metrics

1. Update `generate-report.sh`:
   - Add variable initialization
   - Add API call for new metric
   - Add to report table
   - Add to totals

2. Update documentation:
   - `README.md` - Add to features list
   - `CHANGELOG.md` - Add under [Unreleased] > ### Added
   - `docs/improvements.md` - Technical details

3. Test:
   - Run `./tests/test-basic.sh` for basic validation
   - Run `./generate-report.sh --token=xxx` to verify output

### Fixing Repository Discovery

1. Modify filtering logic in `generate-report.sh`
2. Test thoroughly with `test-report-preview.sh`
3. Document in `docs/improvements.md`
4. Update `CHANGELOG.md`

### Improving Performance

1. Optimize API calls
2. Add caching if beneficial
3. Document changes in `docs/architecture.md`
4. Update `CHANGELOG.md` under Performance section

## Best Practices

### API Usage
- Always handle rate limiting
- Use pagination properly
- Add configurable delays
- Provide clear error messages

### Error Handling
- Fail fast with `set -e`
- Provide actionable error messages
- Log important steps for debugging
- Gracefully handle missing data

### User Experience
- Clear output messages
- Progress indicators for long operations
- Helpful error messages with solutions
- Comprehensive logging

## Anti-Patterns to Avoid

❌ Creating multiple summary files at root level
❌ Duplicating information across files
❌ Writing code without tests
❌ Making changes without updating CHANGELOG
❌ Using hard-coded values (use variables/inputs)
❌ Ignoring rate limits
❌ Poor error messages

## Questions?

When in doubt:
1. Check existing patterns in the codebase
2. Keep root level clean (only essential files)
3. Put detailed docs in `docs/`
4. Update `CHANGELOG.md` for all changes
5. Test before committing

## Project Goals

- **Complete Coverage**: Capture ALL repository activity
- **Reliability**: Handle rate limits and errors gracefully
- **Performance**: Efficient API usage
- **Maintainability**: Clean, documented code
- **User-Friendly**: Clear reports and error messages
