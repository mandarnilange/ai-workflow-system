# AI Workflow System - Remote Installation Script
# Downloads the latest version and runs init.ps1

# --- Helper Functions ---

function Write-Color {
    param(
        [string]$text,
        [string]$color
    )
    if ($color) {
        $host.PrivateData.Console.ForegroundColor = $color
    }
    Write-Host $text
    if ($color) {
        $host.PrivateData.Console.ForegroundColor = 'Gray' # Reset to default
    }
}

# --- Main Script Logic ---

Write-Color -text "╔═══════════════════════════════════════════════════════════╗" -color 'Blue'
Write-Color -text "║                                                           ║" -color 'Blue'
Write-Color -text "║          AI Workflow System - Remote Install             ║" -color 'Blue'
Write-Color -text "║                                                           ║" -color 'Blue'
Write-Color -text "╚═══════════════════════════════════════════════════════════╝`n" -color 'Blue'

# Get target directory (default to current directory)
$TARGET_DIR = "."
if ($args.Length -gt 0) {
    $TARGET_DIR = $args[0]
}

# Resolve the target directory to an absolute path
# Resolve-Path fails if it doesn't exist, so checking existence first is better or using just the string if intent is to create
if (-not (Test-Path $TARGET_DIR)) {
    Write-Color -text "Error: Directory '$TARGET_DIR' does not exist.`n" -color 'Red'
    exit 1
}
$TARGET_DIR = (Resolve-Path $TARGET_DIR).Path

Write-Color -text "Installing to: $TARGET_DIR`n" -color 'Green'

# Create temporary directory
$TEMP_DIR = New-TemporaryFile -ErrorAction SilentlyContinue
if (-not $TEMP_DIR) {
    # Fallback if New-TemporaryFile fails (e.g., older PS)
    $TEMP_DIR_PATH = Join-Path $env:TEMP "ai-workflow-install-$(Get-Random)"
    New-Item -ItemType Directory -Path $TEMP_DIR_PATH -Force | Out-Null
} else {
    # New-TemporaryFile creates a file, we need a dir
    $TEMP_DIR_PATH = $TEMP_DIR.FullName + "_dir"
    Remove-Item $TEMP_DIR.FullName -Force
    New-Item -ItemType Directory -Path $TEMP_DIR_PATH -Force | Out-Null
}

# Ensure cleanup of temp dir upon exit
$trap = {
    $path = $Event.MessageData
    if (Test-Path $path) {
        Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}
Register-ObjectEvent -InputObject $host -EventName 'ApplicationExit' -Action $trap -MessageData $TEMP_DIR_PATH | Out-Null

Write-Color -text "Downloading AI Workflow System...`n" -color 'Blue'

# Download all necessary files
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoBaseUrl = "https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main"
$downloadDir = Join-Path $TEMP_DIR_PATH "downloaded_files"
New-Item -ItemType Directory -Force -Path $downloadDir | Out-Null

# Function to download a file
function Download-File {
    param($url, $destinationPath)
    Write-Host "  Downloading $(Split-Path $destinationPath -Leaf)..."
    try {
        # Use BasicParsing for compatibility, and set specific Tls version if needed for GitHub
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $destinationPath -ErrorAction Stop -UseBasicParsing
        Write-Color -text "  ✓ Downloaded" -color 'Green'
    } catch {
        Write-Color -text "  ✗ Failed to download from $url. Error: $($_.Exception.Message)`n" -color 'Red'
        throw # Re-throw to stop script execution
    }
}

# Create directory structure
$scriptDirTemplates = Join-Path $downloadDir "templates"
$scriptDirPlaybooks = Join-Path $scriptDirTemplates "playbooks"
$scriptDirInstructions = Join-Path $scriptDirTemplates "instructions"
$scriptDirAgents = Join-Path $scriptDirTemplates "agents"
$scriptDirExamples = Join-Path $downloadDir "examples"
$scriptDirExampleTsExpress = Join-Path $scriptDirExamples "typescript-express"

New-Item -ItemType Directory -Force -Path $scriptDirTemplates | Out-Null
New-Item -ItemType Directory -Force -Path $scriptDirPlaybooks | Out-Null
New-Item -ItemType Directory -Force -Path $scriptDirInstructions | Out-Null
New-Item -ItemType Directory -Force -Path $scriptDirAgents | Out-Null
New-Item -ItemType Directory -Force -Path $scriptDirExamples | Out-Null
New-Item -ItemType Directory -Force -Path $scriptDirExampleTsExpress | Out-Null

# Download core files
Write-Color -text "Downloading core files..." -color 'Yellow'
Download-File "$repoBaseUrl/init.ps1" (Join-Path $downloadDir "init.ps1")
Download-File "$repoBaseUrl/config.template.yml" (Join-Path $downloadDir "config.template.yml")
Download-File "$repoBaseUrl/README.md" (Join-Path $downloadDir "README.md")
Download-File "$repoBaseUrl/LICENSE" (Join-Path $downloadDir "LICENSE")

# Download playbook templates
Write-Color -text "Downloading playbook templates..." -color 'Yellow'
$playbooks = "coordinator", "feature", "bugfix", "commit", "tdd", "architecture-check", "reporting-guidelines", "run-lint", "run-tests", "prd-planning"
foreach ($playbook in $playbooks) {
    Download-File "$repoBaseUrl/templates/playbooks/$($playbook).md.template" (Join-Path $scriptDirPlaybooks "$($playbook).md.template")
}

# Download instruction templates
Write-Color -text "Downloading instruction templates..." -color 'Yellow'
$instructionTemplates = "AGENTS_INSTRUCTIONS", "CLAUDE_INSTRUCTIONS", "CLAUDE_CODE_OPTIMIZATIONS", "AGENTS", "CLAUDE", "USER_INSTRUCTIONS"
foreach ($template in $instructionTemplates) {
    Download-File "$repoBaseUrl/templates/instructions/$($template).md.template" (Join-Path $scriptDirInstructions "$($template).md.template")
}

# Download agent templates
Write-Color -text "Downloading agent templates..." -color 'Yellow'
$agentTemplates = "architecture-review", "lint", "test"
foreach ($agent in $agentTemplates) {
    Download-File "$repoBaseUrl/templates/agents/$($agent).md.template" (Join-Path $scriptDirAgents "$($agent).md.template")
}

# Download spec templates
Write-Color -text "Downloading spec templates..." -color 'Yellow'
$specTemplates = "feature-template", "bugfix-template", "overall-status-template", "prd-template"
foreach ($template in $specTemplates) {
    Download-File "$repoBaseUrl/templates/$($template).md" (Join-Path $scriptDirTemplates "$($template).md")
}

# Download TypeScript example
Write-Color -text "Downloading examples..." -color 'Yellow'
Download-File "$repoBaseUrl/examples/typescript-express/config.yml" (Join-Path $scriptDirExampleTsExpress "config.yml")
Download-File "$repoBaseUrl/examples/typescript-express/README.md" (Join-Path $scriptDirExampleTsExpress "README.md")

Write-Color -text "`n✓ Download complete`n" -color 'Green'

# Run init.ps1
Write-Color -text "Running interactive setup...`n" -color 'Blue'
$initScriptPath = Join-Path $downloadDir "init.ps1"

# Execute init.ps1, passing the target directory.
# We use & to run the script file.
& $initScriptPath $TARGET_DIR

if ($LASTEXITCODE -eq 0) {
    Write-Color -text "`n✓ Installation complete!`n" -color 'Green'
    Write-Color -text "The AI Workflow System has been installed to: $TARGET_DIR`n" -color 'Blue'
} else {
    Write-Color -text "`n✗ Installation failed.`n" -color 'Red'
    exit $LASTEXITCODE
}