#!/bin/bash
# Test script for external repositories feature

echo "=== External Repositories Feature Tests ==="
echo ""

# Test 1: Valid format
echo "Test 1: Valid format (executablebooks/sphinx-proof,executablebooks/sphinx-exercise)"
./generate-report.sh --token=dummy --track-external-repos="executablebooks/sphinx-proof,executablebooks/sphinx-exercise" 2>&1 | grep -A 2 "Validating external repositories"
echo ""

# Test 2: Invalid format (no slash)
echo "Test 2: Invalid format (invalid-format)"
./generate-report.sh --token=dummy --track-external-repos="invalid-format" 2>&1 | grep -A 2 "ERROR: Invalid"
echo ""

# Test 3: Mixed valid/invalid
echo "Test 3: Mixed valid/invalid (valid/repo,invalid,another/valid)"
./generate-report.sh --token=dummy --track-external-repos="valid/repo,invalid,another/valid" 2>&1 | grep -A 2 "ERROR: Invalid"
echo ""

# Test 4: Empty external repos (should work normally)
echo "Test 4: Empty external repos (should skip validation)"
./generate-report.sh --token=dummy 2>&1 | grep -E "(Validating external|Validating GitHub token)" | head -1
echo ""

# Test 5: Too many slashes
echo "Test 5: Too many slashes (org/repo/extra)"
./generate-report.sh --token=dummy --track-external-repos="org/repo/extra" 2>&1 | grep -A 2 "ERROR: Invalid"
echo ""

# Test 6: Single repo (valid)
echo "Test 6: Single repo (executablebooks/sphinx-proof)"
./generate-report.sh --token=dummy --track-external-repos="executablebooks/sphinx-proof" 2>&1 | grep -A 2 "Validating external repositories"
echo ""

echo "=== Tests Complete ==="
