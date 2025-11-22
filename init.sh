#!/bin/bash

# AI Workflow System - Interactive Setup Script
# MIT License

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Target directory (parent of script directory, or specified)
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          AI Workflow System Setup                        ║"
echo "║          Interactive Configuration                        ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Helper function to ask questions
ask() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    if [ -n "$default" ]; then
        echo -ne "${YELLOW}${prompt} [${default}]: ${NC}"
    else
        echo -ne "${YELLOW}${prompt}: ${NC}"
    fi

    read -r input < /dev/tty

    if [ -z "$input" ] && [ -n "$default" ]; then
        printf -v "$var_name" '%s' "$default"
    else
        printf -v "$var_name" '%s' "$input"
    fi
}

# Helper function to ask yes/no questions
ask_bool() {
    local prompt="$1"
    local default="$2"
    local var_name="$3"

    local default_display
    if [ "$default" = "true" ]; then
        default_display="Y/n"
    else
        default_display="y/N"
    fi

    echo -ne "${YELLOW}${prompt} [${default_display}]: ${NC}"
    read -r input < /dev/tty

    if [ -z "$input" ]; then
        printf -v "$var_name" '%s' "$default"
    elif [[ "$input" =~ ^[Yy] ]]; then
        printf -v "$var_name" '%s' "true"
    else
        printf -v "$var_name" '%s' "false"
    fi
}

# Helper function to select from options
ask_select() {
    local prompt="$1"
    local options="$2"
    local default="$3"
    local var_name="$4"

    echo -e "${YELLOW}${prompt}${NC}"
    IFS='|' read -ra OPTS <<< "$options"
    for i in "${!OPTS[@]}"; do
        if [ "${OPTS[$i]}" = "$default" ]; then
            echo -e "  ${GREEN}$((i+1)). ${OPTS[$i]} (default)${NC}"
        else
            echo "  $((i+1)). ${OPTS[$i]}"
        fi
    done
    echo -ne "${YELLOW}Select [1-${#OPTS[@]}]: ${NC}"
    read -r input < /dev/tty

    # Validate and sanitize input
    if [ -z "$input" ]; then
        # Empty input - use default
        printf -v "$var_name" '%s' "$default"
    elif ! [[ "$input" =~ ^[0-9]+$ ]]; then
        # Not a number - use default
        printf -v "$var_name" '%s' "$default"
    elif [ "$input" -lt 1 ] || [ "$input" -gt "${#OPTS[@]}" ]; then
        # Out of range - use default
        printf -v "$var_name" '%s' "$default"
    else
        # Valid selection
        local idx=$((input - 1))
        printf -v "$var_name" '%s' "${OPTS[$idx]}"
    fi
}

ask_select_mandatory() {
    local prompt="$1"
    local options="$2"
    local var_name="$3"

    while true; do
        echo -e "${YELLOW}${prompt}${NC}"
        IFS='|' read -ra OPTS <<< "$options"
        for i in "${!OPTS[@]}"; do
            echo "  $((i+1)). ${OPTS[$i]}"
        done
        echo -ne "${YELLOW}Select [1-${#OPTS[@]}] (REQUIRED): ${NC}"
        read -r input < /dev/tty

        # Validate input
        if [ -z "$input" ]; then
            echo -e "${RED}Selection is required. Please enter a number.${NC}\n"
            continue
        elif ! [[ "$input" =~ ^[0-9]+$ ]]; then
            echo -e "${RED}Invalid input. Please enter a number between 1 and ${#OPTS[@]}.${NC}\n"
            continue
        elif [ "$input" -lt 1 ] || [ "$input" -gt "${#OPTS[@]}" ]; then
            echo -e "${RED}Out of range. Please select between 1 and ${#OPTS[@]}.${NC}\n"
            continue
        else
            # Valid selection
            local idx=$((input - 1))
            printf -v "$var_name" '%s' "${OPTS[$idx]}"
            break
        fi
    done
}

# Helper function to parse YAML config and populate variables
parse_config_yml() {
    local config_file="$1"

    if [ ! -f "$config_file" ]; then
        echo -e "${RED}Error: Config file not found: $config_file${NC}"
        exit 1
    fi

    # Parse project section (use flag-based approach to extract section content)
    PROJECT_NAME=$(awk '/^project:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  name:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    PROJECT_DESCRIPTION=$(awk '/^project:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  description:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    LANGUAGE=$(awk '/^project:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  language:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    FRAMEWORK=$(awk '/^project:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  framework:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse testing section
    TEST_FRAMEWORK=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  framework:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    TEST_COMMAND=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  test_command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    COVERAGE_COMMAND=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  coverage_command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    COVERAGE_REQUIREMENT=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  required_coverage:/{print}' "$config_file" | sed 's/.*: //')
    TDD_REQUIRED=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  tdd_required:/{print}' "$config_file" | sed 's/.*: //')
    TEST_DIR=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  test_directory:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    TEST_PATTERN=$(awk '/^testing:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  test_file_pattern:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse quality section
    LINTER=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  linter:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    LINT_COMMAND=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  lint_command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    FORMATTER=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  formatter:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    FORMAT_COMMAND=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  format_command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    TYPE_CHECKER=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  type_checker:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    TYPE_CHECK_COMMAND=$(awk '/^quality:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  type_check_command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse build section
    BUILD_REQUIRED=$(awk '/^build:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  required:/{print}' "$config_file" | sed 's/.*: //')
    BUILD_COMMAND=$(awk '/^build:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  command:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse architecture section - extract layer paths
    DOMAIN_PATH=$(awk '/layers:/,/^[^ ]/ {if (/name: "domain"/) {getline; if (/path:/) print}}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    APPLICATION_PATH=$(awk '/layers:/,/^[^ ]/ {if (/name: "application"/) {getline; if (/path:/) print}}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    INFRASTRUCTURE_PATH=$(awk '/layers:/,/^[^ ]/ {if (/name: "infrastructure"/) {getline; if (/path:/) print}}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    PRESENTATION_PATH=$(awk '/layers:/,/^[^ ]/ {if (/name: "presentation"/) {getline; if (/path:/) print}}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    DI_PATH=$(awk '/layers:/,/^[^ ]/ {if (/name: "di"/) {getline; if (/path:/) print}}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse conventions section
    CLASS_FILE_CONVENTION=$(awk '/^conventions:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  class_files:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    FUNCTION_CONVENTION=$(awk '/^conventions:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  functions:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    VARIABLE_CONVENTION=$(awk '/^conventions:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  variables:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    CONSTANT_CONVENTION=$(awk '/^conventions:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  constants:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')
    USE_CASE_PATTERN=$(awk '/^conventions:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  use_case_pattern:/{print}' "$config_file" | sed 's/.*: "\(.*\)"/\1/' | sed 's/.*: \(.*\)/\1/' | tr -d '"')

    # Parse tracking section
    TRACKING_ENABLED=$(awk '/^tracking:/{f=1;next}/^[a-z_]+:/{f=0}f&&/^  enabled:/{print}' "$config_file" | sed 's/.*: //')
}

# Helper function to process templates with variable substitution
process_template() {
    local template_file="$1"
    local output_file="$2"

    if [ ! -f "$template_file" ]; then
        echo -e "${RED}Error: Template file not found: $template_file${NC}"
        exit 1
    fi

    # Export all variables so they're available for envsubst
    export PROJECT_NAME LANGUAGE FRAMEWORK TEST_FRAMEWORK COVERAGE_REQUIREMENT
    export TEST_COMMAND COVERAGE_COMMAND DOMAIN_PATH APPLICATION_PATH
    export INFRASTRUCTURE_PATH PRESENTATION_PATH DI_PATH LINT_COMMAND
    export FORMAT_COMMAND BUILD_COMMAND TDD_REQUIRED EXAMPLE_CLASS
    export EXAMPLE_FUNCTION EXAMPLE_TEST EXAMPLE_IMPORT CLASS_FILE_CONVENTION
    export FUNCTION_CONVENTION VARIABLE_CONVENTION CONSTANT_CONVENTION
    export USE_CASE_PATTERN TEST_DIR TEST_PATTERN TRACKING_ENABLED
    export TYPE_CHECKER TYPE_CHECK_COMMAND BUILD_REQUIRED
    export TYPE_CHECK_COMMAND_SECTION BUILD_COMMAND_SECTION
    export TYPE_CHECK_CHECKLIST TEST_EXAMPLES
    export CLAUDE_CODE_OPTIMIZATIONS
    # Language-specific architecture validation variables
    export FILE_EXTENSION TEST_FILE_EXTENSION SOURCE_DIR
    export IMPORT_PATTERN IMPORT_FROM_PATTERN FIND_FILES_PATTERN
    export LANGUAGE_LOWER

    # Use envsubst to substitute variables and write to output
    envsubst < "$template_file" > "$output_file"
}

# Check for existing installation FIRST
CONFIG_FILE="$TARGET_DIR/.workflow/config.yml"
AGENTS_FILE="$TARGET_DIR/AGENTS.md"
CLAUDE_FILE="$TARGET_DIR/CLAUDE.md"

IS_UPDATE="false"
QUICK_UPDATE="false"

if [ -f "$CONFIG_FILE" ]; then
    IS_UPDATE="true"

    echo -e "\n${YELLOW}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                                                           ║${NC}"
    echo -e "${YELLOW}║  Existing Installation Detected                          ║${NC}"
    echo -e "${YELLOW}║                                                           ║${NC}"
    echo -e "${YELLOW}╚═══════════════════════════════════════════════════════════╝${NC}\n"

    echo -e "${BLUE}Found existing files:${NC}"
    [ -f "$CONFIG_FILE" ] && echo -e "  • .workflow/config.yml"
    [ -f "$AGENTS_FILE" ] && echo -e "  • AGENTS.md"
    [ -f "$CLAUDE_FILE" ] && echo -e "  • CLAUDE.md"

    echo -e "\n${BLUE}Update options:${NC}"
    echo -e "  ${GREEN}1. Quick Update (default)${NC} - Update playbooks & templates only (keeps all settings)"
    echo -e "  2. Full Reconfigure - Re-answer all configuration questions"
    echo -e "  3. Cancel"
    echo -ne "\n${YELLOW}Select [1-3] (default: 1): ${NC}"
    read -r update_choice < /dev/tty

    case "$update_choice" in
        1|"")
            QUICK_UPDATE="true"
            echo -e "${GREEN}✓ Quick update mode${NC}\n"
            ;;
        2)
            QUICK_UPDATE="false"
            echo -e "${BLUE}Starting full reconfiguration...${NC}\n"
            ;;
        3)
            echo -e "${YELLOW}Update cancelled${NC}"
            exit 0
            ;;
        *)
            QUICK_UPDATE="true"
            echo -e "${GREEN}✓ Quick update mode (default)${NC}\n"
            ;;
    esac
fi

# If quick update, skip all questions
if [ "$QUICK_UPDATE" = "true" ]; then
    echo -e "${BLUE}Quick update mode - reading existing configuration...${NC}"

    # Parse existing config.yml to populate all variables
    parse_config_yml "$CONFIG_FILE"

    # Detect IS_CLAUDE_CODE from existing config.yml
    if [ -f "$CONFIG_FILE" ] && grep -q "is_claude_code: true" "$CONFIG_FILE"; then
        IS_CLAUDE_CODE="true"
    else
        IS_CLAUDE_CODE="false"
    fi

    # Derive language-specific variables based on parsed LANGUAGE
    LANGUAGE_LOWER=$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')

    case "$LANGUAGE" in
        "TypeScript")
            FILE_EXTENSION=".ts"
            TEST_FILE_EXTENSION=".test.ts"
            SOURCE_DIR="src"
            IMPORT_PATTERN="^import"
            IMPORT_FROM_PATTERN="^import.*from.*'\\.\\."
            FIND_FILES_PATTERN="*.ts"
            EXAMPLE_IMPORT="import { User } from '../domain/User'"
            EXAMPLE_CLASS="class User {"
            EXAMPLE_FUNCTION="function add(a: number, b: number): number {"
            ;;
        "Python")
            FILE_EXTENSION=".py"
            TEST_FILE_EXTENSION="_test.py"
            SOURCE_DIR="src"
            IMPORT_PATTERN="^(import|from)"
            IMPORT_FROM_PATTERN="^(import|from).*\\.\\."
            FIND_FILES_PATTERN="*.py"
            EXAMPLE_IMPORT="from ..domain.user import User"
            EXAMPLE_CLASS="class User:"
            EXAMPLE_FUNCTION="def add(a: int, b: int) -> int:"
            ;;
        "Java")
            FILE_EXTENSION=".java"
            TEST_FILE_EXTENSION="Test.java"
            SOURCE_DIR="src/main/java"
            IMPORT_PATTERN="^import"
            IMPORT_FROM_PATTERN="^import"
            FIND_FILES_PATTERN="*.java"
            EXAMPLE_IMPORT="import com.example.domain.User;"
            EXAMPLE_CLASS="public class User {"
            EXAMPLE_FUNCTION="public int add(int a, int b) {"
            ;;
        "Go")
            FILE_EXTENSION=".go"
            TEST_FILE_EXTENSION="_test.go"
            SOURCE_DIR="."
            IMPORT_PATTERN="^import"
            IMPORT_FROM_PATTERN="^import.*\"\\.\\."
            FIND_FILES_PATTERN="*.go"
            EXAMPLE_IMPORT="import \"../domain\""
            EXAMPLE_CLASS="type User struct {"
            EXAMPLE_FUNCTION="func Add(a int, b int) int {"
            ;;
        "Rust")
            FILE_EXTENSION=".rs"
            TEST_FILE_EXTENSION=".rs"
            SOURCE_DIR="src"
            IMPORT_PATTERN="^use"
            IMPORT_FROM_PATTERN="^use.*super::"
            FIND_FILES_PATTERN="*.rs"
            EXAMPLE_IMPORT="use super::User;"
            EXAMPLE_CLASS="struct User {"
            EXAMPLE_FUNCTION="fn add(a: i32, b: i32) -> i32 {"
            ;;
        "C#")
            FILE_EXTENSION=".cs"
            TEST_FILE_EXTENSION="Tests.cs"
            SOURCE_DIR="src"
            IMPORT_PATTERN="^using"
            IMPORT_FROM_PATTERN="^using"
            FIND_FILES_PATTERN="*.cs"
            EXAMPLE_IMPORT="using Domain;"
            EXAMPLE_CLASS="public class User {"
            EXAMPLE_FUNCTION="public int Add(int a, int b) {"
            ;;
        *)
            FILE_EXTENSION=".${LANGUAGE_LOWER}"
            TEST_FILE_EXTENSION="_test.${LANGUAGE_LOWER}"
            SOURCE_DIR="src"
            IMPORT_PATTERN="^import"
            IMPORT_FROM_PATTERN="^import.*\\.\\."
            FIND_FILES_PATTERN="*.${LANGUAGE_LOWER}"
            EXAMPLE_IMPORT="import User"
            EXAMPLE_CLASS="class User"
            EXAMPLE_FUNCTION="function add(a, b)"
            ;;
    esac

    # Set language-specific code examples
    case "$LANGUAGE" in
        "TypeScript")
            EXAMPLE_CLASS="User"
            EXAMPLE_FUNCTION="getUserById"
            EXAMPLE_TEST="User.test.ts"
            EXAMPLE_IMPORT="import { User } from './User'"
            ;;
        "Python")
            EXAMPLE_CLASS="User"
            EXAMPLE_FUNCTION="get_user_by_id"
            EXAMPLE_TEST="test_user.py"
            EXAMPLE_IMPORT="from user import User"
            ;;
        "Java")
            EXAMPLE_CLASS="User"
            EXAMPLE_FUNCTION="getUserById"
            EXAMPLE_TEST="UserTest.java"
            EXAMPLE_IMPORT="import com.example.User;"
            ;;
        "Go")
            EXAMPLE_CLASS="User"
            EXAMPLE_FUNCTION="GetUserByID"
            EXAMPLE_TEST="user_test.go"
            EXAMPLE_IMPORT="import \"example.com/domain/user\""
            ;;
        *)
            EXAMPLE_CLASS="User"
            EXAMPLE_FUNCTION="getUser"
            EXAMPLE_TEST="user.test"
            EXAMPLE_IMPORT="import User"
            ;;
    esac

    # Build conditional template sections
    if [ "$TYPE_CHECKER" != "null" ]; then
        TYPE_CHECK_COMMAND_SECTION="$TYPE_CHECK_COMMAND        # Run type checker"
        TYPE_CHECK_CHECKLIST="- [ ] **Type Checking**: Zero type errors (\`$TYPE_CHECK_COMMAND\`)"
    else
        TYPE_CHECK_COMMAND_SECTION=""
        TYPE_CHECK_CHECKLIST=""
    fi

    if [ "$BUILD_REQUIRED" = "true" ]; then
        BUILD_COMMAND_SECTION="
# Build
$BUILD_COMMAND             # Build the project"
    else
        BUILD_COMMAND_SECTION=""
    fi

    # Test examples based on language (use printf to avoid shell parsing issues)
    case "$LANGUAGE" in
        "TypeScript"|"JavaScript")
            TEST_EXAMPLES=$(printf '%s\n' "\`\`\`typescript" "describe('${EXAMPLE_CLASS}', () => {" "  it('should return user when valid id provided', () => {" "    // Arrange-Act-Assert" "  })" "" "  it('should throw error when user not found', () => {" "    // Arrange-Act-Assert" "  })" "})" "\`\`\`")
            ;;
        "Python")
            TEST_EXAMPLES=$(printf '%s\n' "\`\`\`python" "class Test${EXAMPLE_CLASS}:" "    def test_should_return_user_when_valid_id_provided(self):" "        # Arrange-Act-Assert" "        pass" "" "    def test_should_raise_error_when_user_not_found(self):" "        # Arrange-Act-Assert" "        pass" "\`\`\`")
            ;;
        "Java")
            TEST_EXAMPLES=$(printf '%s\n' "\`\`\`java" "class ${EXAMPLE_CLASS}Test {" "    @Test" "    void shouldReturnUserWhenValidIdProvided() {" "        // Arrange-Act-Assert" "    }" "" "    @Test" "    void shouldThrowExceptionWhenUserNotFound() {" "        // Arrange-Act-Assert" "    }" "}" "\`\`\`")
            ;;
        "Go")
            TEST_EXAMPLES=$(printf '%s\n' "\`\`\`go" "func Test${EXAMPLE_CLASS}_ShouldReturnUserWhenValidIdProvided(t *testing.T) {" "    // Arrange-Act-Assert" "}" "" "func Test${EXAMPLE_CLASS}_ShouldReturnErrorWhenUserNotFound(t *testing.T) {" "    // Arrange-Act-Assert" "}" "\`\`\`")
            ;;
        *)
            TEST_EXAMPLES=""
            ;;
    esac

    # Claude Code optimizations section
    if [ "$IS_CLAUDE_CODE" = "true" ]; then
        CLAUDE_CODE_OPTIMIZATIONS=$(envsubst < "$SCRIPT_DIR/templates/instructions/CLAUDE_CODE_OPTIMIZATIONS.md.template")
    else
        CLAUDE_CODE_OPTIMIZATIONS=""
    fi

    echo -e "${GREEN}✓ Loaded configuration from existing config.yml${NC}"
    echo -e ""
    echo -e "${BLUE}Quick update mode:${NC}"
    echo -e "  • Updating playbooks, templates, and instruction files"
    if [ "$IS_CLAUDE_CODE" = "true" ]; then
        echo -e "  • Updating .claude/agents/ subagents"
    fi
    echo -e "  • Keeping existing config.yml and USER_INSTRUCTIONS.md"
    echo -e ""

    # Set flags - only keep config in quick update
    # AGENTS.md, CLAUDE.md, .workflow/ instructions, and .claude/agents/ are always updated (auto-generated)
    OVERWRITE_CONFIG="false"
fi

# Only ask configuration questions if not doing quick update
if [ "$QUICK_UPDATE" = "false" ]; then

# If this is an update (full reconfigure), load existing values as defaults
if [ "$IS_UPDATE" = "true" ]; then
    echo -e "${BLUE}Full reconfigure mode - loading current values as defaults...${NC}"
    parse_config_yml "$CONFIG_FILE"
    echo -e "${GREEN}✓ Loaded current configuration${NC}\n"

    # Set defaults to current values
    PROJECT_NAME_DEFAULT="$PROJECT_NAME"
    PROJECT_DESCRIPTION_DEFAULT="$PROJECT_DESCRIPTION"
    LANGUAGE_DEFAULT="$LANGUAGE"
    FRAMEWORK_DEFAULT="$FRAMEWORK"
    TEST_FRAMEWORK_DEFAULT="$TEST_FRAMEWORK"
    TEST_COMMAND_DEFAULT="$TEST_COMMAND"
    COVERAGE_COMMAND_DEFAULT="$COVERAGE_COMMAND"
    COVERAGE_REQUIREMENT_DEFAULT="$COVERAGE_REQUIREMENT"
    TDD_REQUIRED_DEFAULT="$TDD_REQUIRED"
    TEST_DIR_DEFAULT="$TEST_DIR"
    TEST_PATTERN_DEFAULT="$TEST_PATTERN"
    LINTER_DEFAULT="$LINTER"
    LINT_COMMAND_DEFAULT="$LINT_COMMAND"
    FORMATTER_DEFAULT="$FORMATTER"
    FORMAT_COMMAND_DEFAULT="$FORMAT_COMMAND"
    TYPE_CHECKER_DEFAULT="$TYPE_CHECKER"
    TYPE_CHECK_COMMAND_DEFAULT="$TYPE_CHECK_COMMAND"
    BUILD_REQUIRED_DEFAULT="$BUILD_REQUIRED"
    BUILD_COMMAND_DEFAULT="$BUILD_COMMAND"
    DOMAIN_PATH_DEFAULT="$DOMAIN_PATH"
    APPLICATION_PATH_DEFAULT="$APPLICATION_PATH"
    INFRASTRUCTURE_PATH_DEFAULT="$INFRASTRUCTURE_PATH"
    PRESENTATION_PATH_DEFAULT="$PRESENTATION_PATH"
    DI_PATH_DEFAULT="$DI_PATH"
    CLASS_FILE_CONVENTION_DEFAULT="$CLASS_FILE_CONVENTION"
    FUNCTION_CONVENTION_DEFAULT="$FUNCTION_CONVENTION"
    VARIABLE_CONVENTION_DEFAULT="$VARIABLE_CONVENTION"
    CONSTANT_CONVENTION_DEFAULT="$CONSTANT_CONVENTION"
    USE_CASE_PATTERN_DEFAULT="$USE_CASE_PATTERN"
    TRACKING_ENABLED_DEFAULT="$TRACKING_ENABLED"
else
    # Fresh install - use hardcoded defaults
    PROJECT_NAME_DEFAULT="My Project"
    PROJECT_DESCRIPTION_DEFAULT="A sample project"
    LANGUAGE_DEFAULT="TypeScript"
    FRAMEWORK_DEFAULT="Express.js"
    COVERAGE_REQUIREMENT_DEFAULT="100"
    TDD_REQUIRED_DEFAULT="true"
    DOMAIN_PATH_DEFAULT="src/domain"
    APPLICATION_PATH_DEFAULT="src/application"
    INFRASTRUCTURE_PATH_DEFAULT="src/infrastructure"
    PRESENTATION_PATH_DEFAULT="src/presentation"
    DI_PATH_DEFAULT="src/di"
    CLASS_FILE_CONVENTION_DEFAULT="PascalCase"
    USE_CASE_PATTERN_DEFAULT="VerbNoun"
    TRACKING_ENABLED_DEFAULT="true"
    BUILD_REQUIRED_DEFAULT="true"
fi

echo -e "\n${GREEN}=== Project Information ===${NC}\n"

ask "Project name" "$PROJECT_NAME_DEFAULT" PROJECT_NAME
ask "Project description" "$PROJECT_DESCRIPTION_DEFAULT" PROJECT_DESCRIPTION

ask_select "Programming language" "TypeScript|Python|Java|Go|Rust|C#|Other" "$LANGUAGE_DEFAULT" LANGUAGE
ask "Framework (e.g., Express.js, FastAPI, Spring Boot)" "$FRAMEWORK_DEFAULT" FRAMEWORK

echo -e "\n${GREEN}=== Testing Configuration ===${NC}\n"

# Set defaults based on language (only if not loaded from existing config)
if [ "$IS_UPDATE" != "true" ] || [ -z "$TEST_FRAMEWORK_DEFAULT" ]; then
    case "$LANGUAGE" in
        "TypeScript")
            TEST_FRAMEWORK_DEFAULT="${TEST_FRAMEWORK_DEFAULT:-Jest}"
            TEST_COMMAND_DEFAULT="${TEST_COMMAND_DEFAULT:-npm test}"
            COVERAGE_COMMAND_DEFAULT="${COVERAGE_COMMAND_DEFAULT:-npm test -- --coverage}"
            TEST_DIR_DEFAULT="${TEST_DIR_DEFAULT:-tests/}"
            TEST_PATTERN_DEFAULT="${TEST_PATTERN_DEFAULT:-*.test.ts}"
            ;;
        "Python")
            TEST_FRAMEWORK_DEFAULT="${TEST_FRAMEWORK_DEFAULT:-pytest}"
            TEST_COMMAND_DEFAULT="${TEST_COMMAND_DEFAULT:-pytest}"
            COVERAGE_COMMAND_DEFAULT="${COVERAGE_COMMAND_DEFAULT:-pytest --cov}"
            TEST_DIR_DEFAULT="${TEST_DIR_DEFAULT:-tests/}"
            TEST_PATTERN_DEFAULT="${TEST_PATTERN_DEFAULT:-test_*.py}"
            ;;
        "Java")
            TEST_FRAMEWORK_DEFAULT="${TEST_FRAMEWORK_DEFAULT:-JUnit}"
            TEST_COMMAND_DEFAULT="${TEST_COMMAND_DEFAULT:-mvn test}"
            COVERAGE_COMMAND_DEFAULT="${COVERAGE_COMMAND_DEFAULT:-mvn test jacoco:report}"
            TEST_DIR_DEFAULT="${TEST_DIR_DEFAULT:-src/test/}"
            TEST_PATTERN_DEFAULT="${TEST_PATTERN_DEFAULT:-*Test.java}"
            ;;
        "Go")
            TEST_FRAMEWORK_DEFAULT="${TEST_FRAMEWORK_DEFAULT:-go test}"
            TEST_COMMAND_DEFAULT="${TEST_COMMAND_DEFAULT:-go test ./...}"
            COVERAGE_COMMAND_DEFAULT="${COVERAGE_COMMAND_DEFAULT:-go test -cover ./...}"
            TEST_DIR_DEFAULT="${TEST_DIR_DEFAULT:-./}"
            TEST_PATTERN_DEFAULT="${TEST_PATTERN_DEFAULT:-*_test.go}"
            ;;
        *)
            TEST_FRAMEWORK_DEFAULT="${TEST_FRAMEWORK_DEFAULT:-}"
            TEST_COMMAND_DEFAULT="${TEST_COMMAND_DEFAULT:-}"
            COVERAGE_COMMAND_DEFAULT="${COVERAGE_COMMAND_DEFAULT:-}"
            TEST_DIR_DEFAULT="${TEST_DIR_DEFAULT:-tests/}"
            TEST_PATTERN_DEFAULT="${TEST_PATTERN_DEFAULT:-*.test.*}"
            ;;
    esac
fi

ask "Test framework" "$TEST_FRAMEWORK_DEFAULT" TEST_FRAMEWORK
ask "Test command" "$TEST_COMMAND_DEFAULT" TEST_COMMAND
ask "Coverage command" "$COVERAGE_COMMAND_DEFAULT" COVERAGE_COMMAND
ask "Required test coverage (%)" "${COVERAGE_REQUIREMENT_DEFAULT:-100}" COVERAGE_REQUIREMENT
ask_bool "Enforce coverage requirement" "true" ENFORCE_COVERAGE
ask_bool "Require TDD (tests before code)" "${TDD_REQUIRED_DEFAULT:-true}" TDD_REQUIRED
ask "Test directory" "$TEST_DIR_DEFAULT" TEST_DIR
ask "Test file pattern" "$TEST_PATTERN_DEFAULT" TEST_PATTERN

# Language-specific file patterns and architecture validation variables
# These are used for architecture-check playbook and other language-specific templates
# Also set lowercase language name for code block syntax highlighting
LANGUAGE_LOWER=$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')

case "$LANGUAGE" in
    "TypeScript")
        FILE_EXTENSION=".ts"
        TEST_FILE_EXTENSION=".test.ts"
        SOURCE_DIR="src"
        IMPORT_PATTERN="^import"
        IMPORT_FROM_PATTERN="^import.*from.*'\\.\\."
        FIND_FILES_PATTERN="*.ts"
        EXAMPLE_IMPORT="import { User } from '../domain/User'"
        EXAMPLE_CLASS="class User {"
        EXAMPLE_FUNCTION="function add(a: number, b: number): number {"
        ;;
    "Python")
        FILE_EXTENSION=".py"
        TEST_FILE_EXTENSION="_test.py"
        SOURCE_DIR="src"
        IMPORT_PATTERN="^(import|from)"
        IMPORT_FROM_PATTERN="^(import|from).*\\.\\."
        FIND_FILES_PATTERN="*.py"
        EXAMPLE_IMPORT="from ..domain.user import User"
        EXAMPLE_CLASS="class User:"
        EXAMPLE_FUNCTION="def add(a: int, b: int) -> int:"
        ;;
    "Java")
        FILE_EXTENSION=".java"
        TEST_FILE_EXTENSION="Test.java"
        SOURCE_DIR="src/main/java"
        IMPORT_PATTERN="^import"
        IMPORT_FROM_PATTERN="^import"
        FIND_FILES_PATTERN="*.java"
        EXAMPLE_IMPORT="import com.example.domain.User;"
        EXAMPLE_CLASS="public class User {"
        EXAMPLE_FUNCTION="public int add(int a, int b) {"
        ;;
    "Go")
        FILE_EXTENSION=".go"
        TEST_FILE_EXTENSION="_test.go"
        SOURCE_DIR="."
        IMPORT_PATTERN="^import"
        IMPORT_FROM_PATTERN="^import.*\"\\.\\."
        FIND_FILES_PATTERN="*.go"
        EXAMPLE_IMPORT="import \"../domain\""
        EXAMPLE_CLASS="type User struct {"
        EXAMPLE_FUNCTION="func Add(a int, b int) int {"
        ;;
    "Rust")
        FILE_EXTENSION=".rs"
        TEST_FILE_EXTENSION=".rs"
        SOURCE_DIR="src"
        IMPORT_PATTERN="^use"
        IMPORT_FROM_PATTERN="^use.*super::"
        FIND_FILES_PATTERN="*.rs"
        EXAMPLE_IMPORT="use super::User;"
        EXAMPLE_CLASS="struct User {"
        EXAMPLE_FUNCTION="fn add(a: i32, b: i32) -> i32 {"
        ;;
    "C#")
        FILE_EXTENSION=".cs"
        TEST_FILE_EXTENSION="Tests.cs"
        SOURCE_DIR="src"
        IMPORT_PATTERN="^using"
        IMPORT_FROM_PATTERN="^using"
        FIND_FILES_PATTERN="*.cs"
        EXAMPLE_IMPORT="using Domain;"
        EXAMPLE_CLASS="public class User {"
        EXAMPLE_FUNCTION="public int Add(int a, int b) {"
        ;;
    *)
        # Generic defaults for other languages
        FILE_EXTENSION=".${LANGUAGE_LOWER}"
        TEST_FILE_EXTENSION="_test.${LANGUAGE_LOWER}"
        SOURCE_DIR="src"
        IMPORT_PATTERN="^import"
        IMPORT_FROM_PATTERN="^import.*\\.\\."
        FIND_FILES_PATTERN="*.${LANGUAGE_LOWER}"
        EXAMPLE_IMPORT="import User"
        EXAMPLE_CLASS="class User"
        EXAMPLE_FUNCTION="function add(a, b)"
        ;;
esac

echo -e "\n${GREEN}=== Code Quality Tools ===${NC}\n"

# Set defaults based on language (only if not loaded from existing config)
if [ "$IS_UPDATE" != "true" ] || [ -z "$LINTER_DEFAULT" ]; then
    case "$LANGUAGE" in
        "TypeScript")
            LINTER_DEFAULT="${LINTER_DEFAULT:-eslint}"
            LINT_COMMAND_DEFAULT="${LINT_COMMAND_DEFAULT:-npm run lint}"
            FORMATTER_DEFAULT="${FORMATTER_DEFAULT:-prettier}"
            FORMAT_COMMAND_DEFAULT="${FORMAT_COMMAND_DEFAULT:-npx prettier --check .}"
            TYPE_CHECKER_DEFAULT="${TYPE_CHECKER_DEFAULT:-tsc}"
            TYPE_CHECK_COMMAND_DEFAULT="${TYPE_CHECK_COMMAND_DEFAULT:-npx tsc --noEmit}"
            ;;
        "Python")
            LINTER_DEFAULT="${LINTER_DEFAULT:-pylint}"
            LINT_COMMAND_DEFAULT="${LINT_COMMAND_DEFAULT:-pylint src/}"
            FORMATTER_DEFAULT="${FORMATTER_DEFAULT:-black}"
            FORMAT_COMMAND_DEFAULT="${FORMAT_COMMAND_DEFAULT:-black --check .}"
            TYPE_CHECKER_DEFAULT="${TYPE_CHECKER_DEFAULT:-mypy}"
            TYPE_CHECK_COMMAND_DEFAULT="${TYPE_CHECK_COMMAND_DEFAULT:-mypy src/}"
            ;;
        "Java")
            LINTER_DEFAULT="${LINTER_DEFAULT:-checkstyle}"
            LINT_COMMAND_DEFAULT="${LINT_COMMAND_DEFAULT:-mvn checkstyle:check}"
            FORMATTER_DEFAULT="${FORMATTER_DEFAULT:-google-java-format}"
            FORMAT_COMMAND_DEFAULT="${FORMAT_COMMAND_DEFAULT:-mvn fmt:check}"
            TYPE_CHECKER_DEFAULT="${TYPE_CHECKER_DEFAULT:-null}"
            TYPE_CHECK_COMMAND_DEFAULT="${TYPE_CHECK_COMMAND_DEFAULT:-null}"
            ;;
        "Go")
            LINTER_DEFAULT="${LINTER_DEFAULT:-golangci-lint}"
            LINT_COMMAND_DEFAULT="${LINT_COMMAND_DEFAULT:-golangci-lint run}"
            FORMATTER_DEFAULT="${FORMATTER_DEFAULT:-gofmt}"
            FORMAT_COMMAND_DEFAULT="${FORMAT_COMMAND_DEFAULT:-gofmt -l .}"
            TYPE_CHECKER_DEFAULT="${TYPE_CHECKER_DEFAULT:-null}"
            TYPE_CHECK_COMMAND_DEFAULT="${TYPE_CHECK_COMMAND_DEFAULT:-null}"
            ;;
        *)
            LINTER_DEFAULT="${LINTER_DEFAULT:-}"
            LINT_COMMAND_DEFAULT="${LINT_COMMAND_DEFAULT:-}"
            FORMATTER_DEFAULT="${FORMATTER_DEFAULT:-}"
            FORMAT_COMMAND_DEFAULT="${FORMAT_COMMAND_DEFAULT:-}"
            TYPE_CHECKER_DEFAULT="${TYPE_CHECKER_DEFAULT:-null}"
            TYPE_CHECK_COMMAND_DEFAULT="${TYPE_CHECK_COMMAND_DEFAULT:-null}"
            ;;
    esac
fi

ask "Linter" "$LINTER_DEFAULT" LINTER
ask "Lint command" "$LINT_COMMAND_DEFAULT" LINT_COMMAND
ask "Formatter" "$FORMATTER_DEFAULT" FORMATTER
ask "Format command" "$FORMAT_COMMAND_DEFAULT" FORMAT_COMMAND
ask_bool "Format check only (not fix)" "true" FORMAT_CHECK_ONLY
ask "Type checker (or 'null' for none)" "$TYPE_CHECKER_DEFAULT" TYPE_CHECKER
if [ "$TYPE_CHECKER" != "null" ]; then
    ask "Type check command" "$TYPE_CHECK_COMMAND_DEFAULT" TYPE_CHECK_COMMAND
else
    TYPE_CHECK_COMMAND="null"
fi

echo -e "\n${GREEN}=== Build Configuration ===${NC}\n"

ask_bool "Does project require building?" "${BUILD_REQUIRED_DEFAULT:-true}" BUILD_REQUIRED
if [ "$BUILD_REQUIRED" = "true" ]; then
    # Set defaults based on language (only if not loaded from existing config)
    if [ "$IS_UPDATE" != "true" ] || [ -z "$BUILD_COMMAND_DEFAULT" ]; then
        case "$LANGUAGE" in
            "TypeScript")
                BUILD_COMMAND_DEFAULT="${BUILD_COMMAND_DEFAULT:-npm run build}"
                BUILD_OUTPUT_DIR_DEFAULT="${BUILD_OUTPUT_DIR_DEFAULT:-dist/}"
                ;;
            "Java")
                BUILD_COMMAND_DEFAULT="${BUILD_COMMAND_DEFAULT:-mvn package}"
                BUILD_OUTPUT_DIR_DEFAULT="${BUILD_OUTPUT_DIR_DEFAULT:-target/}"
                ;;
            "Go")
                BUILD_COMMAND_DEFAULT="${BUILD_COMMAND_DEFAULT:-go build}"
                BUILD_OUTPUT_DIR_DEFAULT="${BUILD_OUTPUT_DIR_DEFAULT:-bin/}"
                ;;
            *)
                BUILD_COMMAND_DEFAULT="${BUILD_COMMAND_DEFAULT:-}"
                BUILD_OUTPUT_DIR_DEFAULT="${BUILD_OUTPUT_DIR_DEFAULT:-build/}"
                ;;
        esac
    fi
    ask "Build command" "$BUILD_COMMAND_DEFAULT" BUILD_COMMAND
    ask "Build output directory" "${BUILD_OUTPUT_DIR_DEFAULT:-build/}" BUILD_OUTPUT_DIR
else
    BUILD_COMMAND="null"
    BUILD_OUTPUT_DIR="null"
fi

echo -e "\n${GREEN}=== Architecture Configuration ===${NC}\n"

ask_bool "Enforce Clean Architecture validation" "true" ARCHITECTURE_ENFORCE

echo -e "\nDefine layer paths for Clean Architecture:"
ask "  Domain layer path" "${DOMAIN_PATH_DEFAULT:-src/domain}" DOMAIN_PATH
ask "  Application layer path" "${APPLICATION_PATH_DEFAULT:-src/application}" APPLICATION_PATH
ask "  Infrastructure layer path" "${INFRASTRUCTURE_PATH_DEFAULT:-src/infrastructure}" INFRASTRUCTURE_PATH
ask "  Presentation layer path" "${PRESENTATION_PATH_DEFAULT:-src/presentation}" PRESENTATION_PATH
ask "  DI/Container layer path" "${DI_PATH_DEFAULT:-src/di}" DI_PATH

echo -e "\n${GREEN}=== Git & Commit Configuration ===${NC}\n"

ask_bool "Run tests before commit" "true" RUN_TESTS_PRE_COMMIT
ask_bool "Run linting before commit" "true" RUN_LINTING_PRE_COMMIT
ask_bool "Run architecture validation before commit" "true" RUN_ARCHITECTURE_PRE_COMMIT

echo -e "\n${GREEN}=== Naming Conventions ===${NC}\n"

ask_select "Class file naming" "PascalCase|lowercase" "${CLASS_FILE_CONVENTION_DEFAULT:-PascalCase}" CLASS_FILE_CONVENTION
ask_select "Interface prefix" "I|none" "none" INTERFACE_PREFIX

# Set defaults based on language (only if not loaded from existing config)
if [ "$IS_UPDATE" != "true" ] || [ -z "$FUNCTION_CONVENTION_DEFAULT" ]; then
    case "$LANGUAGE" in
        "TypeScript"|"Java"|"C#")
            FUNCTION_CONVENTION_DEFAULT="${FUNCTION_CONVENTION_DEFAULT:-camelCase}"
            VARIABLE_CONVENTION_DEFAULT="${VARIABLE_CONVENTION_DEFAULT:-camelCase}"
            CONSTANT_CONVENTION_DEFAULT="${CONSTANT_CONVENTION_DEFAULT:-UPPER_SNAKE_CASE}"
            ;;
        "Python"|"Rust")
            FUNCTION_CONVENTION_DEFAULT="${FUNCTION_CONVENTION_DEFAULT:-snake_case}"
            VARIABLE_CONVENTION_DEFAULT="${VARIABLE_CONVENTION_DEFAULT:-snake_case}"
            CONSTANT_CONVENTION_DEFAULT="${CONSTANT_CONVENTION_DEFAULT:-UPPER_SNAKE_CASE}"
            ;;
        "Go")
            FUNCTION_CONVENTION_DEFAULT="${FUNCTION_CONVENTION_DEFAULT:-PascalCase}"
            VARIABLE_CONVENTION_DEFAULT="${VARIABLE_CONVENTION_DEFAULT:-camelCase}"
            CONSTANT_CONVENTION_DEFAULT="${CONSTANT_CONVENTION_DEFAULT:-PascalCase}"
            ;;
        *)
            FUNCTION_CONVENTION_DEFAULT="${FUNCTION_CONVENTION_DEFAULT:-camelCase}"
            VARIABLE_CONVENTION_DEFAULT="${VARIABLE_CONVENTION_DEFAULT:-camelCase}"
            CONSTANT_CONVENTION_DEFAULT="${CONSTANT_CONVENTION_DEFAULT:-UPPER_SNAKE_CASE}"
            ;;
    esac
fi

ask_select "Function naming" "camelCase|snake_case|PascalCase" "$FUNCTION_CONVENTION_DEFAULT" FUNCTION_CONVENTION
ask_select "Variable naming" "camelCase|snake_case" "$VARIABLE_CONVENTION_DEFAULT" VARIABLE_CONVENTION
ask_select "Constant naming" "UPPER_SNAKE_CASE|camelCase|PascalCase" "$CONSTANT_CONVENTION_DEFAULT" CONSTANT_CONVENTION
ask "Use case naming pattern" "${USE_CASE_PATTERN_DEFAULT:-VerbNoun}" USE_CASE_PATTERN

echo -e "\n${GREEN}=== Task Tracking ===${NC}\n"

ask_bool "Enable .spec/ task tracking" "${TRACKING_ENABLED_DEFAULT:-true}" TRACKING_ENABLED

echo -e "\n${GREEN}=== AI Assistant Configuration ===${NC}\n"

# MANDATORY: Primary AI assistant selection (no default - must explicitly select)
ask_select_mandatory "Primary AI assistant for coding" "Claude Code|Claude (Web/API)|ChatGPT|Gemini|Codex|Cursor|Other" PRIMARY_AI

# Determine if using Claude Code specifically
if [ "$PRIMARY_AI" = "Claude Code" ]; then
    IS_CLAUDE_CODE="true"
    echo -e "${BLUE}✓ Claude Code detected - will configure with parallel execution and sub-agents${NC}"
else
    IS_CLAUDE_CODE="false"
fi

ask_bool "Verbose reporting (detailed progress)" "true" VERBOSE_REPORTING
ask_bool "Use emoji indicators" "true" EMOJI_INDICATORS

# End of configuration questions block
fi

# Set overwrite flags for full reconfigure mode
if [ "$QUICK_UPDATE" = "false" ] && [ "$IS_UPDATE" = "true" ]; then
    # In full reconfigure mode, ask what to overwrite
    echo ""

    OVERWRITE_CONFIG="true"
    if [ -f "$CONFIG_FILE" ]; then
        ask_bool "Overwrite existing .workflow/config.yml with new config?" "false" OVERWRITE_CONFIG
    fi

    # Note: AGENTS.md, CLAUDE.md, .workflow/ instructions, and .claude/agents/
    # are always overwritten (auto-generated system files)
elif [ "$QUICK_UPDATE" = "false" ]; then
    # Fresh install - create everything
    OVERWRITE_CONFIG="true"
fi

mkdir -p "$TARGET_DIR/.workflow"

# Generate config.yml
if [ "$OVERWRITE_CONFIG" = "true" ]; then
    echo -e "\n${BLUE}Generating configuration...${NC}"

cat > "$CONFIG_FILE" << EOF
# AI Workflow System Configuration
# Generated: $(date)

system:
  version: "0.5.0-beta"
  config_version: "0.2"

project:
  name: "$PROJECT_NAME"
  description: "$PROJECT_DESCRIPTION"
  language: "$LANGUAGE"
  framework: "$FRAMEWORK"

testing:
  framework: "$TEST_FRAMEWORK"
  test_command: "$TEST_COMMAND"
  coverage_command: "$COVERAGE_COMMAND"
  required_coverage: $COVERAGE_REQUIREMENT
  enforce_coverage: $ENFORCE_COVERAGE
  tdd_required: $TDD_REQUIRED
  test_directory: "$TEST_DIR"
  test_file_pattern: "$TEST_PATTERN"

quality:
  linter: "$LINTER"
  lint_command: "$LINT_COMMAND"
  formatter: "$FORMATTER"
  format_command: "$FORMAT_COMMAND"
  format_check_only: $FORMAT_CHECK_ONLY
  type_checker: "$TYPE_CHECKER"
  type_check_command: "$TYPE_CHECK_COMMAND"

build:
  required: $BUILD_REQUIRED
  command: "$BUILD_COMMAND"
  output_dir: "$BUILD_OUTPUT_DIR"

architecture:
  style: "clean"
  enforce: $ARCHITECTURE_ENFORCE
  layers:
    - name: "domain"
      path: "$DOMAIN_PATH"
      dependencies: []
    - name: "application"
      path: "$APPLICATION_PATH"
      dependencies: ["domain"]
    - name: "infrastructure"
      path: "$INFRASTRUCTURE_PATH"
      dependencies: ["domain", "application"]
    - name: "presentation"
      path: "$PRESENTATION_PATH"
      dependencies: ["domain", "application"]
    - name: "di"
      path: "$DI_PATH"
      dependencies: ["domain", "application", "infrastructure", "presentation"]

git:
  commit_style: "conventional"
  types: ["feat", "fix", "refactor", "test", "docs", "chore"]
  subject_max_length: 50
  body_max_length: 72
  run_tests_pre_commit: $RUN_TESTS_PRE_COMMIT
  run_linting_pre_commit: $RUN_LINTING_PRE_COMMIT
  run_architecture_pre_commit: $RUN_ARCHITECTURE_PRE_COMMIT

conventions:
  class_files: "$CLASS_FILE_CONVENTION"
  interface_prefix: "$INTERFACE_PREFIX"
  classes: "PascalCase"
  functions: "$FUNCTION_CONVENTION"
  variables: "$VARIABLE_CONVENTION"
  constants: "$CONSTANT_CONVENTION"
  use_case_pattern: "$USE_CASE_PATTERN"

tracking:
  enabled: $TRACKING_ENABLED
  directory: ".spec/"
  feature_prefix: "feature-"
  bugfix_prefix: "fix-"
  refactor_prefix: "refactor-"
  overall_status_file: "overall-status.md"

ai:
  primary_assistant: "$PRIMARY_AI"
  is_claude_code: $IS_CLAUDE_CODE
  verbose_reporting: $VERBOSE_REPORTING
  emoji_indicators: $EMOJI_INDICATORS

custom: {}
EOF

    echo -e "${GREEN}✓ Generated: .workflow/config.yml${NC}"
else
    echo -e "${YELLOW}- Skipped: .workflow/config.yml (keeping existing)${NC}"
fi

# Process playbook templates
echo -e "\n${BLUE}Processing playbook templates...${NC}"

mkdir -p "$TARGET_DIR/.workflow/playbooks"
mkdir -p "$TARGET_DIR/.workflow/templates"

# Process all playbook templates with language-specific variable substitution
if [ -d "$SCRIPT_DIR/templates/playbooks" ]; then
    for template in "$SCRIPT_DIR/templates/playbooks/"*.template; do
        if [ -f "$template" ]; then
            filename=$(basename "$template" .template)
            process_template "$template" "$TARGET_DIR/.workflow/playbooks/$filename"
            echo -e "${GREEN}✓ Processed: $filename${NC}"
        fi
    done
fi

# Copy spec file templates
cp -r "$SCRIPT_DIR/templates/"* "$TARGET_DIR/.workflow/templates/"
echo -e "${GREEN}✓ Copied spec templates to .workflow/templates/${NC}"

# Determine language-specific code examples (used for both AGENTS and CLAUDE instructions)
case "$LANGUAGE" in
    "TypeScript")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUserById"
        EXAMPLE_TEST="User.test.ts"
        EXAMPLE_IMPORT="import { User } from './User'"
        ;;
    "Python")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="get_user_by_id"
        EXAMPLE_TEST="test_user.py"
        EXAMPLE_IMPORT="from user import User"
        ;;
    "Java")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUserById"
        EXAMPLE_TEST="UserTest.java"
        EXAMPLE_IMPORT="import com.example.User;"
        ;;
    "Go")
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="GetUserByID"
        EXAMPLE_TEST="user_test.go"
        EXAMPLE_IMPORT="import \"example.com/domain/user\""
        ;;
    *)
        EXAMPLE_CLASS="User"
        EXAMPLE_FUNCTION="getUser"
        EXAMPLE_TEST="user.test"
        EXAMPLE_IMPORT="import User"
        ;;
esac

# Build conditional template sections
# Type check command section
if [ "$TYPE_CHECKER" != "null" ]; then
    TYPE_CHECK_COMMAND_SECTION="$TYPE_CHECK_COMMAND        # Run type checker"
    TYPE_CHECK_CHECKLIST="- [ ] **Type Checking**: Zero type errors (\`$TYPE_CHECK_COMMAND\`)"
else
    TYPE_CHECK_COMMAND_SECTION=""
    TYPE_CHECK_CHECKLIST=""
fi

# Build command section
if [ "$BUILD_REQUIRED" = "true" ]; then
    BUILD_COMMAND_SECTION="
# Build
$BUILD_COMMAND             # Build the project"
else
    BUILD_COMMAND_SECTION=""
fi

# Test examples based on language (use printf to avoid shell parsing issues)
case "$LANGUAGE" in
    "TypeScript"|"JavaScript")
        TEST_EXAMPLES=$(printf '%s\n' "\`\`\`typescript" "describe('${EXAMPLE_CLASS}', () => {" "  it('should return user when valid id provided', () => {" "    // Arrange-Act-Assert" "  })" "" "  it('should throw error when user not found', () => {" "    // Arrange-Act-Assert" "  })" "})" "\`\`\`")
        ;;
    "Python")
        TEST_EXAMPLES=$(printf '%s\n' "\`\`\`python" "class Test${EXAMPLE_CLASS}:" "    def test_should_return_user_when_valid_id_provided(self):" "        # Arrange-Act-Assert" "        pass" "" "    def test_should_raise_error_when_user_not_found(self):" "        # Arrange-Act-Assert" "        pass" "\`\`\`")
        ;;
    "Java")
        TEST_EXAMPLES=$(printf '%s\n' "\`\`\`java" "class ${EXAMPLE_CLASS}Test {" "    @Test" "    void shouldReturnUserWhenValidIdProvided() {" "        // Arrange-Act-Assert" "    }" "" "    @Test" "    void shouldThrowExceptionWhenUserNotFound() {" "        // Arrange-Act-Assert" "    }" "}" "\`\`\`")
        ;;
    "Go")
        TEST_EXAMPLES=$(printf '%s\n' "\`\`\`go" "func Test${EXAMPLE_CLASS}_ShouldReturnUserWhenValidIdProvided(t *testing.T) {" "    // Arrange-Act-Assert" "}" "" "func Test${EXAMPLE_CLASS}_ShouldReturnErrorWhenUserNotFound(t *testing.T) {" "    // Arrange-Act-Assert" "}" "\`\`\`")
        ;;
    *)
        TEST_EXAMPLES=""
        ;;
esac

# Claude Code optimizations section (conditionally included)
if [ "$IS_CLAUDE_CODE" = "true" ]; then
    CLAUDE_CODE_OPTIMIZATIONS=$(envsubst < "$SCRIPT_DIR/templates/instructions/CLAUDE_CODE_OPTIMIZATIONS.md.template")
else
    CLAUDE_CODE_OPTIMIZATIONS=""
fi

# Generate AGENTS_INSTRUCTIONS.md (always - it's an auto-generated system file)
echo -e "\n${BLUE}Generating AGENTS_INSTRUCTIONS.md...${NC}"

process_template "$SCRIPT_DIR/templates/instructions/AGENTS_INSTRUCTIONS.md.template" "$TARGET_DIR/.workflow/AGENTS_INSTRUCTIONS.md"

echo -e "${GREEN}✓ Generated: .workflow/AGENTS_INSTRUCTIONS.md${NC}"

# Generate CLAUDE_INSTRUCTIONS.md (always - it's an auto-generated system file)
echo -e "\n${BLUE}Generating CLAUDE_INSTRUCTIONS.md...${NC}"

process_template "$SCRIPT_DIR/templates/instructions/CLAUDE_INSTRUCTIONS.md.template" "$TARGET_DIR/.workflow/CLAUDE_INSTRUCTIONS.md"

# Create Claude Code subagents if applicable
if [ "$IS_CLAUDE_CODE" = "true" ]; then
    echo -e "\n${BLUE}Creating Claude Code subagents...${NC}"
    
    mkdir -p "$TARGET_DIR/.claude/agents"
    
    # Copy agent templates
    cp "$SCRIPT_DIR/templates/agents/architecture-review.md.template" "$TARGET_DIR/.claude/agents/architecture-review.md"
    cp "$SCRIPT_DIR/templates/agents/lint.md.template" "$TARGET_DIR/.claude/agents/lint.md"
    cp "$SCRIPT_DIR/templates/agents/test.md.template" "$TARGET_DIR/.claude/agents/test.md"
    
    echo -e "${GREEN}✓ Created subagents in .claude/agents/:${NC}"
    echo -e "  ${BLUE}architecture-review.md${NC} - Validate Clean Architecture compliance"
    echo -e "  ${BLUE}lint.md${NC} - Run static analysis and linting"
    echo -e "  ${BLUE}test.md${NC} - Execute test suite with coverage"
fi
echo -e "${GREEN}✓ Generated: .workflow/CLAUDE_INSTRUCTIONS.md${NC}"

# Generate pointer files (AGENTS.md and CLAUDE.md - always auto-generated)
echo -e "\n${BLUE}Generating pointer files...${NC}"


cp "$SCRIPT_DIR/templates/instructions/AGENTS.md.template" "$TARGET_DIR/AGENTS.md"
cp "$SCRIPT_DIR/templates/instructions/CLAUDE.md.template" "$TARGET_DIR/CLAUDE.md"

echo -e "${GREEN}✓ Generated: AGENTS.md (pointer)${NC}"
echo -e "${GREEN}✓ Generated: CLAUDE.md (pointer)${NC}"

# Create USER_INSTRUCTIONS.md if it doesn't exist
if [ ! -f "$TARGET_DIR/USER_INSTRUCTIONS.md" ]; then
    echo -e "\n${BLUE}Creating USER_INSTRUCTIONS.md template...${NC}"


    cp "$SCRIPT_DIR/templates/instructions/USER_INSTRUCTIONS.md.template" "$TARGET_DIR/USER_INSTRUCTIONS.md"

    echo -e "${GREEN}✓ Created: USER_INSTRUCTIONS.md${NC}"
else
    echo -e "${YELLOW}⊘ USER_INSTRUCTIONS.md already exists (keeping existing)${NC}"
fi

# Create .spec/ directory if tracking is enabled
if [ "$TRACKING_ENABLED" = "true" ]; then
    mkdir -p "$TARGET_DIR/.spec"

    # Only create overall-status.md if it doesn't exist
    if [ ! -f "$TARGET_DIR/.spec/overall-status.md" ]; then
        echo -e "\n${BLUE}Creating .spec/ directory...${NC}"

        cat > "$TARGET_DIR/.spec/overall-status.md" << EOF
# $PROJECT_NAME - Overall Status

**Last Updated**: $(date +%Y-%m-%d)

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
- Test Coverage: **0% (target: ${COVERAGE_REQUIREMENT}%)**
- Open Tasks: 0
- Completed Tasks: 0

## Recent Activity
- $(date +%Y-%m-%d): Project initialized with AI Workflow System
EOF

        echo -e "${GREEN}✓ Created .spec/ directory with overall-status.md${NC}"
    else
        echo -e "${YELLOW}⊘ Skipped: .spec/overall-status.md (already exists)${NC}"
    fi
fi

# Create .gitignore entries
echo -e "\n${BLUE}Updating .gitignore...${NC}"

GITIGNORE_FILE="$TARGET_DIR/.gitignore"
if [ ! -f "$GITIGNORE_FILE" ]; then
    touch "$GITIGNORE_FILE"
fi

# Check if entries already exist
if ! grep -q ".workflow/config.yml" "$GITIGNORE_FILE"; then
    echo "" >> "$GITIGNORE_FILE"
    echo "# AI Workflow System" >> "$GITIGNORE_FILE"
    echo "# Note: config.yml is project-specific, commit it!" >> "$GITIGNORE_FILE"
    echo "# Uncomment next line if you want to keep config private:" >> "$GITIGNORE_FILE"
    echo "# .workflow/config.yml" >> "$GITIGNORE_FILE"
    echo -e "${GREEN}✓ Updated .gitignore${NC}"
else
    echo -e "${YELLOW}! .gitignore already contains workflow entries${NC}"
fi

# Summary
echo -e "\n${GREEN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          Setup Complete!                                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${BLUE}Created/Updated files:${NC}"
if [ "$OVERWRITE_CONFIG" = "true" ]; then
    echo "  ✓ .workflow/config.yml                 - Project configuration"
else
    echo "  ⊘ .workflow/config.yml                 - Kept existing"
fi
echo "  ✓ .workflow/playbooks/                 - Workflow playbooks (9 files)"
echo "  ✓ .workflow/templates/                 - Spec file templates"
echo "  ✓ .workflow/AGENTS_INSTRUCTIONS.md     - Full universal AI instructions"
echo "  ✓ .workflow/CLAUDE_INSTRUCTIONS.md     - Full Claude Code instructions"
echo "  ✓ AGENTS.md                            - Pointer to instructions (auto-generated)"
echo "  ✓ CLAUDE.md                            - Pointer to instructions (auto-generated)"
if [ -f "$TARGET_DIR/USER_INSTRUCTIONS.md" ] && [ "$IS_UPDATE" = "false" ]; then
    echo "  ✓ USER_INSTRUCTIONS.md                 - Template for custom instructions"
elif [ -f "$TARGET_DIR/USER_INSTRUCTIONS.md" ]; then
    echo "  ⊘ USER_INSTRUCTIONS.md                 - Kept existing (add your custom instructions here)"
else
    echo "  ✓ USER_INSTRUCTIONS.md                 - Template for custom instructions"
fi
if [ "$IS_CLAUDE_CODE" = "true" ]; then
    echo "  ✓ .claude/agents/                      - Claude Code subagents (3 files)"
fi
if [ "$TRACKING_ENABLED" = "true" ]; then
    SPEC_STATUS_FILE="$TARGET_DIR/.spec/overall-status.md"
    if [ -f "$SPEC_STATUS_FILE" ]; then
        echo "  ⊘ .spec/overall-status.md              - Already exists"
    else
        echo "  ✓ .spec/overall-status.md              - Task tracking dashboard"
    fi
fi

echo -e "\n${BLUE}Next steps:${NC}"
echo "  1. Review .workflow/config.yml and adjust if needed"
echo "  2. Add project-specific instructions to USER_INSTRUCTIONS.md"
echo "  3. Commit the workflow files to your repository"
echo "  4. Share AGENTS.md or CLAUDE.md with your team"
if [ "$IS_CLAUDE_CODE" = "true" ]; then
    echo "  5. View your subagents in Claude Code: /agents"
    echo "  6. Start using workflows:"
else
    echo "  5. Start using workflows:"
fi
echo "     - For implementation: Ask AI to read AGENTS.md or CLAUDE.md"
echo "     - For commits: Ask AI to read .workflow/playbooks/commit.md"

echo -e "\n${BLUE}Documentation:${NC}"
echo "  - System docs: .workflow/README.md"
echo "  - AI instructions: .workflow/AGENTS_INSTRUCTIONS.md or .workflow/CLAUDE_INSTRUCTIONS.md"
echo "  - User instructions: USER_INSTRUCTIONS.md (add your customizations here)"
echo "  - Config reference: .workflow/config.yml"
echo "  - Playbook reference: .workflow/playbooks/"

echo -e "\n${GREEN}Happy coding! 🚀${NC}\n"
