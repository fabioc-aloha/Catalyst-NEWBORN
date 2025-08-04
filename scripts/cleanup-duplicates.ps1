# Alex Repository Cleanup Script
# Intelligent duplicate file detection and cleanup

Write-Host "🧹 Alex Repository Cleanup Script" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Function to check if a file is likely a duplicate based on patterns
function Test-IsDuplicateFile {
    param([string]$fileName, [array]$allFiles)
    
    # Get base patterns
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($fileName)
    $extension = [System.IO.Path]::GetExtension($fileName)
    
    # Check for common duplicate patterns
    $duplicatePatterns = @(
        # Version-like suffixes: file-v1.md, file-2.md, file-copy.md
        '-v\d+$', '-\d+$', '-copy$', '-backup$', '-old$', '-tmp$', '-temp$',
        # Date suffixes: file-20250804.md
        '-\d{8}$', '-\d{4}-\d{2}-\d{2}$',
        # Parenthetical duplicates: file (1).md, file (copy).md
        '\s*\(\d+\)$', '\s*\(copy\)$', '\s*\(backup\)$'
    )
    
    foreach ($pattern in $duplicatePatterns) {
        if ($baseName -match $pattern) {
            # Check if a "main" version exists
            $basePattern = $baseName -replace $pattern, ''
            $mainFile = "$basePattern$extension"
            if ($allFiles -contains $mainFile -and $mainFile -ne $fileName) {
                return $true
            }
        }
    }
    
    # Check for files with similar names (potential duplicates)
    $similarFiles = $allFiles | Where-Object { 
        $_ -ne $fileName -and 
        [System.IO.Path]::GetExtension($_) -eq $extension -and
        (Get-LevenshteinDistance $baseName ([System.IO.Path]::GetFileNameWithoutExtension($_))) -le 2
    }
    
    return $similarFiles.Count -gt 0
}

# Function to calculate string similarity (Levenshtein distance)
function Get-LevenshteinDistance {
    param([string]$s1, [string]$s2)
    
    if ($s1.Length -eq 0) { return $s2.Length }
    if ($s2.Length -eq 0) { return $s1.Length }
    
    $matrix = New-Object 'int[,]' ($s1.Length + 1), ($s2.Length + 1)
    
    for ($i = 0; $i -le $s1.Length; $i++) { $matrix[$i, 0] = $i }
    for ($j = 0; $j -le $s2.Length; $j++) { $matrix[0, $j] = $j }
    
    for ($i = 1; $i -le $s1.Length; $i++) {
        for ($j = 1; $j -le $s2.Length; $j++) {
            $cost = if ($s1[$i-1] -eq $s2[$j-1]) { 0 } else { 1 }
            $matrix[$i, $j] = [Math]::Min([Math]::Min($matrix[$i-1, $j] + 1, $matrix[$i, $j-1] + 1), $matrix[$i-1, $j-1] + $cost)
        }
    }
    
    return $matrix[$s1.Length, $s2.Length]
}

Write-Host "🔍 Scanning for duplicate and empty files..." -ForegroundColor Yellow

# Get all files in current directory
$allFiles = Get-ChildItem -Path . -File | Where-Object { $_.Extension -eq ".md" } | ForEach-Object { $_.Name }

$emptyFiles = @()
$duplicateFiles = @()
$suspiciousFiles = @()

foreach ($file in $allFiles) {
    $fileInfo = Get-Item $file
    
    # Check for empty files
    if ($fileInfo.Length -eq 0) {
        $emptyFiles += $file
        Write-Host "❌ Found empty file: $file" -ForegroundColor Red
    }
    # Check for potential duplicates
    elseif (Test-IsDuplicateFile $file $allFiles) {
        $duplicateFiles += $file
        Write-Host "⚠️  Potential duplicate: $file ($($fileInfo.Length) bytes)" -ForegroundColor Yellow
    }
}

if (-not $foundUnwanted) {
    Write-Host "✅ No unwanted duplicate files found!" -ForegroundColor Green
    exit 0
}

# Handle empty files
if ($emptyFiles.Count -gt 0) {
    Write-Host "`n🗑️  Removing $($emptyFiles.Count) empty duplicate files..." -ForegroundColor Magenta
    foreach ($file in $emptyFiles) {
        Remove-Item $file
        Write-Host "   Deleted: $file" -ForegroundColor DarkGray
    }
    Write-Host "✅ Empty duplicates removed!" -ForegroundColor Green
}

# Handle duplicates with content
if ($duplicateFiles.Count -gt 0) {
    Write-Host "`n⚠️  Found $($duplicateFiles.Count) duplicate files with content:" -ForegroundColor Yellow
    foreach ($file in $duplicateFiles) {
        Write-Host "   $file" -ForegroundColor Yellow
    }
    Write-Host "`n❗ Please review these files manually before deletion." -ForegroundColor Red
    Write-Host "   They may contain important content that should be merged." -ForegroundColor Red
}

Write-Host "`n🔒 Repository cleanup complete!" -ForegroundColor Cyan
