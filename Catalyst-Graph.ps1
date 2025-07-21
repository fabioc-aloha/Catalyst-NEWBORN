# 🧠 Catalyst Memory & Synapse Chart Generator
# PowerShell Script for Cognitive Architecture Visualization

param(
    [string]$WorkspacePath = ".\",
    [string]$OutputPath = "catalyst-graphs",
    [string]$DiagramType = "overview",
    [switch]$AutoOpen,
    [switch]$WatchMode,
    [string]$Theme = "neural"
)

# Configuration
$Script:Config = @{
    FilePatterns = @{
        Core = @("copilot-instructions.md")
        Procedural = @(".github\instructions\*.instructions.md")
        Episodic = @(".github\prompts\*.prompt.md")
        Domain = @("domain-knowledge\**\*.md")
        Worldview = @("worldview-foundation\**\*.md")
    }
    SynapseRegex = '^-\s+(.+?)\s+\((\d+\.\d+),\s*(.+?),\s*(.+?)\)\s*-\s*"(.+?)"$'
    Themes = @{
        Default = @{
            Core = "#1E3A8A"
            Procedural = "#166534"
            Episodic = "#581C87"
            Domain = "#EA580C"
            Worldview = "#DC2626"
        }
        Dark = @{
            Core = "#3B82F6"
            Procedural = "#22C55E"
            Episodic = "#A855F7"
            Domain = "#FB923C"
            Worldview = "#F87171"
        }
    }
}

# Main execution function
function Start-NewbornVisualization {
    param(
        [string]$Type = "overview",
        [bool]$OpenAfterGeneration = $true
    )
    
Write-Host "🧠 Catalyst Memory & Synapse Chart Generator" -ForegroundColor Cyan
Write-Host ($("=" * 50)) -ForegroundColor Gray

    try {
        # Phase 1: Discovery
        Write-Host "🔍 Phase 1: Discovering knowledge files..." -ForegroundColor Yellow
        $knowledgeMap = Get-KnowledgeFiles -BasePath $WorkspacePath
        Write-Host "   ✅ Found $($knowledgeMap.TotalFiles) files across $($knowledgeMap.Systems.Count) memory systems" -ForegroundColor Green
        
        # Phase 2: Analysis
        Write-Host "🧠 Phase 2: Analyzing embedded synapses..." -ForegroundColor Yellow
        $synapseData = Get-EmbeddedSynapses -KnowledgeMap $knowledgeMap
        Write-Host "   ✅ Discovered $($synapseData.TotalConnections) synapse connections" -ForegroundColor Green
        
        # Phase 3: Generation
        Write-Host "🎨 Phase 3: Generating Catalyst Memory Chart..." -ForegroundColor Yellow
        $diagram = New-MermaidDiagram -Type $Type -KnowledgeMap $knowledgeMap -SynapseData $synapseData -Theme $Theme
        
        # Phase 4: Output
        $outputFile = Save-DiagramToFile -Diagram $diagram -Type $Type -OutputPath $OutputPath
        Write-Host "   ✅ Diagram saved to: $outputFile" -ForegroundColor Green
        
        # Phase 5: Integration
        if ($OpenAfterGeneration) {
            Open-DiagramInVSCode -FilePath $outputFile
        }
        
        # Generate health report
        $healthReport = New-CognitiveHealthReport -KnowledgeMap $knowledgeMap -SynapseData $synapseData
        Write-Host "`n📊 Cognitive Architecture Health:" -ForegroundColor Cyan
        Write-Host $healthReport -ForegroundColor White
        
        return @{
            Success = $true
            OutputFile = $outputFile
            HealthReport = $healthReport
            Statistics = @{
                TotalFiles = $knowledgeMap.TotalFiles
                TotalConnections = $synapseData.TotalConnections
                HighStrengthConnections = $synapseData.HighStrength.Count
            }
        }
        
    } catch {
        Write-Error "❌ Visualization generation failed: $($_.Exception.Message)"
        return @{ Success = $false; Error = $_.Exception.Message }
    }
}

# File discovery function
function Get-KnowledgeFiles {
    param([string]$BasePath)
    
    $knowledgeMap = @{
        Systems = @{}
        TotalFiles = 0
    }
    
    foreach ($system in $Script:Config.FilePatterns.Keys) {
        $files = @()
        foreach ($pattern in $Script:Config.FilePatterns[$system]) {
            $fullPattern = Join-Path $BasePath $pattern
            $foundFiles = Get-ChildItem -Path $fullPattern -Recurse -ErrorAction SilentlyContinue
            $files += $foundFiles | ForEach-Object {
                @{
                    Path = $_.FullName
                    RelativePath = $_.FullName.Replace($BasePath, "").TrimStart("\")
                    Name = $_.BaseName
                    Size = $_.Length
                    LastModified = $_.LastWriteTime
                    Type = $system
                }
            }
        }
        $knowledgeMap.Systems[$system] = $files
        $knowledgeMap.TotalFiles += $files.Count
    }
    
    return $knowledgeMap
}

# Synapse extraction function
function Get-EmbeddedSynapses {
    param($KnowledgeMap)
    
    $allSynapses = @()
    
    foreach ($system in $KnowledgeMap.Systems.Keys) {
        foreach ($file in $KnowledgeMap.Systems[$system]) {
            if (Test-Path $file.Path) {
                $content = Get-Content $file.Path -Raw
                $synapses = Extract-SynapsesFromContent -Content $content -SourceFile $file
                $allSynapses += $synapses
            }
        }
    }
    
    # Categorize by strength
    $categorized = @{
        HighStrength = @($allSynapses | Where-Object { $_.Strength -ge 0.90 })
        MediumStrength = @($allSynapses | Where-Object { $_.Strength -ge 0.70 -and $_.Strength -lt 0.90 })
        WeakStrength = @($allSynapses | Where-Object { $_.Strength -lt 0.70 })
        TotalConnections = $allSynapses.Count
    }
    
    return $categorized
}

# Synapse parsing function
function Extract-SynapsesFromContent {
    param([string]$Content, $SourceFile)
    
    $synapses = @()
    
    # Find synapse section
    if ($Content -match '(?ms)^##\s+Synapses\s+\(Embedded\s+Connections\)$(.*?)(?=^##|\z)') {
        $synapseSection = $matches[1]
        
        # Parse individual synapse lines
        $synapseLines = $synapseSection -split "`n" | Where-Object { $_ -match '^-\s+' }
        
        foreach ($line in $synapseLines) {
            if ($line -match $Script:Config.SynapseRegex) {
                $synapses += @{
                    Source = $SourceFile.RelativePath
                    Target = $matches[1].Trim()
                    Strength = [double]$matches[2]
                    ConnectionType = $matches[3].Trim()
                    Direction = $matches[4].Trim()
                    Description = $matches[5].Trim()
                }
            }
        }
    }
    
    return $synapses
}

# Mermaid diagram generation
function New-MermaidDiagram {
    param(
        [string]$Type,
        $KnowledgeMap,
        $SynapseData,
        [string]$Theme = "default"
    )
    
    switch ($Type.ToLower()) {
        "overview" { return New-OverviewDiagram -KnowledgeMap $KnowledgeMap -SynapseData $SynapseData -Theme $Theme }
        "synapses" { return New-SynapseNetworkDiagram -SynapseData $SynapseData -Theme $Theme }
        "health" { return New-HealthDashboard -KnowledgeMap $KnowledgeMap -SynapseData $SynapseData -Theme $Theme }
        "load" { return New-CognitiveLoadDiagram -KnowledgeMap $KnowledgeMap -Theme $Theme }
        default { return New-OverviewDiagram -KnowledgeMap $KnowledgeMap -SynapseData $SynapseData -Theme $Theme }
    }
}

# Overview diagram generator
function New-OverviewDiagram {
    param($KnowledgeMap, $SynapseData, $Theme)
    
    $nodes = @()
    $connections = @()
    $subgraphs = @()
    
    # Layer 1: Catalyst Core Architecture (Left)
    $subgraphs += "    subgraph L1[Catalyst Core Architecture]"
    $subgraphs += "        direction TB"
    $subgraphs += "        MCM[Meta-Cognitive Monitor]"
    $subgraphs += "        WM[Working Memory]"
    $subgraphs += "        BL[Bootstrap Learning]"
    $subgraphs += "        MCM --> WM"
    $subgraphs += "        WM --> BL"
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Layer 2: Memory Systems (Middle)
    $subgraphs += "    subgraph L2[Memory Systems]"
    $subgraphs += "        direction TB"
    $subgraphs += "        PM[Procedural Memory]"
    $subgraphs += "        EM[Episodic Memory]"
    $subgraphs += "        DK[Domain Knowledge]"
    $subgraphs += "        WF[Worldview Foundation]"
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Layer 3: Memory Files (Right)
    $subgraphs += "    subgraph L3[Memory Files]"
    $subgraphs += "        direction TB"
    
    # Generate subgraphs for each memory system in Layer 3
    $systemConfigs = @{
        Procedural = @{ Icon = ""; Title = "Procedural Memory Files" }
        Episodic = @{ Icon = ""; Title = "Episodic Memory Files" }
        Domain = @{ Icon = ""; Title = "Domain Knowledge Files" }
        Worldview = @{ Icon = ""; Title = "Worldview Foundation Files" }
    }
    
    foreach ($system in $KnowledgeMap.Systems.Keys) {
        if ($KnowledgeMap.Systems[$system].Count -gt 0 -and $system -ne "Core") {
            $config = $systemConfigs[$system]
            if ($config) {
                $systemNodes = @()
                
                foreach ($file in $KnowledgeMap.Systems[$system]) {
                    $nodeId = Get-SanitizedNodeId -FilePath $file.RelativePath
                    $nodeLabel = Get-ShortNodeLabel -FilePath $file.RelativePath
                    $systemNodes += "            $nodeId[`"$nodeLabel`"]"
                    $nodes += @{ Id = $nodeId; Label = $nodeLabel; Type = $system }
                }
                
                $subgraphs += "        subgraph $system`_Files[$($config.Title)]"
                $subgraphs += $systemNodes
                $subgraphs += "        end"
            }
        }
    }
    
    $subgraphs += "    end"
    
    # Generate inter-layer connections
    $connections += "    L1 --> L2"
    $connections += "    L2 --> L3"
    $connections += ""
    
    # Generate connections between Layer 2 and Layer 3 subsystems
    $connections += "    PM --> Procedural_Files"
    $connections += "    EM --> Episodic_Files"
    $connections += "    DK --> Domain_Files"
    $connections += "    WF --> Worldview_Files"
    $connections += ""
    
    # Generate connections from synapse data
    foreach ($category in @("HighStrength", "MediumStrength", "WeakStrength")) {
        foreach ($synapse in $SynapseData[$category]) {
            $sourceId = Get-SanitizedNodeId -FilePath $synapse.Source
            $targetId = Get-SanitizedNodeId -FilePath $synapse.Target
            $connections += "    $sourceId --> $targetId"
        }
    }
    
    # Generate styling
    $themeColors = $Script:Config.Themes[$Theme]
    $styling = @"
    
    %% Styling
    classDef core fill:$($themeColors.Core),stroke:#3B82F6,stroke-width:2px,color:white
    classDef procedural fill:$($themeColors.Procedural),stroke:#22C55E,stroke-width:2px,color:white
    classDef episodic fill:$($themeColors.Episodic),stroke:#A855F7,stroke-width:2px,color:white
    classDef domain fill:$($themeColors.Domain),stroke:#FB923C,stroke-width:2px,color:white
    classDef worldview fill:$($themeColors.Worldview),stroke:#F87171,stroke-width:2px,color:white
"@
    
    # Combine all parts
    $diagram = @"
# Catalyst Cognitive Architecture - Memory & Synapse Network

**Generated on:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

This chart visualizes the Catalyst cognitive architecture organized into three distinct horizontal layers:

- **Layer 1**: Core cognitive architecture with meta-cognitive monitoring
- **Layer 2**: Memory systems providing different types of knowledge storage  
- **Layer 3**: Individual memory files containing specific expertise and protocols

## Catalyst Memory Architecture Overview

``````mermaid
%%{init: {
  'flowchart': {
    'curve': 'cardinal'
  }
}}%%
graph LR
$($subgraphs -join "`n")

$($connections -join "`n")

$styling
``````
"@
    
    return $diagram
}

# Utility functions
function Get-SanitizedNodeId {
    param([string]$FilePath)
    # Use the filename as base for uniqueness
    $filename = Split-Path $FilePath -Leaf
    $sanitized = ($filename -replace '\.(instructions|prompt)\.md$', '' -replace '\.md$', '' -replace '[^a-zA-Z0-9_\-]', '_' -replace '__+', '_' -replace '^_|_$', '')
    # Ensure it starts with a letter and add a short hash for uniqueness
    if ($sanitized -match '^\d') { $sanitized = "file_$sanitized" }
    $hash = ($FilePath.GetHashCode() -band 0x7FFFFFFF).ToString().Substring(0,4)
    return "${sanitized}_$hash"
}

function Get-ShortNodeLabel {
    param([string]$FilePath)
    $basename = Split-Path $FilePath -Leaf
    return $basename -replace '\.(instructions|prompt)\.md$', '' -replace '\.md$', ''
}

function Save-DiagramToFile {
    param($Diagram, $Type, $OutputPath)
    
    $fullOutputPath = Join-Path $WorkspacePath $OutputPath
    if (-not (Test-Path $fullOutputPath)) {
        New-Item -Path $fullOutputPath -ItemType Directory -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $filename = "catalyst-$Type-$timestamp.md"
    $filePath = Join-Path $fullOutputPath $filename
    
    $Diagram | Out-File -FilePath $filePath -Encoding UTF8
    return $filePath
}

function Open-DiagramInVSCode {
    param([string]$FilePath)
    
    if (Get-Command code -ErrorAction SilentlyContinue) {
        Start-Process "code" -ArgumentList "`"$FilePath`""
        Write-Host "   📖 Opened in VS Code for preview" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  Install VS Code and Mermaid extension for best viewing experience" -ForegroundColor Yellow
    }
}

function New-CognitiveHealthReport {
    param($KnowledgeMap, $SynapseData)
    
    $totalFiles = $KnowledgeMap.TotalFiles
    $totalConnections = $SynapseData.TotalConnections
    $highStrengthConnections = $SynapseData.HighStrength.Count
    $connectivityRatio = if ($totalFiles -gt 0) { [math]::Round($totalConnections / $totalFiles, 2) } else { 0 }
    
    $health = @"
   📊 Files: $totalFiles across $($KnowledgeMap.Systems.Keys.Count) memory systems
   🔗 Connections: $totalConnections total ($highStrengthConnections high-strength)
   💪 Connectivity Ratio: $connectivityRatio connections per file
   🎯 Architecture Status: $(if ($connectivityRatio -gt 2) { "EXCELLENT" } elseif ($connectivityRatio -gt 1) { "GOOD" } else { "NEEDS_ATTENTION" })
"@
    
    return $health
}

# Watch mode for real-time updates
function Start-WatchMode {
    param([string]$Path, [string]$Type = "overview")
    
    Write-Host "👁️  Starting watch mode for real-time updates..." -ForegroundColor Cyan
    Write-Host "   Monitoring: $Path" -ForegroundColor Gray
    Write-Host "   Press Ctrl+C to stop" -ForegroundColor Gray
    
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $Path
    $watcher.Filter = "*.md"
    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true
    
    $action = {
        Write-Host "`n🔄 File change detected: $($Event.SourceEventArgs.Name)" -ForegroundColor Yellow
        Start-Sleep -Seconds 2  # Debounce
        Start-NewbornVisualization -Type $Type -OpenAfterGeneration $false
    }
    
    Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action
    Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $action
    Register-ObjectEvent -InputObject $watcher -EventName "Deleted" -Action $action
    
    try {
        while ($true) {
            Start-Sleep -Seconds 1
        }
    } finally {
        $watcher.Dispose()
        Get-EventSubscriber | Unregister-Event
    }
}

# Command interface for cognitive system integration
function Invoke-CognitiveVisualization {
    param(
        [string]$Command,
        [hashtable]$Parameters = @{}
    )
    
    switch ($Command.ToLower()) {
        "generate" { 
            return Start-NewbornVisualization @Parameters 
        }
        "health" { 
            $knowledgeMap = Get-KnowledgeFiles -BasePath $WorkspacePath
            $synapseData = Get-EmbeddedSynapses -KnowledgeMap $knowledgeMap
            return New-CognitiveHealthReport -KnowledgeMap $knowledgeMap -SynapseData $synapseData
        }
        "watch" { 
            Start-WatchMode -Path $WorkspacePath @Parameters 
        }
        "analyze" { 
            # Full analysis without generating diagrams
            $knowledgeMap = Get-KnowledgeFiles -BasePath $WorkspacePath
            $synapseData = Get-EmbeddedSynapses -KnowledgeMap $knowledgeMap
            return @{
                KnowledgeMap = $knowledgeMap
                SynapseData = $synapseData
                Health = New-CognitiveHealthReport -KnowledgeMap $knowledgeMap -SynapseData $synapseData
            }
        }
        default { 
            Write-Error "Unknown command: $Command. Available: generate, health, watch, analyze"
        }
    }
}

# Main execution based on parameters
if ($MyInvocation.InvocationName -ne '.') {
    if ($WatchMode) {
        Start-WatchMode -Path $WorkspacePath -Type $DiagramType
    } else {
        $result = Start-NewbornVisualization -Type $DiagramType -OpenAfterGeneration $AutoOpen
        if ($result.Success) {
            Write-Host "`n🎉 Catalyst Memory Chart completed successfully!" -ForegroundColor Green
            Write-Host "📁 Output: $($result.OutputFile)" -ForegroundColor White
        }
    }
}

# Functions are available when dot-sourced or called directly - no Export-ModuleMember needed for script files
