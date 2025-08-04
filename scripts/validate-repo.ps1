# Alex Repository Validation Script
# Run this before commits to prevent unwanted files

Write-Host "🛡️  Alex Repository Validation" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

# Check for unwanted patterns in staged files
$stagedFiles = git diff --cached --name-only

$unwantedPatterns = @(
    "SETUP-.*-ALEX.*\.md$",
    "SETUP-ALEX\.md$",
    "SETUP-COMPLETE.*\.md$", 
    "SETUP-DREAM.*\.md$",
    "SETUP-MINIMUM.*\.md$",
    "SETUP-SIMPLIFIED.*\.md$",
    "SEQUENTIAL-.*\.md$",
    ".*-REPLICATION\.md$"
)

$officialFiles = @(
    "SETUP-0-INSTALL-ALEX.md",
    "SETUP-1-FOUNDATION.md",
    "SETUP-2-ENHANCED-COGNITIVE.md", 
    "SETUP-3-ADVANCED-AUTOMATION.md"
)

$foundIssues = $false

foreach ($file in $stagedFiles) {
    # Skip if it's an official file
    if ($officialFiles -contains $file) {
        continue
    }
    
    foreach ($pattern in $unwantedPatterns) {
        if ($file -match $pattern) {
            Write-Host "❌ BLOCKED: Attempted to stage unwanted file: $file" -ForegroundColor Red
            $foundIssues = $true
            break
        }
    }
}

if ($foundIssues) {
    Write-Host "`n🚫 Commit blocked! Please remove unwanted files before committing." -ForegroundColor Red
    Write-Host "   Run: .\scripts\cleanup-duplicates.ps1 to clean up automatically" -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "✅ All staged files are valid!" -ForegroundColor Green
    exit 0
}
