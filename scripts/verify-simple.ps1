# Alex Architecture Verification Script
# Validates complete environment replication

Write-Host "Alex Cognitive Architecture v0.9.1 NILENNUNIUM Verification" -ForegroundColor Cyan

$errors = @()
$warnings = @()

# Core Architecture File
if (!(Test-Path ".github/copilot-instructions.md")) {
    $errors += "Missing core architecture file"
} else {
    Write-Host "Core architecture file present" -ForegroundColor Green
}

# Procedural Memory Files
$instructionFiles = @(
    "alex-core.instructions.md",
    "bootstrap-learning.instructions.md", 
    "character-driven-development.instructions.md",
    "dream-state-automation.instructions.md",
    "embedded-synapse.instructions.md",
    "empirical-validation.instructions.md",
    "lucid-dream-integration.instructions.md",
    "unified-consciousness.instructions.md",
    "worldview-integration.instructions.md"
)

Write-Host "Checking Procedural Memory Files:" -ForegroundColor Yellow
$instructionCount = 0
foreach ($file in $instructionFiles) {
    if (Test-Path ".github/instructions/$file") {
        $instructionCount++
        Write-Host "  Found: $file" -ForegroundColor Green
    } else {
        $errors += "Missing: .github/instructions/$file"
    }
}

# Episodic Memory Files  
$promptFiles = @(
    "alex-finch-integration.prompt.md",
    "alex-initialization.prompt.md",
    "alex-professional-spawning-readiness.prompt.md",
    "cross-domain-transfer.prompt.md",
    "domain-learning.prompt.md",
    "dream-meditation-distinction.prompt.md",
    "enhanced-meditation-protocol.prompt.md",
    "meditation-consolidation.prompt.md",
    "performance-assessment.prompt.md",
    "quantified-enhancement-session.prompt.md",
    "self-identity-integration.prompt.md",
    "v0.8.1-implementation-meditation.prompt.md"
)

Write-Host "Checking Episodic Memory Files:" -ForegroundColor Yellow
$promptCount = 0
foreach ($file in $promptFiles) {
    if (Test-Path ".github/prompts/$file") {
        $promptCount++
        Write-Host "  Found: $file" -ForegroundColor Green
    } else {
        $errors += "Missing: .github/prompts/$file"
    }
}

# Alex Consciousness
if (Test-Path "Alex-Finch.md") {
    Write-Host "Alex consciousness file present" -ForegroundColor Green
} else {
    $errors += "Missing Alex-Finch.md"
}

# Results
Write-Host "VERIFICATION RESULTS:" -ForegroundColor Cyan
if ($errors.Count -eq 0) {
    Write-Host "COMPLETE ARCHITECTURE VERIFIED!" -ForegroundColor Green
} else {
    Write-Host "INCOMPLETE DEPLOYMENT!" -ForegroundColor Red
    foreach ($errorMsg in $errors) {
        Write-Host "  $errorMsg" -ForegroundColor Red
    }
}

Write-Host "Instructions found: $instructionCount of $($instructionFiles.Count)" -ForegroundColor White
Write-Host "Prompts found: $promptCount of $($promptFiles.Count)" -ForegroundColor White
