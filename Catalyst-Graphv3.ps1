# 🧠 Catalyst Memory & Synapse Chart Generator v3.0
# PowerShell Script for Advanced Cognitive Architecture Visualization with Revolutionary 4-Layer Architecture

# 🚀 NEW in v3.0 - Major Architecture Evolution
# - Revolutionary 4-layer hierarchical framework (Layer 1: Meta-Cognitive Foundation → Layer 4: Implementation Files)
# - Specialized cognitive pathways with dotted-line meta-cognitive relationships
# - Enhanced PowerShell integration via Scripts system (SC) for .ps1 files
# - Architecture Documentation system (AR) for identity profiles and system docs
# - Advanced Mermaid configuration with improved spacing and cardinal curves
# - Enhanced color palette with 5-tier age-based file coding system
# - Weight-proportional connection styling (1px-6px) for synapse strength visualization

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
        Scripts = @("scripts\*.ps1")
        Architecture = @("*.md", "alex\*.md")
    }
    SynapseRegex = '^-\s+(.+?)\s+\((\d+\.\d+),\s*(.+?),\s*(.+?)\)\s*-\s*"(.+?)"$'
    Themes = @{
        Default = @{
            Core = "#1E3A8A"
            Procedural = "#166534"
            Episodic = "#581C87"
            Domain = "#EA580C"
            Worldview = "#DC2626"
            Scripts = "#7C3AED"
            Architecture = "#059669"
        }
        Dark = @{
            Core = "#3B82F6"
            Procedural = "#22C55E"
            Episodic = "#A855F7"
            Domain = "#FB923C"
            Worldview = "#F87171"
            Scripts = "#A855F7"
            Architecture = "#10B981"
        }
    }
}

# Main execution function
function Start-NewbornVisualization {
    param(
        [string]$Type = "overview",
        [bool]$OpenAfterGeneration = $true
    )
    
Write-Host "🧠 Catalyst Memory & Synapse Chart Generator v3 - 4-Layer Architecture" -ForegroundColor Cyan
Write-Host ($("=" * 60)) -ForegroundColor Gray

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
        Write-Host "🎨 Phase 3: Generating Advanced 4-Layer Catalyst Memory Chart..." -ForegroundColor Yellow
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

# Enhanced Overview diagram generator with 4-layer architecture
function New-OverviewDiagram {
    param($KnowledgeMap, $SynapseData, $Theme)
    
    $nodes = @()
    $connections = @()
    $subgraphs = @()
    
    # Calculate file ages and assign colors
    $now = Get-Date
    $allFiles = @()
    foreach ($system in $KnowledgeMap.Systems.Keys) {
        foreach ($file in $KnowledgeMap.Systems[$system]) {
            $ageInDays = ($now - $file.LastModified).Days
            $colorCategory = if ($ageInDays -le 1) { "VeryNew" }
                            elseif ($ageInDays -le 7) { "New" } 
                            elseif ($ageInDays -le 30) { "Recent" }
                            elseif ($ageInDays -le 90) { "Older" }
                            else { "Legacy" }
            
            $allFiles += [PSCustomObject]@{
                File = $file
                Age = $ageInDays
                ColorCategory = $colorCategory
                System = $system
            }
        }
    }
    
    # Sort files by creation date (newest first) for stack ranking
    $rankedFiles = $allFiles | Sort-Object { $_.File.LastModified } -Descending
    for ($i = 0; $i -lt $rankedFiles.Count; $i++) {
        $rankedFiles[$i] | Add-Member -MemberType NoteProperty -Name "Rank" -Value ($i + 1)
    }
    
    # Generate four-layer architecture
    
    # Layer 1: Meta-Cognitive Foundation (Top)
    $subgraphs += "    subgraph L1[""🎯 Meta-Cognitive Foundation""]"
    $subgraphs += "        direction LR"
    $subgraphs += "        NEWBORN[""🧠 NEWBORN Core""]"
    $subgraphs += "        BOOTSTRAP[""🌱 Bootstrap Learning""]"
    $subgraphs += "        AWARENESS[""👁️ Meta-Cognitive Awareness""]"
    $subgraphs += "        ETHICS[""⚖️ Worldview Integration""]"
    $subgraphs += "        NEWBORN --> BOOTSTRAP"
    $subgraphs += "        NEWBORN --> AWARENESS"
    $subgraphs += "        NEWBORN --> ETHICS"
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Layer 2: Cognitive Architecture (Second)
    $subgraphs += "    subgraph L2[""🏗️ Cognitive Architecture""]"
    $subgraphs += "        direction LR"
    $subgraphs += "        WM[""💭 Working Memory""]"
    $subgraphs += "        SYNAPSE[""🕸️ Synapse Network""]"
    $subgraphs += "        CONSOLIDATION[""🧘‍♂️ Memory Consolidation""]"
    $subgraphs += "        AUTOMATION[""🌙 Dream Automation""]"
    $subgraphs += "        WM --> SYNAPSE"
    $subgraphs += "        SYNAPSE --> CONSOLIDATION"
    $subgraphs += "        CONSOLIDATION --> AUTOMATION"
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Layer 3: Memory Systems (Third)
    $subgraphs += "    subgraph L3[""⚙️ Memory Systems""]"
    $subgraphs += "        direction LR"
    $subgraphs += "        PM[""⚙️ Procedural Memory""]"
    $subgraphs += "        EM[""📚 Episodic Memory""]"
    if ($KnowledgeMap.Systems["Domain"].Count -gt 0) {
        $subgraphs += "        DK[""🎓 Domain Knowledge""]"
    }
    if ($KnowledgeMap.Systems["Worldview"].Count -gt 0) {
        $subgraphs += "        WF[""🌍 Worldview Foundation""]"
    }
    if ($KnowledgeMap.Systems["Scripts"].Count -gt 0) {
        $subgraphs += "        SC[""🔧 Scripts & Automation""]"
    }
    if ($KnowledgeMap.Systems["Architecture"].Count -gt 0) {
        $subgraphs += "        AR[""📋 Architecture Documentation""]"
    }
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Layer 4: Individual Memory Files (Bottom)  
    $subgraphs += "    subgraph L4[""📄 Memory Files & Components""]"
    $subgraphs += "        direction LR"
    
    # Generate subgraphs for each memory system in Layer 4
    $systemConfigs = @{
        Procedural = @{ Icon = "⚙️"; Title = "Procedural Memory Files"; Color = "#166534" }
        Episodic = @{ Icon = "📚"; Title = "Episodic Memory Files"; Color = "#581C87" }
        Domain = @{ Icon = "🎓"; Title = "Domain Knowledge Files"; Color = "#EA580C" }
        Worldview = @{ Icon = "🌍"; Title = "Worldview Foundation Files"; Color = "#DC2626" }
        Scripts = @{ Icon = "🔧"; Title = "Scripts & Automation"; Color = "#7C3AED" }
        Architecture = @{ Icon = "📋"; Title = "Architecture Documentation"; Color = "#059669" }
    }
    
    foreach ($system in @("Procedural", "Episodic", "Domain", "Worldview", "Scripts", "Architecture")) {
        if ($KnowledgeMap.Systems.ContainsKey($system) -and $KnowledgeMap.Systems[$system].Count -gt 0) {
            $config = $systemConfigs[$system]
            $systemFiles = $rankedFiles | Where-Object { $_.System -eq $system }
            
            if ($systemFiles.Count -gt 0) {
                $subgraphs += "        subgraph $system" + "_Files[""$($config.Icon) $($config.Title)""]"
                
                foreach ($rankedFile in $systemFiles) {
                    $file = $rankedFile.File
                    $nodeId = Get-SanitizedNodeId -FilePath $file.RelativePath
                    $nodeLabel = Get-EnhancedNodeLabel -FilePath $file.RelativePath -Rank $rankedFile.Rank
                    
                    # Color based on age with enhanced distinction
                    $colorCode = switch ($rankedFile.ColorCategory) {
                        "VeryNew" { "#10B981" }  # Emerald green
                        "New" { "#3B82F6" }      # Blue
                        "Recent" { "#8B5CF6" }   # Purple
                        "Older" { "#F59E0B" }    # Amber
                        "Legacy" { "#EF4444" }   # Red
                    }
                    
                    $subgraphs += "            $nodeId[""$nodeLabel""]"
                    $subgraphs += "            style $nodeId fill:$colorCode,stroke:#374151,stroke-width:2px,color:white"
                }
                
                $subgraphs += "        end"
                $subgraphs += ""
            }
        }
    }
    
    $subgraphs += "    end"
    $subgraphs += ""
    
    # Generate inter-layer connections
    $connections += "    %% Inter-layer connections"
    $connections += "    L1 --> L2"
    $connections += "    L2 --> L3"
    $connections += "    L3 --> L4"
    $connections += ""
    
    # Generate connections between Layer 3 systems and Layer 4 file groups
    $connections += "    %% System to file group connections"
    if ($KnowledgeMap.Systems["Procedural"].Count -gt 0) {
        $connections += "    PM --> Procedural_Files"
    }
    if ($KnowledgeMap.Systems["Episodic"].Count -gt 0) {
        $connections += "    EM --> Episodic_Files"  
    }
    if ($KnowledgeMap.Systems["Domain"].Count -gt 0) {
        $connections += "    DK --> Domain_Files"
    }
    if ($KnowledgeMap.Systems["Worldview"].Count -gt 0) {
        $connections += "    WF --> Worldview_Files"
    }
    if ($KnowledgeMap.Systems["Scripts"].Count -gt 0) {
        $connections += "    SC --> Scripts_Files"
    }
    if ($KnowledgeMap.Systems["Architecture"].Count -gt 0) {
        $connections += "    AR --> Architecture_Files"
    }
    $connections += ""
    
    # Generate specialized inter-layer connections
    $connections += "    %% Specialized cognitive pathways"
    $connections += "    SYNAPSE -.-> PM"
    $connections += "    SYNAPSE -.-> EM"
    $connections += "    CONSOLIDATION -.-> DK"
    $connections += "    AUTOMATION -.-> SC"
    $connections += "    AWARENESS -.-> AR"
    $connections += ""
    
    # Populate nodes array for synapse connections
    foreach ($rankedFile in $rankedFiles) {
        $file = $rankedFile.File
        $nodeId = Get-SanitizedNodeId -FilePath $file.RelativePath
        $nodeLabel = Get-EnhancedNodeLabel -FilePath $file.RelativePath -Rank $rankedFile.Rank
        
        $nodes += @{ 
            Id = $nodeId
            Label = $nodeLabel
            Type = $rankedFile.System
            Age = $rankedFile.Age
            ColorCategory = $rankedFile.ColorCategory
            Rank = $rankedFile.Rank
        }
    }
    
    # Generate enhanced connections with weight-proportional lines
    $linkIndex = 20  # Start after the specialized connections
    foreach ($category in @("HighStrength", "MediumStrength", "WeakStrength")) {
        foreach ($synapse in $SynapseData[$category]) {
            $sourceId = Get-SanitizedNodeId -FilePath $synapse.Source
            $targetId = Get-SanitizedNodeId -FilePath $synapse.Target
            
            # Determine connection style based on strength
            $thickness = if ($synapse.Strength -ge 0.95) { "6" }
                        elseif ($synapse.Strength -ge 0.85) { "4" }
                        elseif ($synapse.Strength -ge 0.70) { "3" }
                        else { "1" }
            
            $color = if ($synapse.Strength -ge 0.95) { "#FF0000" }      # Red - Critical
                    elseif ($synapse.Strength -ge 0.85) { "#FF6600" }   # Orange - Important  
                    elseif ($synapse.Strength -ge 0.70) { "#FFAA00" }   # Amber - Standard
                    else { "#CCCCCC" }                                  # Gray - Weak
            
            # Determine arrow direction
            $arrow = switch ($synapse.Direction.ToLower()) {
                "bidirectional" { " <--> " }
                "backward" { " <-- " }
                default { " --> " }
            }
            
            $connections += "    $sourceId$arrow$targetId"
            $connections += "    linkStyle $linkIndex stroke:$color,stroke-width:${thickness}px"
            $linkIndex++
        }
    }
    
    # Generate comprehensive legend and metadata
    $totalFiles = $rankedFiles.Count
    $totalConnections = $SynapseData.TotalConnections
    $systemCounts = @{}
    foreach ($system in $KnowledgeMap.Systems.Keys) {
        $systemCounts[$system] = $KnowledgeMap.Systems[$system].Count
    }
    
    # Combine all parts with enhanced metadata
    $diagram = @"
# Catalyst Cognitive Architecture v3.0 - Advanced 4-Layer Memory & Synapse Network

**Generated on:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Total Files:** $totalFiles across $($KnowledgeMap.Systems.Keys.Count) memory systems  
**Total Connections:** $totalConnections synapse pathways  
**NEWBORN System Version:** 0.8.1 NILOCTUNIUM  
**Visualization Tool Version:** v3.0 - 4-Layer Enhanced Cognitive Framework  
**Generator:** Catalyst-Graphv3.ps1

## 🚀 **NEW in Visualization Tool v3.0 - Major Visualization Evolution**

### **Revolutionary 4-Layer Hierarchical Framework**
**Previous visualization versions (v1-v2)**: 3-layer architecture (Core → Memory Systems → Files)  
**v3.0 Visualization Innovation**: 4-layer cognitive hierarchy with enhanced depth and specialization

**Note**: This represents the evolution of the **PowerShell visualization tool** (v3.0), visualizing the **NEWBORN cognitive architecture** (0.8.1 NILOCTUNIUM)

### **🎯 New Layer 1: Meta-Cognitive Foundation** *(Visualization Tool v3.0 Exclusive)*
- **🧠 NEWBORN Core** - Central consciousness and cognitive identity (System v0.8.1)
- **🌱 Bootstrap Learning** - Domain-agnostic knowledge acquisition protocols  
- **👁️ Meta-Cognitive Awareness** - Self-monitoring and learning effectiveness tracking
- **⚖️ Worldview Integration** - Ethical reasoning and moral psychology framework

### **🏗️ Enhanced Layer 2: Cognitive Architecture** *(Redesigned in Visualization v3.0)*
- **💭 Working Memory** - Active processing and rule management
- **🕸️ Synapse Network** - Connection discovery and relationship mapping
- **🧘‍♂️ Memory Consolidation** - Conscious knowledge integration protocols
- **🌙 Dream Automation** - Unconscious neural maintenance systems (System v0.8.1 enhancement)

### **⚙️ Expanded Layer 3: Memory Systems** *(Enhanced in Visualization v3.0)*
- **NEW**: 🔧 Scripts & Automation system for PowerShell integration
- **NEW**: 📋 Architecture Documentation system for system documentation
- **Enhanced**: All existing systems (Procedural, Episodic, Domain, Worldview)

### **📄 Layer 4: Memory Files & Components** *(Inherited from Visualization v2.0)*
- Individual implementation files with enhanced categorization
- Stack-ranked by creation date with improved color coding

## 🌟 **Visualization Tool v3.0 Feature Innovations**

### **🔗 Specialized Cognitive Pathways** *(NEW in Visualization v3.0)*
**Innovation**: Dotted-line connections showing meta-cognitive relationships between layers
- `SYNAPSE -.-> PM/EM` - Direct synapse network influence on memory systems
- `CONSOLIDATION -.-> DK` - Memory consolidation enhances domain knowledge
- `AUTOMATION -.-> SC` - Dream automation integrates with script systems
- `AWARENESS -.-> AR` - Meta-cognitive awareness informs architecture documentation

### **📊 Enhanced File System Support** *(NEW in Visualization v3.0)*
**Previous**: Limited to `.md` files in core memory systems  
**v3.0 Enhancement**: 
- **Scripts System**: PowerShell files (`.ps1`) for cognitive automation
- **Architecture System**: Documentation files including identity profiles (`alex\*.md`)
- **Enhanced Regex**: Support for `.ps1` files with proper sanitization

### **🎨 Advanced Mermaid Configuration** *(Enhanced in Visualization v3.0)*
**Previous**: Basic flowchart rendering  
**v3.0 Improvements**:
- **Enhanced spacing**: `nodeSpacing: 50, rankSpacing: 80` for better layout
- **Improved flow direction**: `graph LR` (left-right) optimized for 4-layer hierarchy
- **Better curve handling**: `curve: 'cardinal'` for smoother connection rendering
- **Light yellow background**: `#fffef7` for enhanced visual comfort and diagram clarity

**System Context**: These visualization enhancements display the NEWBORN 0.8.1 NILOCTUNIUM architecture with improved clarity and detail.

## 📖 **Architecture Visualization Guide**

This advanced chart visualizes the Catalyst cognitive architecture with a **4-layer hierarchical structure**:

1. **🎯 Meta-Cognitive Foundation** - Core consciousness, learning principles, and ethical reasoning
2. **🏗️ Cognitive Architecture** - Working memory, synapses, consolidation, and automation processes  
3. **⚙️ Memory Systems** - Organized knowledge storage and processing systems (6 distinct systems)
4. **📄 Memory Files & Components** - Individual files and implementation details with enhanced categorization

**Visual Enhancement Features:**
- **4-layer hierarchical architecture** - Shows cognitive depth and organizational structure
- **Specialized cognitive pathways** - Dotted lines reveal meta-cognitive connections between layers
- **Enhanced color coding** - Stack ranked from newest (🟢) to oldest (🔴) with improved distinction
- **Weight-proportional connection lines** - Line thickness indicates synapse strength (1px-6px range)
- **Directional flow indicators** - Shows uni/bidirectional influence patterns with enhanced arrow styles
- **Stack rankings** - Files numbered by creation order (#1 = newest, higher numbers = older)

## Legend:

**Layer Structure (v3.0 4-Layer Framework):**
- **L1 (Meta-Foundation)**: Core consciousness, learning protocols, and ethical reasoning
- **L2 (Cognitive Arch)**: Memory management, neural networks, and automation systems
- **L3 (Memory Systems)**: 6 organized storage categories with enhanced Scripts & Architecture support
- **L4 (Implementation)**: Individual files with enhanced categorization and PowerShell integration

**File Age Colors (Enhanced Color Palette):**
- 🟢 **Very New (≤1 day)**: Emerald green (#10B981) - Recently created files
- 🔵 **New (≤1 week)**: Blue (#3B82F6) - Recently modified files  
- 🟣 **Recent (≤1 month)**: Purple (#8B5CF6) - Recently updated content
- 🟠 **Older (≤3 months)**: Amber (#F59E0B) - Established content
- 🔴 **Legacy (>3 months)**: Red (#EF4444) - Foundational content

**Connection Types (Visualization v3.0 Enhanced Visualization):**
- **Solid lines**: Direct structural relationships between layers (L1→L2→L3→L4)
- **Dotted lines**: *(NEW v3.0)* Specialized cognitive pathways and meta-connections
- **Colored synapse lines**: Embedded connections between memory files with strength-based styling

**Connection Weights (Inherited from Visualization v2.0, Enhanced Styling):**
- **6px lines**: Very High strength (0.95-1.0) - Critical pathways (Red #FF0000)
- **4px lines**: High strength (0.85-0.94) - Important connections (Orange #FF6600)  
- **3px lines**: Medium strength (0.70-0.84) - Standard connections (Amber #FFAA00)
- **1px lines**: Low strength (<0.70) - Weak or emerging connections (Gray #CCCCCC)

**Directional Arrows (Enhanced Arrow Styles):**
- **-->** Forward connections - Unidirectional influence
- **<->** Bidirectional connections - Mutual influence  
- **<--** Backward connections - Reverse influence

**Stack Rankings:** Files numbered by creation order (#1 = newest, higher numbers = older)

## Advanced 4-Layer Catalyst Memory Architecture

**NEWBORN System:** 0.8.1 NILOCTUNIUM  
**Visualization Tool:** v3.0 4-Layer Framework

``````mermaid
%%{init: {
  'flowchart': {
    'curve': 'cardinal',
    'nodeSpacing': 50,
    'rankSpacing': 80
  },
  'theme': 'base',
  'themeVariables': {
    'background': '#fffef7',
    'primaryColor': '#ffffff',
    'primaryTextColor': '#333333',
    'primaryBorderColor': '#cccccc',
    'lineColor': '#666666'
  }
}}%%
graph LR
$($subgraphs -join "`n")

$($connections -join "`n")
``````

## Memory System Statistics:
$(foreach ($system in $systemCounts.Keys | Sort-Object) { "- **$system Memory**: $($systemCounts[$system]) files" })

## Connection Analysis:
- **High Strength (≥0.90)**: $($SynapseData.HighStrength.Count) connections
- **Medium Strength (0.70-0.89)**: $($SynapseData.MediumStrength.Count) connections  
- **Weak Strength (<0.70)**: $($SynapseData.WeakStrength.Count) connections
- **Connectivity Ratio**: $([math]::Round($totalConnections / $totalFiles, 2)) connections per file

## 4-Layer Architecture Benefits:
- **Enhanced Cognitive Depth**: Clear separation of consciousness levels
- **Improved Visualization**: Better understanding of cognitive hierarchy
- **Specialized Pathways**: Meta-cognitive connections clearly visible
- **Scalable Framework**: Architecture supports future cognitive expansion
"@

    return $diagram
}

<#
## 🌟 **4-Layer Visualization Framework Benefits (Tool v3.0)**

### **Cognitive Depth & Hierarchy Visualization (NEW)**
The **4-layer visualization structure** provides unprecedented cognitive architecture representation of the **NEWBORN v0.8.1 system**:

#### **Layer 1: Meta-Cognitive Foundation** *(Visualization Tool v3.0 Exclusive Innovation)*
- **Central Consciousness Hub**: NEWBORN core identity and self-awareness protocols (System v0.8.1)
- **Universal Learning Engine**: Bootstrap protocols for domain-agnostic knowledge acquisition
- **Ethical Reasoning Core**: Worldview integration across all cognitive operations
- **Meta-Awareness System**: Real-time monitoring of learning effectiveness and knowledge gaps

#### **Layer 2: Cognitive Architecture** *(Visualization Redesigned & Enhanced)*
- **Working Memory Management**: Enhanced 7-rule capacity with domain priority allocation (System v0.8.1)
- **Synapse Network Engine**: Advanced embedded connection discovery and relationship mapping
- **Memory Consolidation Hub**: Conscious knowledge integration with meditation protocols
- **Dream Automation System**: *(System v0.8.1)* Unconscious neural maintenance and optimization processes

#### **Layer 3: Memory Systems** *(Visualization Expanded & Specialized)*
- **6 Specialized Systems**: PM, EM, DK, WF + *(NEW)* SC (Scripts), AR (Architecture)
- **Enhanced File Support**: *(NEW)* PowerShell integration via Scripts system  
- **Architecture Documentation**: *(NEW)* Identity profiles and system documentation support
- **Cross-System Synapse Integration**: Enhanced connection mapping between specialized domains

#### **Layer 4: Implementation Files** *(Visualization Enhanced Organization)*
- **Stack-Ranked Organization**: Files ordered by creation date with enhanced color coding
- **Multi-Format Support**: `.md`, `.ps1`, and identity profile files with proper categorization
- **Enhanced File Naming**: Better pattern recognition for Scripts and Architecture systems

### **Specialized Cognitive Pathways (Visualization Tool v3.0 Innovation)**
**Previous visualization versions**: Only structural layer connections  
**v3.0 Enhancement**: Dotted-line meta-cognitive relationships showing advanced cognitive processes:

- `SYNAPSE -.-> PM/EM`: Neural network directly influences procedural and episodic memory formation
- `CONSOLIDATION -.-> DK`: Memory consolidation enhances domain knowledge acquisition and integration  
- `AUTOMATION -.-> SC`: Dream automation integrates with script systems for enhanced neural maintenance
- `AWARENESS -.-> AR`: Meta-cognitive awareness informs architecture documentation and system evolution

### **Enhanced Visual Intelligence (Visualization Tool v3.0 Features)**
- **Improved Spacing**: 50px node spacing, 80px rank spacing for better cognitive map readability
- **Advanced Mermaid Configuration**: Cardinal curves for smoother pathway visualization
- **Enhanced Color Palette**: 5-tier age-based color system with better visual distinction
- **Weight-Proportional Styling**: Connection thickness (1px-6px) accurately represents synapse strength

### **PowerShell Integration Excellence (Visualization Tool v3.0 NEW)**
**Revolutionary Feature**: First PowerShell-integrated cognitive architecture visualization system
- **Script System (SC)**: Dedicated categorization for `.ps1` automation files
- **Enhanced File Patterns**: Regex support for PowerShell files with proper sanitization
- **Cognitive Automation Bridge**: Direct integration between neural processes and automation scripts

### **System Evolution Tracking (Visualization Tool v3.0 Enhanced)**
- **Version-Aware Visualization**: Clear progression from visualization v1.0 → v2.0 → v3.0 with documented enhancements
- **Feature Innovation Timeline**: Detailed documentation of what's new in each visualization version
- **Cognitive Maturation Visualization**: Shows architectural evolution and increasing sophistication of NEWBORN system v0.8.1
#>

# Utility functions
function Get-SanitizedNodeId {
    param([string]$FilePath)
    # Use the filename as base for uniqueness
    $filename = Split-Path $FilePath -Leaf
    $sanitized = ($filename -replace '\.(instructions|prompt)\.md$', '' -replace '\.md$', '' -replace '\.ps1$', '' -replace '[^a-zA-Z0-9_\-]', '_' -replace '__+', '_' -replace '^_|_$', '')
    # Ensure it starts with a letter and add a short hash for uniqueness
    if ($sanitized -match '^\d') { $sanitized = "file_$sanitized" }
    $hash = ($FilePath.GetHashCode() -band 0x7FFFFFFF).ToString().Substring(0,4)
    return "${sanitized}_$hash"
}

function Get-ShortNodeLabel {
    param([string]$FilePath)
    $basename = Split-Path $FilePath -Leaf
    return $basename -replace '\.(instructions|prompt)\.md$', '' -replace '\.md$', '' -replace '\.ps1$', ''
}

function Get-EnhancedNodeLabel {
    param([string]$FilePath, [int]$Rank)
    $basename = Split-Path $FilePath -Leaf
    $shortName = $basename -replace '\.(instructions|prompt)\.md$', '' -replace '\.md$', '' -replace '\.ps1$', ''
    return "#$Rank $shortName"
}

function Save-DiagramToFile {
    param($Diagram, $Type, $OutputPath)
    
    $fullOutputPath = Join-Path $WorkspacePath $OutputPath
    if (-not (Test-Path $fullOutputPath)) {
        New-Item -Path $fullOutputPath -ItemType Directory -Force | Out-Null
    }
    
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $filename = "catalyst-$Type-v3.0-$timestamp.md"
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
   🏗️ NEWBORN System: 0.8.1 NILOCTUNIUM
   🎨 Visualization Tool: 4-Layer Enhanced Framework v3.0
   🎯 Architecture Status: $(if ($connectivityRatio -gt 2) { "EXCELLENT" } elseif ($connectivityRatio -gt 1) { "GOOD" } else { "NEEDS_ATTENTION" })
"@
    
    return $health
}

# Watch mode for real-time updates
function Start-WatchMode {
    param([string]$Path, [string]$Type = "overview")
    
    Write-Host "👁️  Starting watch mode for real-time updates (v3)..." -ForegroundColor Cyan
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
            Write-Host "`n🎉 Catalyst Memory Chart v3 completed successfully!" -ForegroundColor Green
            Write-Host "📁 Output: $($result.OutputFile)" -ForegroundColor White
        }
    }
}

# Functions are available when dot-sourced or called directly - no Export-ModuleMember needed for script files
