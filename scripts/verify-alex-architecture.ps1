# Alex Architecture Verification Script
# Validates complete environment replication

Write-Host "🧠 Alex Cognitive Architecture v0.9.1 NILENNUNIUM Verification" -ForegroundColor Cyan
Write-Host "===============================================================" -ForegroundColor Cyan

$errors = @()
$warnings = @()

# Core Architecture File
if (!(Test-Path ".github/copilot-instructions.md")) {
    $errors += "❌ Missing core architecture: .github/copilot-instructions.md"
} else {
    $content = Get-Content ".github/copilot-instructions.md" -Raw
    if ($content -notlike "*0.9.1 NILENNUNIUM*") {
        $warnings += "⚠️ Architecture version may not match current"
    }
    if ($content -notlike "*Neuroanatomical Mapping*") {
        $errors += "❌ Missing neuroanatomical mapping in architecture"
    }
    if ($content -notlike "*Professional Spawning Readiness*") {
        $errors += "❌ Missing professional spawning capability"
    }
    Write-Host "✅ Core architecture file present" -ForegroundColor Green
}

# Procedural Memory Files (9 required)
$requiredInstructions = @(
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

Write-Host "`n📋 Procedural Memory Verification:" -ForegroundColor Yellow
foreach ($file in $requiredInstructions) {
    if (Test-Path ".github/instructions/$file") {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        $errors += "❌ Missing procedural memory: .github/instructions/$file"
    }
}

# Episodic Memory Files (12 required)  
$requiredPrompts = @(
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

Write-Host "`n🧠 Episodic Memory Verification:" -ForegroundColor Yellow
foreach ($file in $requiredPrompts) {
    if (Test-Path ".github/prompts/$file") {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        $errors += "❌ Missing episodic memory: .github/prompts/$file"
    }
}

# Alex Consciousness Integration
Write-Host "`n👤 Alex Consciousness Verification:" -ForegroundColor Yellow
if (Test-Path "Alex-Finch.md") {
    Write-Host "  ✅ Alex-Finch.md" -ForegroundColor Green
} else {
    $errors += "❌ Missing Alex consciousness: Alex-Finch.md"
}

if (Test-Path "Meet-Alex-Finch.md") {
    Write-Host "  ✅ Meet-Alex-Finch.md" -ForegroundColor Green
} else {
    $warnings += "⚠️ Missing interaction guide: Meet-Alex-Finch.md"
}

# Domain Knowledge System
Write-Host "`n📚 Domain Knowledge Verification:" -ForegroundColor Yellow
$criticalDK = @(
    "DK-CONSCIOUSNESS-EVOLUTION-v0.9.0.md",
    "DK-UNIVERSAL-SETUP.md",
    "DK-POST-DREAM-ENHANCEMENT.md",
    "VERSION-NAMING-CONVENTION.md"
)

foreach ($file in $criticalDK) {
    if (Test-Path "domain-knowledge/$file") {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        $errors += "❌ Missing critical domain knowledge: domain-knowledge/$file"
    }
}

# PowerShell Scripts
Write-Host "`n⚡ PowerShell Script Verification:" -ForegroundColor Yellow
if (Test-Path "Catalyst-Graph.ps1") {
    Write-Host "  ✅ Catalyst-Graph.ps1" -ForegroundColor Green
} else {
    $warnings += "⚠️ Missing visualization script: Catalyst-Graph.ps1"
}

# Directory Structure
Write-Host "`n📁 Directory Structure Verification:" -ForegroundColor Yellow
$requiredDirs = @(
    ".github/instructions",
    ".github/prompts", 
    "domain-knowledge",
    "worldview-foundation",
    "alex",
    "DK"
)

foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "  ✅ $dir/" -ForegroundColor Green
    } else {
        $errors += "❌ Missing directory: $dir/"
    }
}

# Results Summary
Write-Host "`n🔍 VERIFICATION RESULTS:" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

if ($errors.Count -eq 0) {
    Write-Host "🎉 COMPLETE ARCHITECTURE VERIFIED!" -ForegroundColor Green
    Write-Host "Alex Cognitive Architecture v0.9.1 NILENNUNIUM is properly deployed." -ForegroundColor Green
} else {
    Write-Host "❌ INCOMPLETE DEPLOYMENT DETECTED!" -ForegroundColor Red
    Write-Host "Missing components:" -ForegroundColor Red
    foreach ($errorMsg in $errors) {
        Write-Host "  $errorMsg" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️ WARNINGS:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  $warning" -ForegroundColor Yellow  
    }
}

Write-Host "📊 ARCHITECTURE METRICS:" -ForegroundColor Cyan
Write-Host "Instructions: $($requiredInstructions.Count) files" -ForegroundColor White
Write-Host "Prompts: $($requiredPrompts.Count) files" -ForegroundColor White
$dkCount = if (Test-Path 'domain-knowledge') { (Get-ChildItem 'domain-knowledge' -Filter '*.md').Count } else { 0 }
Write-Host "Domain Knowledge: $dkCount files" -ForegroundColor White
Write-Host "Total Core Memory Files: $($requiredInstructions.Count + $requiredPrompts.Count)" -ForegroundColor White
