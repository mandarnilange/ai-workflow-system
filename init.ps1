# AI Workflow System - Interactive Setup Script
# MIT License

param(
    [string]$TargetDir = ".",
    [switch]$NonInteractive = $false,
    [switch]$UseDefaults = $false
)

# --- Helper Functions ---

function Write-Color {
    param(
        [string]$text,
        [string]$color
    )
    try {
        # Check if Console property exists and is not null
        if ($color -and $host.PrivateData -and $host.PrivateData.PSObject.Properties['Console'] -and $host.PrivateData.Console) {
            $host.PrivateData.Console.ForegroundColor = $color
        }
    } catch {
        # Ignore color errors in environments that don't support it
    }
    
    Write-Host $text
    
    try {
        if ($color -and $host.PrivateData -and $host.PrivateData.PSObject.Properties['Console'] -and $host.PrivateData.Console) {
            $host.PrivateData.Console.ForegroundColor = 'Gray' # Reset to default
        }
    } catch {
        # Ignore
    }
}

function Ask-Question {
    param(
        [string]$prompt,
        [string]$default = $null,
        [string]$variableName = $null
    )

    if ($script:UseDefaults) {
        Write-Host "${prompt} [${default}] (Auto-selected)"
        return $default
    }

    $displayText = if ($default) { "${prompt} [${default}]: " } else { "${prompt}: " }
    
    Write-Color -text $displayText -color 'Yellow'
    
    if ($script:NonInteractive) {
        Write-Host "(Non-interactive: using default)"
        return $default
    }

    $inputVal = Read-Host

    if ([string]::IsNullOrWhiteSpace($inputVal) -and $default) {
        return $default
    }
    if ([string]::IsNullOrWhiteSpace($inputVal)) {
        return ""
    }
    return $inputVal
}

function Ask-Bool {
    param(
        [string]$prompt,
        [bool]$default = $true
    )
    
    if ($script:UseDefaults) {
         Write-Host "${prompt} (Auto-selected: ${default})"
         return $default
    }

    $defaultDisplay = if ($default) { "Y/n" } else { "y/N" }
    $displayText = "${prompt} [${defaultDisplay}]: "
    
    Write-Color -text $displayText -color 'Yellow'
    
    if ($script:NonInteractive) {
        Write-Host "(Non-interactive: using default)"
        return $default
    }

    $inputVal = Read-Host

    if ([string]::IsNullOrWhiteSpace($inputVal)) {
        return $default
    }
    if ($inputVal -match '^[Yy]') {
        return $true
    }
    return $false
}

function Ask-Select {
    param(
        [string]$prompt,
        [string]$options, # Pipe separated
        [string]$default = $null
    )

    Write-Color -text "${prompt}`n" -color 'Yellow'
    $optionArray = $options -split '\|'
    for ($i = 0; $i -lt $optionArray.Length; $i++) {
        $option = $optionArray[$i]
        $prefix = "$($i + 1). "
        if ($option -eq $default) {
            Write-Color -text "  $prefix$option (default)" -color 'Green'
        } else {
            Write-Host "  $prefix$option"
        }
    }
    
    if ($script:UseDefaults -or $script:NonInteractive) {
        $sel = if ($default) { $default } else { $optionArray[0] }
        Write-Host "Auto-selected: $sel"
        return $sel
    }

    $selectedOption = $null
    while (-not $selectedOption) {
        Write-Color -text "Select [1-$($optionArray.Length)]: " -color 'Yellow'
        $inputVal = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($inputVal) -and $default) {
            $selectedOption = $default
        } elseif ($inputVal -match '^\d+$' -and [int]$inputVal -ge 1 -and [int]$inputVal -le $optionArray.Length) {
            $selectedIndex = [int]$inputVal - 1
            $selectedOption = $optionArray[$selectedIndex]
        } else {
            Write-Color -text "Invalid selection. Please enter a number between 1 and $($optionArray.Length).`n" -color 'Red'
        }
    }
    return $selectedOption
}

function Ask-SelectMandatory {
    param(
        [string]$prompt,
        [string]$options
    )

    Write-Color -text "${prompt}`n" -color 'Yellow'
    $optionArray = $options -split '\|'
    for ($i = 0; $i -lt $optionArray.Length; $i++) {
        Write-Host "  $($i + 1). $($optionArray[$i])"
    }

    if ($script:UseDefaults -or $script:NonInteractive) {
        # Default to first option in non-interactive
        $sel = $optionArray[0]
        Write-Host "Auto-selected (Mandatory): $sel"
        return $sel
    }

    $selectedOption = $null
    while (-not $selectedOption) {
        Write-Color -text "Select [1-$($optionArray.Length)] (REQUIRED): " -color 'Yellow'
        $inputVal = Read-Host

        if ([string]::IsNullOrWhiteSpace($inputVal)) {
            Write-Color -text "Selection is required. Please enter a number.`n" -color 'Red'
            continue
        }
        if ($inputVal -match '^\d+$' -and [int]$inputVal -ge 1 -and [int]$inputVal -le $optionArray.Length) {
            $selectedIndex = [int]$inputVal - 1
            $selectedOption = $optionArray[$selectedIndex]
        } else {
            Write-Color -text "Invalid input. Please enter a number between 1 and $($optionArray.Length).`n" -color 'Red'
        }
    }
    return $selectedOption
}

function Get-ConfigValue {
    param(
        [string[]]$ContentLines,
        [string]$Section,
        [string]$Key
    )
    
    $inSection = $false
    foreach ($line in $ContentLines) {
        if ($line -match "^${Section}:") { 
            $inSection = $true; 
            continue 
        }
        if ($inSection -and $line -match '^[a-z_]+:') { 
            $inSection = $false 
        }
        if ($inSection -and $line -match "^\s+${Key}:") {
            $value = $line -replace "^\s+${Key}:\s*", "" -replace '^"|"$', ""
            $value = ($value -split "#")[0].Trim()
            return $value
        }
    }
    return $null
}

function Get-ConfigLayerPath {
    param(
        [string[]]$ContentLines,
        [string]$LayerName
    )
    
    $inLayers = $false
    $currentLayerName = $null
    
    foreach ($line in $ContentLines) {
        if ($line -match "^architecture:") { $inLayers = $false; continue }
        if ($line -match "^\s+layers:") { $inLayers = $true; continue }
        
        if ($inLayers) {
            if ($line -match "^\s+-\s+name:\s*[`"]?${LayerName}[`"]?") {
                $currentLayerName = $LayerName
            } elseif ($line -match "^\s+-\s+name:") {
                $currentLayerName = $null
            }
            
            if ($currentLayerName -eq $LayerName -and $line -match "^\s+path:\s*") {
                $path = $line -replace "^\s+path:\s*", "" -replace '^"|"$', ""
                return $path.Trim()
            }
        }
    }
    return $null
}

# Helper function to parse YAML config and populate variables
function Parse-ConfigYaml {
    param(
        [string]$ConfigFilePath
    )

    if (-not (Test-Path $ConfigFilePath)) {
        Write-Color -text "Error: Config file not found: $ConfigFilePath`n" -color 'Red'
        exit 1
    }

    $content = Get-Content $ConfigFilePath

    # Project section
    $global:PROJECT_NAME = Get-ConfigValue $content "project" "name"
    $global:PROJECT_DESCRIPTION = Get-ConfigValue $content "project" "description"
    $global:LANGUAGE = Get-ConfigValue $content "project" "language"
    $global:FRAMEWORK = Get-ConfigValue $content "project" "framework"

    # Testing section
    $global:TEST_FRAMEWORK = Get-ConfigValue $content "testing" "framework"
    $global:TEST_COMMAND = Get-ConfigValue $content "testing" "test_command"
    $global:COVERAGE_COMMAND = Get-ConfigValue $content "testing" "coverage_command"
    $global:COVERAGE_REQUIREMENT = Get-ConfigValue $content "testing" "required_coverage"
    $tddReq = Get-ConfigValue $content "testing" "tdd_required"
    $global:TDD_REQUIRED = $tddReq -eq "true"
    $global:TEST_DIR = Get-ConfigValue $content "testing" "test_directory"
    $global:TEST_PATTERN = Get-ConfigValue $content "testing" "test_file_pattern"
    $enforceCov = Get-ConfigValue $content "testing" "enforce_coverage"
    $global:ENFORCE_COVERAGE = $enforceCov -eq "true"

    # Quality section
    $global:LINTER = Get-ConfigValue $content "quality" "linter"
    $global:LINT_COMMAND = Get-ConfigValue $content "quality" "lint_command"
    $global:FORMATTER = Get-ConfigValue $content "quality" "formatter"
    $global:FORMAT_COMMAND = Get-ConfigValue $content "quality" "format_command"
    $fmtCheck = Get-ConfigValue $content "quality" "format_check_only"
    $global:FORMAT_CHECK_ONLY = $fmtCheck -eq "true"
    $global:TYPE_CHECKER = Get-ConfigValue $content "quality" "type_checker"
    $global:TYPE_CHECK_COMMAND = Get-ConfigValue $content "quality" "type_check_command"

    # Build section
    $buildReq = Get-ConfigValue $content "build" "required"
    $global:BUILD_REQUIRED = $buildReq -eq "true"
    $global:BUILD_COMMAND = Get-ConfigValue $content "build" "command"
    $global:BUILD_OUTPUT_DIR = Get-ConfigValue $content "build" "output_dir"

    # Architecture section
    $archEnforce = Get-ConfigValue $content "architecture" "enforce"
    $global:ARCHITECTURE_ENFORCE = $archEnforce -eq "true"
    
    $global:DOMAIN_PATH = Get-ConfigLayerPath $content "domain"
    $global:APPLICATION_PATH = Get-ConfigLayerPath $content "application"
    $global:INFRASTRUCTURE_PATH = Get-ConfigLayerPath $content "infrastructure"
    $global:PRESENTATION_PATH = Get-ConfigLayerPath $content "presentation"
    $global:DI_PATH = Get-ConfigLayerPath $content "di"
    
    # Conventions section
    $global:CLASS_FILE_CONVENTION = Get-ConfigValue $content "conventions" "class_files"
    $global:FUNCTION_CONVENTION = Get-ConfigValue $content "conventions" "functions"
    $global:VARIABLE_CONVENTION = Get-ConfigValue $content "conventions" "variables"
    $global:CONSTANT_CONVENTION = Get-ConfigValue $content "conventions" "constants"
    $global:USE_CASE_PATTERN = Get-ConfigValue $content "conventions" "use_case_pattern"
    $global:INTERFACE_PREFIX = Get-ConfigValue $content "conventions" "interface_prefix"

    # Tracking section
    $trackEn = Get-ConfigValue $content "tracking" "enabled"
    $global:TRACKING_ENABLED = $trackEn -eq "true"

    # AI section
    $global:PRIMARY_AI = Get-ConfigValue $content "ai" "primary_assistant"
    $isClaude = Get-ConfigValue $content "ai" "is_claude_code"
    $global:IS_CLAUDE_CODE = $isClaude -eq "true"
    $verbose = Get-ConfigValue $content "ai" "verbose_reporting"
    $global:VERBOSE_REPORTING = $verbose -eq "true"
    $emoji = Get-ConfigValue $content "ai" "emoji_indicators"
    $global:EMOJI_INDICATORS = $emoji -eq "true"

    # Git section
    $gitTests = Get-ConfigValue $content "git" "run_tests_pre_commit"
    $global:RUN_TESTS_PRE_COMMIT = $gitTests -eq "true"
    $gitLint = Get-ConfigValue $content "git" "run_linting_pre_commit"
    $global:RUN_LINTING_PRE_COMMIT = $gitLint -eq "true"
    $gitArch = Get-ConfigValue $content "git" "run_architecture_pre_commit"
    $global:RUN_ARCHITECTURE_PRE_COMMIT = $gitArch -eq "true"
}

# Helper function to process templates with variable substitution
function Process-Template {
    param(
        [string]$TemplateFile,
        [string]$OutputFile
    )

    if (-not (Test-Path $TemplateFile)) {
        Write-Color -text "Error: Template file not found: $TemplateFile`n" -color 'Red'
        exit 1
    }

    $templateContent = Get-Content $TemplateFile -Raw

    # List of variables to substitute
    $vars = @(
        "PROJECT_NAME", "PROJECT_DESCRIPTION", "LANGUAGE", "FRAMEWORK",
        "TEST_FRAMEWORK", "TEST_COMMAND", "COVERAGE_COMMAND", "COVERAGE_REQUIREMENT",
        "TDD_REQUIRED", "TEST_DIR", "TEST_PATTERN", "ENFORCE_COVERAGE",
        "LINTER", "LINT_COMMAND", "FORMATTER", "FORMAT_COMMAND", "FORMAT_CHECK_ONLY",
        "TYPE_CHECKER", "TYPE_CHECK_COMMAND",
        "BUILD_REQUIRED", "BUILD_COMMAND", "BUILD_OUTPUT_DIR",
        "ARCHITECTURE_ENFORCE", "DOMAIN_PATH", "APPLICATION_PATH", "INFRASTRUCTURE_PATH",
        "PRESENTATION_PATH", "DI_PATH",
        "CLASS_FILE_CONVENTION", "FUNCTION_CONVENTION", "VARIABLE_CONVENTION",
        "CONSTANT_CONVENTION", "USE_CASE_PATTERN", "INTERFACE_PREFIX",
        "TRACKING_ENABLED", "PRIMARY_AI", "IS_CLAUDE_CODE",
        "VERBOSE_REPORTING", "EMOJI_INDICATORS",
        "RUN_TESTS_PRE_COMMIT", "RUN_LINTING_PRE_COMMIT", "RUN_ARCHITECTURE_PRE_COMMIT",
        "EXAMPLE_CLASS", "EXAMPLE_FUNCTION", "EXAMPLE_TEST", "EXAMPLE_IMPORT",
        "FILE_EXTENSION", "TEST_FILE_EXTENSION", "SOURCE_DIR",
        "IMPORT_PATTERN", "IMPORT_FROM_PATTERN", "FIND_FILES_PATTERN", "LANGUAGE_LOWER",
        "TEST_EXAMPLES", "TYPE_CHECK_COMMAND_SECTION", "TYPE_CHECK_CHECKLIST",
        "BUILD_COMMAND_SECTION", "CLAUDE_CODE_OPTIMIZATIONS"
    )

    foreach ($varName in $vars) {
        $val = Get-Variable -Name $varName -Scope Global -ErrorAction SilentlyContinue
        if ($val -and $val.Value) {
            $strVal = $val.Value.ToString()
            $templateContent = $templateContent.Replace("`${$varName}", $strVal)
            $templateContent = $templateContent.Replace("`$$varName", $strVal)
        }
    }
    
    $templateContent | Set-Content $OutputFile -Encoding UTF8
}

# --- Main Script Logic ---

$SCRIPT_DIR = if ($PSScriptRoot) { $PSScriptRoot } else { "." }

$TARGET_DIR = if ($TargetDir) { $TargetDir } else { "." }
$TARGET_DIR = Resolve-Path $TARGET_DIR -ErrorAction SilentlyContinue
if (-not $TARGET_DIR) { 
    if (Test-Path $TargetDir) {
        $TARGET_DIR = (Resolve-Path $TargetDir).Path
    } else {
        Write-Color -text "Error: Target directory '$TargetDir' does not exist.`n" -color 'Red'
        exit 1 
    }
} else {
    $TARGET_DIR = $TARGET_DIR.Path
}

$CONFIG_FILE = Join-Path $TARGET_DIR ".workflow/config.yml"
$AGENTS_FILE = Join-Path $TARGET_DIR "AGENTS.md"
$CLAUDE_FILE = Join-Path $TARGET_DIR "CLAUDE.md"

$IS_UPDATE = $false
$QUICK_UPDATE = $false
$OVERWRITE_CONFIG = $false

if (Test-Path $CONFIG_FILE) {
    $IS_UPDATE = $true

    Write-Color -text "###########################################################" -color 'Yellow'
    Write-Color -text "#                                                         #" -color 'Yellow'
    Write-Color -text "#          Existing Installation Detected                 #" -color 'Yellow'
    Write-Color -text "#                                                         #" -color 'Yellow'
    Write-Color -text "###########################################################`n" -color 'Yellow'

    Write-Color -text "Found existing files:`n" -color 'Blue'
    if (Test-Path $CONFIG_FILE) { Write-Host "  + .workflow/config.yml" }
    if (Test-Path $AGENTS_FILE) { Write-Host "  + AGENTS.md" }
    if (Test-Path $CLAUDE_FILE) { Write-Host "  + CLAUDE.md" }

    Write-Color -text "`nUpdate options:`n" -color 'Blue'
    # Use single quotes to be safe
    Write-Host '  1. Quick Update (default) - Update playbooks & templates only (keeps all settings)'
    Write-Host "  2. Full Reconfigure - Re-answer all configuration questions"
    Write-Host "  3. Cancel"
    
    if ($script:NonInteractive -or $script:UseDefaults) {
         $update_choice = "1"
         Write-Host "Auto-selected: 1"
    } else {
         Write-Color -text "Select [1-3] (default: 1): " -color 'Yellow'
         $update_choice = Read-Host
    }

    switch ($update_choice) {
        "1" { $QUICK_UPDATE = $true; Write-Color -text "[OK] Quick update mode`n" -color 'Green' }
        "2" { $QUICK_UPDATE = $false; Write-Color -text "Starting full reconfiguration...`n" -color 'Blue' }
        "3" { Write-Color -text "Update cancelled`n" -color 'Yellow'; exit 0 }
        default { $QUICK_UPDATE = $true; Write-Color -text "[OK] Quick update mode (default)`n" -color 'Green' }
    }
}

if ($QUICK_UPDATE) {
    Write-Color -text "Quick update mode - reading existing configuration...`n" -color 'Blue'
    Parse-ConfigYaml -ConfigFilePath $CONFIG_FILE
    $global:LANGUAGE_LOWER = $global:LANGUAGE.ToLower()

    switch ($global:LANGUAGE) {
        "TypeScript" {
            $global:FILE_EXTENSION = ".ts"; $global:TEST_FILE_EXTENSION = ".test.ts"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*from.*'\.\."; $global:FIND_FILES_PATTERN = "*.ts"
        }
        "Python" {
            $global:FILE_EXTENSION = ".py"; $global:TEST_FILE_EXTENSION = "_test.py"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^(import|from)"; $global:IMPORT_FROM_PATTERN = "^(import|from).*\.\."; $global:FIND_FILES_PATTERN = "*.py"
        }
        "Java" {
            $global:FILE_EXTENSION = ".java"; $global:TEST_FILE_EXTENSION = "Test.java"; $global:SOURCE_DIR = "src/main/java"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import"; $global:FIND_FILES_PATTERN = "*.java"
        }
        "Go" {
            $global:FILE_EXTENSION = ".go"; $global:TEST_FILE_EXTENSION = "_test.go"; $global:SOURCE_DIR = "."; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*`"\.\."; $global:FIND_FILES_PATTERN = "*.go"
        }
        "Rust" {
            $global:FILE_EXTENSION = ".rs"; $global:TEST_FILE_EXTENSION = ".rs"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^use"; $global:IMPORT_FROM_PATTERN = "^use.*super::"; $global:FIND_FILES_PATTERN = "*.rs"
        }
        "C#" {
            $global:FILE_EXTENSION = ".cs"; $global:TEST_FILE_EXTENSION = "Tests.cs"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^using"; $global:IMPORT_FROM_PATTERN = "^using"; $global:FIND_FILES_PATTERN = "*.cs"
        }
        default {
            $global:FILE_EXTENSION = ".${LANGUAGE_LOWER}"; $global:TEST_FILE_EXTENSION = "_test.${LANGUAGE_LOWER}"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*`"\.\."; $global:FIND_FILES_PATTERN = "*.${LANGUAGE_LOWER}"
        }
    }

    switch ($global:LANGUAGE) {
        "TypeScript" { $global:EXAMPLE_CLASS = "User"; $global:EXAMPLE_FUNCTION = "getUserById"; $global:EXAMPLE_TEST = "User.test.ts"; $global:EXAMPLE_IMPORT = "import { User } from './User'" }
        "Python" { $global:EXAMPLE_CLASS = "User"; $global:EXAMPLE_FUNCTION = "get_user_by_id"; $global:EXAMPLE_TEST = "test_user.py"; $global:EXAMPLE_IMPORT = "from user import User" }
        "Java" { $global:EXAMPLE_CLASS = "User"; $global:EXAMPLE_FUNCTION = "getUserById"; $global:EXAMPLE_TEST = "UserTest.java"; $global:EXAMPLE_IMPORT = "import com.example.User" }
        "Go" { $global:EXAMPLE_CLASS = "User"; $global:EXAMPLE_FUNCTION = "GetUserByID"; $global:EXAMPLE_TEST = "user_test.go"; $global:EXAMPLE_IMPORT = 'import "example.com/domain/user"' }
        default { $global:EXAMPLE_CLASS = "User"; $global:EXAMPLE_FUNCTION = "getUser"; $global:EXAMPLE_TEST = "user.test"; $global:EXAMPLE_IMPORT = "import User" }
    }

    if ($global:TYPE_CHECKER -ne "null") {
        $global:TYPE_CHECK_COMMAND_SECTION = "${global:TYPE_CHECK_COMMAND}        # Run type checker"
        $global:TYPE_CHECK_CHECKLIST = "- [ ] **Type Checking**: Zero type errors (`${global:TYPE_CHECK_COMMAND}`)"
    } else {
        $global:TYPE_CHECK_COMMAND_SECTION = ""
        $global:TYPE_CHECK_CHECKLIST = ""
    }

    if ($global:BUILD_REQUIRED -eq $true) {
        $global:BUILD_COMMAND_SECTION = @"

# Build
$global:BUILD_COMMAND             # Build the project
"@
    } else {
        $global:BUILD_COMMAND_SECTION = ""
    }
    
    if ($global:IS_CLAUDE_CODE -eq $true) {
        if (Test-Path "$SCRIPT_DIR/templates/instructions/CLAUDE_CODE_OPTIMIZATIONS.md.template") {
            $CLAUDE_CODE_OPTIMIZATIONS_TEMPLATE = Get-Content "$SCRIPT_DIR/templates/instructions/CLAUDE_CODE_OPTIMIZATIONS.md.template" -Raw
            $global:CLAUDE_CODE_OPTIMIZATIONS = $CLAUDE_CODE_OPTIMIZATIONS_TEMPLATE.Replace("`${LANGUAGE}", $global:LANGUAGE).Replace("`${PROJECT_NAME}", $global:PROJECT_NAME)
        }
    } else {
        $global:CLAUDE_CODE_OPTIMIZATIONS = ""
    }

    switch ($global:LANGUAGE) {
        "TypeScript" {
            $global:TEST_EXAMPLES = @'
```typescript
describe('User', () => {
  it('should return user when valid id provided', () => {
    // Arrange-Act-Assert
  })

  it('should throw error when user not found', () => {
    // Arrange-Act-Assert
  })
})
```
'@
        }
        "Python" {
            $global:TEST_EXAMPLES = @'
```python
class TestUser:
    def test_should_return_user_when_valid_id_provided(self):
        # Arrange-Act-Assert
        pass

    def test_should_raise_error_when_user_not_found(self):
        # Arrange-Act-Assert
        pass
```
'@
        }
        "Java" {
            $global:TEST_EXAMPLES = @'
```java
class UserTest {
    @Test
    void shouldReturnUserWhenValidIdProvided() {
        // Arrange-Act-Assert
    }

    @Test
    void shouldThrowExceptionWhenUserNotFound() {
        // Arrange-Act-Assert
    }
}
```
'@
        }
        "Go" {
            $global:TEST_EXAMPLES = @'
```go
func TestUser_ShouldReturnUserWhenValidIdProvided(t *testing.T) {
    // Arrange-Act-Assert
}

func TestUser_ShouldReturnErrorWhenUserNotFound(t *testing.T) {
    // Arrange-Act-Assert
}
```
'@
        }
        default { $global:TEST_EXAMPLES = "" }
    }
    
    if ($global:TEST_EXAMPLES) {
        $global:TEST_EXAMPLES = $global:TEST_EXAMPLES.Replace("User", $global:EXAMPLE_CLASS)
    }

    Write-Color -text "[OK] Loaded configuration from existing config.yml`n" -color 'Green'
    $OVERWRITE_CONFIG = $false
}

if (-not $QUICK_UPDATE) {
    if ($IS_UPDATE) {
        Write-Color -text "Full reconfigure mode - loading current values as defaults...`n" -color 'Blue'
        Parse-ConfigYaml -ConfigFilePath $CONFIG_FILE
        Write-Color -text "[OK] Loaded current configuration`n" -color 'Green'

        $PROJECT_NAME_DEFAULT = $global:PROJECT_NAME
        $PROJECT_DESCRIPTION_DEFAULT = $global:PROJECT_DESCRIPTION
        $LANGUAGE_DEFAULT = $global:LANGUAGE
        $FRAMEWORK_DEFAULT = $global:FRAMEWORK
        $TEST_FRAMEWORK_DEFAULT = $global:TEST_FRAMEWORK
        $TEST_COMMAND_DEFAULT = $global:TEST_COMMAND
        $COVERAGE_COMMAND_DEFAULT = $global:COVERAGE_COMMAND
        $COVERAGE_REQUIREMENT_DEFAULT = $global:COVERAGE_REQUIREMENT
        $TDD_REQUIRED_DEFAULT = $global:TDD_REQUIRED
        $TEST_DIR_DEFAULT = $global:TEST_DIR
        $TEST_PATTERN_DEFAULT = $global:TEST_PATTERN
        $LINTER_DEFAULT = $global:LINTER
        $LINT_COMMAND_DEFAULT = $global:LINT_COMMAND
        $FORMATTER_DEFAULT = $global:FORMATTER
        $FORMAT_COMMAND_DEFAULT = $global:FORMAT_COMMAND
        $TYPE_CHECKER_DEFAULT = $global:TYPE_CHECKER
        $TYPE_CHECK_COMMAND_DEFAULT = $global:TYPE_CHECK_COMMAND
        $BUILD_REQUIRED_DEFAULT = $global:BUILD_REQUIRED
        $BUILD_COMMAND_DEFAULT = $global:BUILD_COMMAND
        $DOMAIN_PATH_DEFAULT = $global:DOMAIN_PATH
        $APPLICATION_PATH_DEFAULT = $global:APPLICATION_PATH
        $INFRASTRUCTURE_PATH_DEFAULT = $global:INFRASTRUCTURE_PATH
        $PRESENTATION_PATH_DEFAULT = $global:PRESENTATION_PATH
        $DI_PATH_DEFAULT = $global:DI_PATH
        $CLASS_FILE_CONVENTION_DEFAULT = $global:CLASS_FILE_CONVENTION
        $FUNCTION_CONVENTION_DEFAULT = $global:FUNCTION_CONVENTION
        $VARIABLE_CONVENTION_DEFAULT = $global:VARIABLE_CONVENTION
        $CONSTANT_CONVENTION_DEFAULT = $global:CONSTANT_CONVENTION
        $USE_CASE_PATTERN_DEFAULT = $global:USE_CASE_PATTERN
        $TRACKING_ENABLED_DEFAULT = $global:TRACKING_ENABLED
        $PRIMARY_AI_DEFAULT = $global:PRIMARY_AI
        $VERBOSE_REPORTING_DEFAULT = $global:VERBOSE_REPORTING
        $EMOJI_INDICATORS_DEFAULT = $global:EMOJI_INDICATORS
        $RUN_TESTS_PRE_COMMIT_DEFAULT = $global:RUN_TESTS_PRE_COMMIT
        $RUN_LINTING_PRE_COMMIT_DEFAULT = $global:RUN_LINTING_PRE_COMMIT
        $RUN_ARCHITECTURE_PRE_COMMIT_DEFAULT = $global:RUN_ARCHITECTURE_PRE_COMMIT
    } else {
        $PROJECT_NAME_DEFAULT = "My Project"
        $PROJECT_DESCRIPTION_DEFAULT = "A sample project"
        $LANGUAGE_DEFAULT = "TypeScript"
        $FRAMEWORK_DEFAULT = "Express.js"
        $COVERAGE_REQUIREMENT_DEFAULT = "100"
        $TDD_REQUIRED_DEFAULT = $true
        $DOMAIN_PATH_DEFAULT = "src/domain"
        $APPLICATION_PATH_DEFAULT = "src/application"
        $INFRASTRUCTURE_PATH_DEFAULT = "src/infrastructure"
        $PRESENTATION_PATH_DEFAULT = "src/presentation"
        $DI_PATH_DEFAULT = "src/di"
        $CLASS_FILE_CONVENTION_DEFAULT = "PascalCase"
        $USE_CASE_PATTERN_DEFAULT = "VerbNoun"
        $TRACKING_ENABLED_DEFAULT = $true
        $BUILD_REQUIRED_DEFAULT = $true
        $VERBOSE_REPORTING_DEFAULT = $true
        $EMOJI_INDICATORS_DEFAULT = $true
        $RUN_TESTS_PRE_COMMIT_DEFAULT = $true
        $RUN_LINTING_PRE_COMMIT_DEFAULT = $true
        $RUN_ARCHITECTURE_PRE_COMMIT_DEFAULT = $true
    }

    Write-Color -text "`n=== Project Information ===" -color 'Green'
    Write-Host ""
    $global:PROJECT_NAME = Ask-Question "Project name" $PROJECT_NAME_DEFAULT
    $global:PROJECT_DESCRIPTION = Ask-Question "Project description" $PROJECT_DESCRIPTION_DEFAULT
    $global:LANGUAGE = Ask-Select "Programming language" "TypeScript|Python|Java|Go|Rust|C#|Other" $LANGUAGE_DEFAULT
    $global:FRAMEWORK = Ask-Question "Framework (e.g., Express.js, FastAPI, Spring Boot)" $FRAMEWORK_DEFAULT

    Write-Color -text "`n=== Testing Configuration ===" -color 'Green'
    Write-Host ""

    if (-not $IS_UPDATE -or -not $TEST_FRAMEWORK_DEFAULT) {
        switch ($global:LANGUAGE) {
            "TypeScript" { $TEST_FRAMEWORK_DEFAULT = "Jest"; $TEST_COMMAND_DEFAULT = "npm test"; $COVERAGE_COMMAND_DEFAULT = "npm test -- --coverage"; $TEST_DIR_DEFAULT = "tests/"; $TEST_PATTERN_DEFAULT = "*.test.ts" }
            "Python" { $TEST_FRAMEWORK_DEFAULT = "pytest"; $TEST_COMMAND_DEFAULT = "pytest"; $COVERAGE_COMMAND_DEFAULT = "pytest --cov"; $TEST_DIR_DEFAULT = "tests/"; $TEST_PATTERN_DEFAULT = "test_*.py" }
            "Java" { $TEST_FRAMEWORK_DEFAULT = "JUnit"; $TEST_COMMAND_DEFAULT = "mvn test"; $COVERAGE_COMMAND_DEFAULT = "mvn test jacoco:report"; $TEST_DIR_DEFAULT = "src/test/"; $TEST_PATTERN_DEFAULT = "*Test.java" }
            "Go" { $TEST_FRAMEWORK_DEFAULT = "go test"; $TEST_COMMAND_DEFAULT = "go test ./..."; $COVERAGE_COMMAND_DEFAULT = "go test -cover ./..."; $TEST_DIR_DEFAULT = "./"; $TEST_PATTERN_DEFAULT = "*_test.go" }
            default { $TEST_FRAMEWORK_DEFAULT = ""; $TEST_COMMAND_DEFAULT = ""; $COVERAGE_COMMAND_DEFAULT = ""; $TEST_DIR_DEFAULT = "tests/"; $TEST_PATTERN_DEFAULT = "*.test.*" }
        }
    }

    $global:TEST_FRAMEWORK = Ask-Question "Test framework" $TEST_FRAMEWORK_DEFAULT
    $global:TEST_COMMAND = Ask-Question "Test command" $TEST_COMMAND_DEFAULT
    $global:COVERAGE_COMMAND = Ask-Question "Coverage command" $COVERAGE_COMMAND_DEFAULT
    $global:COVERAGE_REQUIREMENT = Ask-Question "Required test coverage (%)" $COVERAGE_REQUIREMENT_DEFAULT
    $global:ENFORCE_COVERAGE = Ask-Bool "Enforce coverage requirement" $true
    $global:TDD_REQUIRED = Ask-Bool "Require TDD (tests before code)" $TDD_REQUIRED_DEFAULT
    $global:TEST_DIR = Ask-Question "Test directory" $TEST_DIR_DEFAULT
    $global:TEST_PATTERN = Ask-Question "Test file pattern" $TEST_PATTERN_DEFAULT

    $global:LANGUAGE_LOWER = $global:LANGUAGE.ToLower()

    switch ($global:LANGUAGE) {
        "TypeScript" {
            $global:FILE_EXTENSION = ".ts"; $global:TEST_FILE_EXTENSION = ".test.ts"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*from.*'\.\."; $global:FIND_FILES_PATTERN = "*.ts"
        }
        "Python" {
            $global:FILE_EXTENSION = ".py"; $global:TEST_FILE_EXTENSION = "_test.py"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^(import|from)"; $global:IMPORT_FROM_PATTERN = "^(import|from).*\.\."; $global:FIND_FILES_PATTERN = "*.py"
        }
        "Java" {
            $global:FILE_EXTENSION = ".java"; $global:TEST_FILE_EXTENSION = "Test.java"; $global:SOURCE_DIR = "src/main/java"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import"; $global:FIND_FILES_PATTERN = "*.java"
        }
        "Go" {
            $global:FILE_EXTENSION = ".go"; $global:TEST_FILE_EXTENSION = "_test.go"; $global:SOURCE_DIR = "."; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*`"\.\."; $global:FIND_FILES_PATTERN = "*.go"
        }
        "Rust" {
            $global:FILE_EXTENSION = ".rs"; $global:TEST_FILE_EXTENSION = ".rs"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^use"; $global:IMPORT_FROM_PATTERN = "^use.*super::"; $global:FIND_FILES_PATTERN = "*.rs"
        }
        "C#" {
            $global:FILE_EXTENSION = ".cs"; $global:TEST_FILE_EXTENSION = "Tests.cs"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^using"; $global:IMPORT_FROM_PATTERN = "^using"; $global:FIND_FILES_PATTERN = "*.cs"
        }
        default {
            $global:FILE_EXTENSION = ".${LANGUAGE_LOWER}"; $global:TEST_FILE_EXTENSION = "_test.${LANGUAGE_LOWER}"; $global:SOURCE_DIR = "src"; $global:IMPORT_PATTERN = "^import"; $global:IMPORT_FROM_PATTERN = "^import.*`"\.\."; $global:FIND_FILES_PATTERN = "*.${LANGUAGE_LOWER}"
        }
    }

    Write-Color -text "`n=== Code Quality Tools ===" -color 'Green'
    Write-Host ""

    if (-not $IS_UPDATE -or -not $LINTER_DEFAULT) {
        switch ($global:LANGUAGE) {
            "TypeScript" { $LINTER_DEFAULT = "eslint"; $LINT_COMMAND_DEFAULT = "npm run lint"; $FORMATTER_DEFAULT = "prettier"; $FORMAT_COMMAND_DEFAULT = "npx prettier --check ."; $TYPE_CHECKER_DEFAULT = "tsc"; $TYPE_CHECK_COMMAND_DEFAULT = "npx tsc --noEmit" }
            "Python" { $LINTER_DEFAULT = "pylint"; $LINT_COMMAND_DEFAULT = "pylint src/"; $FORMATTER_DEFAULT = "black"; $FORMAT_COMMAND_DEFAULT = "black --check ."; $TYPE_CHECKER_DEFAULT = "mypy"; $TYPE_CHECK_COMMAND_DEFAULT = "mypy src/" }
            "Java" { $LINTER_DEFAULT = "checkstyle"; $LINT_COMMAND_DEFAULT = "mvn checkstyle:check"; $FORMATTER_DEFAULT = "google-java-format"; $FORMAT_COMMAND_DEFAULT = "mvn fmt:check"; $TYPE_CHECKER_DEFAULT = "null"; $TYPE_CHECK_COMMAND_DEFAULT = "null" }
            "Go" { $LINTER_DEFAULT = "golangci-lint"; $LINT_COMMAND_DEFAULT = "golangci-lint run"; $FORMATTER_DEFAULT = "gofmt"; $FORMAT_COMMAND_DEFAULT = "gofmt -l ."; $TYPE_CHECKER_DEFAULT = "null"; $TYPE_CHECK_COMMAND_DEFAULT = "null" }
            default { $LINTER_DEFAULT = ""; $LINT_COMMAND_DEFAULT = ""; $FORMATTER_DEFAULT = ""; $FORMAT_COMMAND_DEFAULT = ""; $TYPE_CHECKER_DEFAULT = "null"; $TYPE_CHECK_COMMAND_DEFAULT = "null" }
        }
    }

    $global:LINTER = Ask-Question "Linter" $LINTER_DEFAULT
    $global:LINT_COMMAND = Ask-Question "Lint command" $LINT_COMMAND_DEFAULT
    $global:FORMATTER = Ask-Question "Formatter" $FORMATTER_DEFAULT
    $global:FORMAT_COMMAND = Ask-Question "Format command" $FORMAT_COMMAND_DEFAULT
    $global:FORMAT_CHECK_ONLY = Ask-Bool "Format check only (not fix)" $true
    $global:TYPE_CHECKER = Ask-Question "Type checker (or 'null' for none)" $TYPE_CHECKER_DEFAULT
    if ($global:TYPE_CHECKER -ne "null") {
        $global:TYPE_CHECK_COMMAND = Ask-Question "Type check command" $TYPE_CHECK_COMMAND_DEFAULT
    } else {
        $global:TYPE_CHECK_COMMAND = "null"
    }

    Write-Color -text "`n=== Build Configuration ===" -color 'Green'
    Write-Host ""

    $global:BUILD_REQUIRED = Ask-Bool "Does project require building?" $BUILD_REQUIRED_DEFAULT
    if ($global:BUILD_REQUIRED) {
        if (-not $IS_UPDATE -or -not $BUILD_COMMAND_DEFAULT) {
            switch ($global:LANGUAGE) {
                "TypeScript" { $BUILD_COMMAND_DEFAULT = "npm run build"; $BUILD_OUTPUT_DIR_DEFAULT = "dist/" }
                "Java" { $BUILD_COMMAND_DEFAULT = "mvn package"; $BUILD_OUTPUT_DIR_DEFAULT = "target/" }
                "Go" { $BUILD_COMMAND_DEFAULT = "go build"; $BUILD_OUTPUT_DIR_DEFAULT = "bin/" }
                default { $BUILD_COMMAND_DEFAULT = ""; $BUILD_OUTPUT_DIR_DEFAULT = "build/" }
            }
        }
        $global:BUILD_COMMAND = Ask-Question "Build command" $BUILD_COMMAND_DEFAULT
        $global:BUILD_OUTPUT_DIR = Ask-Question "Build output directory" $BUILD_OUTPUT_DIR_DEFAULT
    } else {
        $global:BUILD_COMMAND = "null"
        $global:BUILD_OUTPUT_DIR = "null"
    }

    Write-Color -text "`n=== Architecture Configuration ===" -color 'Green'
    Write-Host ""

    $global:ARCHITECTURE_ENFORCE = Ask-Bool "Enforce Clean Architecture validation" $true

    Write-Color -text "`nDefine layer paths for Clean Architecture:`n" -color 'Yellow'
    $global:DOMAIN_PATH = Ask-Question "  Domain layer path" $DOMAIN_PATH_DEFAULT
    $global:APPLICATION_PATH = Ask-Question "  Application layer path" $APPLICATION_PATH_DEFAULT
    $global:INFRASTRUCTURE_PATH = Ask-Question "  Infrastructure layer path" $INFRASTRUCTURE_PATH_DEFAULT
    $global:PRESENTATION_PATH = Ask-Question "  Presentation layer path" $PRESENTATION_PATH_DEFAULT
    $global:DI_PATH = Ask-Question "  DI/Container layer path" $DI_PATH_DEFAULT

    Write-Color -text "`n=== Git & Commit Configuration ===" -color 'Green'
    Write-Host ""

    $global:RUN_TESTS_PRE_COMMIT = Ask-Bool "Run tests before commit" $RUN_TESTS_PRE_COMMIT_DEFAULT
    $global:RUN_LINTING_PRE_COMMIT = Ask-Bool "Run linting before commit" $RUN_LINTING_PRE_COMMIT_DEFAULT
    $global:RUN_ARCHITECTURE_PRE_COMMIT = Ask-Bool "Run architecture validation before commit" $RUN_ARCHITECTURE_PRE_COMMIT_DEFAULT

    Write-Color -text "`n=== Naming Conventions ===" -color 'Green'
    Write-Host ""

    $global:CLASS_FILE_CONVENTION = Ask-Select "Class file naming" "PascalCase|lowercase" $CLASS_FILE_CONVENTION_DEFAULT
    $global:INTERFACE_PREFIX = Ask-Select "Interface prefix" "I|none" "none"

    if (-not $IS_UPDATE -or -not $FUNCTION_CONVENTION_DEFAULT) {
        switch ($global:LANGUAGE) {
            "TypeScript" { $FUNCTION_CONVENTION_DEFAULT = "camelCase"; $VARIABLE_CONVENTION_DEFAULT = "camelCase"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
            "Java" { $FUNCTION_CONVENTION_DEFAULT = "camelCase"; $VARIABLE_CONVENTION_DEFAULT = "camelCase"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
            "C#" { $FUNCTION_CONVENTION_DEFAULT = "camelCase"; $VARIABLE_CONVENTION_DEFAULT = "camelCase"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
            "Python" { $FUNCTION_CONVENTION_DEFAULT = "snake_case"; $VARIABLE_CONVENTION_DEFAULT = "snake_case"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
            "Rust" { $FUNCTION_CONVENTION_DEFAULT = "snake_case"; $VARIABLE_CONVENTION_DEFAULT = "snake_case"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
            "Go" { $FUNCTION_CONVENTION_DEFAULT = "PascalCase"; $VARIABLE_CONVENTION_DEFAULT = "camelCase"; $CONSTANT_CONVENTION_DEFAULT = "PascalCase" }
            default { $FUNCTION_CONVENTION_DEFAULT = "camelCase"; $VARIABLE_CONVENTION_DEFAULT = "camelCase"; $CONSTANT_CONVENTION_DEFAULT = "UPPER_SNAKE_CASE" }
        }
    }

    $global:FUNCTION_CONVENTION = Ask-Select "Function naming" "camelCase|snake_case|PascalCase" $FUNCTION_CONVENTION_DEFAULT
    $global:VARIABLE_CONVENTION = Ask-Select "Variable naming" "camelCase|snake_case" $VARIABLE_CONVENTION_DEFAULT
    $global:CONSTANT_CONVENTION = Ask-Select "Constant naming" "UPPER_SNAKE_CASE|camelCase|PascalCase" $CONSTANT_CONVENTION_DEFAULT
    $global:USE_CASE_PATTERN = Ask-Question "Use case naming pattern" $USE_CASE_PATTERN_DEFAULT

    Write-Color -text "`n=== Task Tracking ===" -color 'Green'
    Write-Host ""

    $global:TRACKING_ENABLED = Ask-Bool "Enable .spec/ task tracking" $TRACKING_ENABLED_DEFAULT

    Write-Color -text "`n=== AI Assistant Configuration ===" -color 'Green'
    Write-Host ""

    $global:PRIMARY_AI = Ask-SelectMandatory "Primary AI assistant for coding" "Claude Code|Claude (Web/API)|ChatGPT|Gemini|Codex|Cursor|Other"

    if ($global:PRIMARY_AI -eq "Claude Code") {
        $global:IS_CLAUDE_CODE = $true
        Write-Color -text "[OK] Claude Code detected - will configure with parallel execution and sub-agents`n" -color 'Blue'
    } else {
        $global:IS_CLAUDE_CODE = $false
    }

    $global:VERBOSE_REPORTING = Ask-Bool "Verbose reporting (detailed progress)" $VERBOSE_REPORTING_DEFAULT
    $global:EMOJI_INDICATORS = Ask-Bool "Use emoji indicators" $EMOJI_INDICATORS_DEFAULT

}

if (-not $QUICK_UPDATE -and $IS_UPDATE) {
    Write-Host ""
    $OVERWRITE_CONFIG = $true
    if (Test-Path $CONFIG_FILE) {
        $OVERWRITE_CONFIG = Ask-Bool "Overwrite existing .workflow/config.yml with new config?" $false
    }
} elseif (-not $QUICK_UPDATE) {
    $OVERWRITE_CONFIG = $true
}

New-Item -ItemType Directory -Force -Path (Join-Path $TARGET_DIR ".workflow") | Out-Null

if ($OVERWRITE_CONFIG) {
    Write-Color -text "`nGenerating configuration...`n" -color 'Blue'

    $configContent = @"
# AI Workflow System Configuration
# Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

system:
  version: "0.5.0-beta"
  config_version: "0.2"

project:
  name: "$($global:PROJECT_NAME)"
  description: "$($global:PROJECT_DESCRIPTION)"
  language: "$($global:LANGUAGE)"
  framework: "$($global:FRAMEWORK)"

testing:
  framework: "$($global:TEST_FRAMEWORK)"
  test_command: "$($global:TEST_COMMAND)"
  coverage_command: "$($global:COVERAGE_COMMAND)"
  required_coverage: $($global:COVERAGE_REQUIREMENT)
  enforce_coverage: $($global:ENFORCE_COVERAGE.ToString().ToLower())
  tdd_required: $($global:TDD_REQUIRED.ToString().ToLower())
  test_directory: "$($global:TEST_DIR)"
  test_file_pattern: "$($global:TEST_PATTERN)"

quality:
  linter: "$($global:LINTER)"
  lint_command: "$($global:LINT_COMMAND)"
  formatter: "$($global:FORMATTER)"
  format_command: "$($global:FORMAT_COMMAND)"
  format_check_only: $($global:FORMAT_CHECK_ONLY.ToString().ToLower())
  type_checker: "$($global:TYPE_CHECKER)"
  type_check_command: "$($global:TYPE_CHECK_COMMAND)"

build:
  required: $($global:BUILD_REQUIRED.ToString().ToLower())
  command: "$($global:BUILD_COMMAND)"
  output_dir: "$($global:BUILD_OUTPUT_DIR)"

architecture:
  style: "clean"
  enforce: $($global:ARCHITECTURE_ENFORCE.ToString().ToLower())
  layers:
    - name: "domain"
      path: "$($global:DOMAIN_PATH)"
      dependencies: []
    - name: "application"
      path: "$($global:APPLICATION_PATH)"
      dependencies: ["domain"]
    - name: "infrastructure"
      path: "$($global:INFRASTRUCTURE_PATH)"
      dependencies: ["domain", "application"]
    - name: "presentation"
      path: "$($global:PRESENTATION_PATH)"
      dependencies: ["domain", "application"]
    - name: "di"
      path: "$($global:DI_PATH)"
      dependencies: ["domain", "application", "infrastructure", "presentation"]

git:
  commit_style: "conventional"
  types: ["feat", "fix", "refactor", "test", "docs", "chore"]
  subject_max_length: 50
  body_max_length: 72
  run_tests_pre_commit: $($global:RUN_TESTS_PRE_COMMIT.ToString().ToLower())
  run_linting_pre_commit: $($global:RUN_LINTING_PRE_COMMIT.ToString().ToLower())
  run_architecture_pre_commit: $($global:RUN_ARCHITECTURE_PRE_COMMIT.ToString().ToLower())

conventions:
  class_files: "$($global:CLASS_FILE_CONVENTION)"
  interface_prefix: "$($global:INTERFACE_PREFIX)"
  classes: "PascalCase"
  functions: "$($global:FUNCTION_CONVENTION)"
  variables: "$($global:VARIABLE_CONVENTION)"
  constants: "$($global:CONSTANT_CONVENTION)"
  use_case_pattern: "$($global:USE_CASE_PATTERN)"

tracking:
  enabled: $($global:TRACKING_ENABLED.ToString().ToLower())
  directory: ".spec/"
  feature_prefix: "feature-"
  bugfix_prefix: "fix-"
  refactor_prefix: "refactor-"
  overall_status_file: "overall-status.md"

ai:
  primary_assistant: "$($global:PRIMARY_AI)"
  is_claude_code: $($global:IS_CLAUDE_CODE.ToString().ToLower())
  verbose_reporting: $($global:VERBOSE_REPORTING.ToString().ToLower())
  emoji_indicators: $($global:EMOJI_INDICATORS.ToString().ToLower())

custom: {}
"@
    Set-Content -Path $CONFIG_FILE -Value $configContent -Encoding UTF8
    Write-Color -text "[OK] Generated: .workflow/config.yml`n" -color 'Green'
} else {
    Write-Color -text "- Skipped: .workflow/config.yml (keeping existing)`n" -color 'Yellow'
}

Write-Color -text "`nProcessing playbook templates...`n" -color 'Blue'

$playbookDir = Join-Path $TARGET_DIR ".workflow/playbooks"
New-Item -ItemType Directory -Force -Path $playbookDir | Out-Null

$templatePlaybookDir = Join-Path $SCRIPT_DIR "templates/playbooks"
if (Test-Path $templatePlaybookDir) {
    Get-ChildItem -Path $templatePlaybookDir -Filter "*.template" | ForEach-Object {
        $templateFile = $_.FullName
        $filename = $_.BaseName
        $outputFile = Join-Path $playbookDir $filename
        Process-Template -TemplateFile $templateFile -OutputFile $outputFile
        Write-Color -text "[OK] Processed: $filename" -color 'Green'
    }
}

$templateSpecDir = Join-Path $SCRIPT_DIR "templates"
$targetSpecDir = Join-Path $TARGET_DIR ".workflow/templates"
New-Item -ItemType Directory -Force -Path $targetSpecDir | Out-Null
if (Test-Path $templateSpecDir) {
    Get-ChildItem -Path $templateSpecDir -File | Copy-Item -Destination $targetSpecDir -Force
    Write-Color -text "[OK] Copied spec templates to .workflow/templates/`n" -color 'Green'
}

Write-Color -text "`nGenerating AGENTS_INSTRUCTIONS.md...`n" -color 'Blue'
$agentsInstructionsTemplate = Join-Path $SCRIPT_DIR "templates/instructions/AGENTS_INSTRUCTIONS.md.template"
$agentsInstructionsOutput = Join-Path $TARGET_DIR ".workflow/AGENTS_INSTRUCTIONS.md"
Process-Template -TemplateFile $agentsInstructionsTemplate -OutputFile $agentsInstructionsOutput
Write-Color -text "[OK] Generated: .workflow/AGENTS_INSTRUCTIONS.md`n" -color 'Green'

Write-Color -text "`nGenerating CLAUDE_INSTRUCTIONS.md...`n" -color 'Blue'
$claudeInstructionsTemplate = Join-Path $SCRIPT_DIR "templates/instructions/CLAUDE_INSTRUCTIONS.md.template"
$claudeInstructionsOutput = Join-Path $TARGET_DIR ".workflow/CLAUDE_INSTRUCTIONS.md"
Process-Template -TemplateFile $claudeInstructionsTemplate -OutputFile $claudeInstructionsOutput
Write-Color -text "[OK] Generated: .workflow/CLAUDE_INSTRUCTIONS.md`n" -color 'Green'

if ($global:IS_CLAUDE_CODE) {
    Write-Color -text "`nCreating Claude Code subagents...`n" -color 'Blue'
    
    $claudeAgentsDir = Join-Path $TARGET_DIR ".claude/agents"
    New-Item -ItemType Directory -Force -Path $claudeAgentsDir | Out-Null
    
    if (Test-Path "$($PSScriptRoot)/templates/agents/") {
        Copy-Item -Path "$($PSScriptRoot)/templates/agents/architecture-review.md.template" "$claudeAgentsDir/architecture-review.md" -Force
        Copy-Item -Path "$($PSScriptRoot)/templates/agents/lint.md.template" "$claudeAgentsDir/lint.md" -Force
        Copy-Item -Path "$($PSScriptRoot)/templates/agents/test.md.template" "$claudeAgentsDir/test.md" -Force
        
        Write-Color -text "[OK] Created subagents in .claude/agents/:" -color 'Green'
        Write-Host "  * architecture-review.md - Validate Clean Architecture compliance"
        Write-Host "  * lint.md - Run static analysis and linting"
        Write-Host "  * test.md - Execute test suite with coverage`n"
    }
}

Write-Color -text "`nGenerating pointer files...`n" -color 'Blue'
$agentsMdTemplate = Join-Path $SCRIPT_DIR "templates/instructions/AGENTS.md.template"
$claudeMdTemplate = Join-Path $SCRIPT_DIR "templates/instructions/CLAUDE.md.template"
Copy-Item -Path $agentsMdTemplate -Destination (Join-Path $TARGET_DIR "AGENTS.md") -Force
Copy-Item -Path $claudeMdTemplate -Destination (Join-Path $TARGET_DIR "CLAUDE.md") -Force
Write-Color -text "[OK] Generated: AGENTS.md (pointer)`n" -color 'Green'
Write-Color -text "[OK] Generated: CLAUDE.md (pointer)`n" -color 'Green'

$userInstructionsPath = Join-Path $TARGET_DIR "USER_INSTRUCTIONS.md"
if (-not (Test-Path $userInstructionsPath)) {
    Write-Color -text "`nCreating USER_INSTRUCTIONS.md template...`n" -color 'Blue'
    $userInstructionsTemplate = Join-Path $SCRIPT_DIR "templates/instructions/USER_INSTRUCTIONS.md.template"
    Copy-Item -Path $userInstructionsTemplate -Destination $userInstructionsPath -Force
    Write-Color -text "[OK] Created: USER_INSTRUCTIONS.md`n" -color 'Green'
} else {
    Write-Color -text "[SKIP] USER_INSTRUCTIONS.md already exists (keeping existing)`n" -color 'Yellow'
}

if ($global:TRACKING_ENABLED) {
    $specDir = Join-Path $TARGET_DIR ".spec"
    New-Item -ItemType Directory -Force -Path $specDir | Out-Null

    $specStatusFile = Join-Path $specDir "overall-status.md"
    if (-not (Test-Path $specStatusFile)) {
        Write-Color -text "`nCreating .spec/ directory...`n" -color 'Blue'

        $statusContent = @"
# $($global:PROJECT_NAME) - Overall Status

**Last Updated**: $(Get-Date -Format "yyyy-MM-dd")

## Summary
- Total Features: 0
- Completed: 0 (0%)
- In Progress: 0
- Blocked: 0

## Active Work

### In Progress
(None)

### Recently Completed
(None)

### Blocked
(None)

## Statistics
- Test Coverage: **0% (target: $($global:COVERAGE_REQUIREMENT)%)**
- Open Tasks: 0
- Completed Tasks: 0

## Recent Activity
- $(Get-Date -Format "yyyy-MM-dd"): Project initialized with AI Workflow System
"@
        Set-Content -Path $specStatusFile -Value $statusContent -Encoding UTF8
        Write-Color -text "[OK] Created .spec/ directory with overall-status.md`n" -color 'Green'
    } else {
        Write-Color -text "[SKIP] Skipped: .spec/overall-status.md (already exists)`n" -color 'Yellow'
    }
}

Write-Color -text "`nUpdating .gitignore...`n" -color 'Blue'

$gitignoreFile = Join-Path $TARGET_DIR ".gitignore"
if (-not (Test-Path $gitignoreFile)) {
    New-Item -ItemType File -Force -Path $gitignoreFile | Out-Null
}

if (-not (Get-Content $gitignoreFile -Raw | Select-String -Pattern ".workflow/config.yml" -SimpleMatch)) {
    Add-Content -Path $gitignoreFile -Value @'

# AI Workflow System
# Note: config.yml is project-specific, commit it!
# Uncomment next line if you want to keep config private:
# .workflow/config.yml
'@
    Write-Color -text "[OK] Updated .gitignore`n" -color 'Green'
} else {
    Write-Color -text "! .gitignore already contains workflow entries`n" -color 'Yellow'
}

Write-Color -text "###########################################################" -color 'Green'
Write-Color -text "#                                                         #" -color 'Green'
Write-Color -text "#          Setup Complete!                                #" -color 'Green'
Write-Color -text "#                                                         #" -color 'Green'
Write-Color -text "###########################################################`n" -color 'Green'

Write-Color -text "Created/Updated files:`n" -color 'Blue'
if ($OVERWRITE_CONFIG) { Write-Host "  + .workflow/config.yml                 - Project configuration" } else { Write-Host "  [SKIP] .workflow/config.yml                 - Kept existing" }
Write-Host "  + .workflow/playbooks/                 - Workflow playbooks (9 files)"
Write-Host "  + .workflow/templates/                 - Spec file templates"
Write-Host "  + .workflow/AGENTS_INSTRUCTIONS.md     - Full universal AI instructions"
Write-Host "  + .workflow/CLAUDE_INSTRUCTIONS.md     - Full Claude Code instructions"
Write-Host "  + AGENTS.md                            - Pointer to instructions (auto-generated)"
Write-Host "  + CLAUDE.md                            - Pointer to instructions (auto-generated)"
if ((Test-Path $userInstructionsPath) -and (-not $IS_UPDATE)) { Write-Host "  + USER_INSTRUCTIONS.md                 - Template for custom instructions" }
elseif (Test-Path $userInstructionsPath) { Write-Host "  [SKIP] USER_INSTRUCTIONS.md                 - Kept existing (add your custom instructions here)" }
else { Write-Host "  + USER_INSTRUCTIONS.md                 - Template for custom instructions" }
if ($global:IS_CLAUDE_CODE) { Write-Host "  + .claude/agents/                      - Claude Code subagents (3 files)" }
if ($global:TRACKING_ENABLED) {
    if ((Test-Path $specStatusFile) -and (-not $IS_UPDATE)) { Write-Host "  [SKIP] .spec/overall-status.md              - Already exists" }
    else { Write-Host "  + .spec/overall-status.md              - Task tracking dashboard" }
}

Write-Color -text "`nNext steps:`n" -color 'Blue'
Write-Host "  1. Review .workflow/config.yml and adjust if needed"
Write-Host "  2. Add project-specific instructions to USER_INSTRUCTIONS.md"
Write-Host "  3. Commit the workflow files to your repository"
Write-Host "  4. Share AGENTS.md or CLAUDE.md with your team"
if ($global:IS_CLAUDE_CODE) {
    Write-Host "  5. View your subagents in Claude Code: /agents"
    Write-Host "  6. Start using workflows:"
} else {
    Write-Host "  5. Start using workflows:"
}
Write-Host "     - For implementation: Ask AI to read AGENTS.md or CLAUDE.md"
Write-Host "     - For commits: Ask AI to read .workflow/playbooks/commit.md"

Write-Color -text "`nHappy coding! 🚀`n" -color 'Green'