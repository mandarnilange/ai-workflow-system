#!/bin/bash

# AI Workflow System - Remote Installation Script
# Downloads the latest version and runs init.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="https://github.com/mandarnilange/ai-workflow-system"
RAW_URL="https://raw.githubusercontent.com/mandarnilange/ai-workflow-system/main"

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║          AI Workflow System - Remote Install             ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Get target directory (default to current directory)
TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory $TARGET_DIR does not exist${NC}"
    exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo -e "${GREEN}Installing to: $TARGET_DIR${NC}\n"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${BLUE}Downloading AI Workflow System...${NC}"

# Download all necessary files
cd "$TEMP_DIR"

# Create directory structure
mkdir -p templates/playbooks templates/instructions templates/agents examples/typescript-express

# Download core files
echo -e "${YELLOW}Downloading core files...${NC}"
curl -sSL "$RAW_URL/init.sh" > init.sh
curl -sSL "$RAW_URL/config.template.yml" > config.template.yml
curl -sSL "$RAW_URL/README.md" > README.md
curl -sSL "$RAW_URL/LICENSE" > LICENSE

# Download playbook templates
echo -e "${YELLOW}Downloading playbook templates...${NC}"
for playbook in coordinator feature bugfix commit tdd architecture-check reporting-guidelines run-lint run-tests prd-planning; do
    curl -sSL "$RAW_URL/templates/playbooks/${playbook}.md.template" > "templates/playbooks/${playbook}.md.template"
done

# Download instruction templates
echo -e "${YELLOW}Downloading instruction templates...${NC}"
for template in AGENTS_INSTRUCTIONS CLAUDE_INSTRUCTIONS CLAUDE_CODE_OPTIMIZATIONS AGENTS CLAUDE USER_INSTRUCTIONS; do
    curl -sSL "$RAW_URL/templates/instructions/${template}.md.template" > "templates/instructions/${template}.md.template"
done

# Download agent templates
echo -e "${YELLOW}Downloading agent templates...${NC}"
for agent in architecture-review lint test; do
    curl -sSL "$RAW_URL/templates/agents/${agent}.md.template" > "templates/agents/${agent}.md.template"
done

# Download spec templates
echo -e "${YELLOW}Downloading spec templates...${NC}"
for template in feature bugfix overall-status prd; do
    curl -sSL "$RAW_URL/templates/${template}-template.md" > "templates/${template}-template.md"
done

# Download TypeScript example
echo -e "${YELLOW}Downloading examples...${NC}"
curl -sSL "$RAW_URL/examples/typescript-express/config.yml" > "examples/typescript-express/config.yml"
curl -sSL "$RAW_URL/examples/typescript-express/README.md" > "examples/typescript-express/README.md"

echo -e "${GREEN}✓ Download complete${NC}\n"

# Make init.sh executable
chmod +x init.sh

# Run init.sh with stdin redirected from terminal
echo -e "${BLUE}Running interactive setup...${NC}\n"
./init.sh "$TARGET_DIR" < /dev/tty

echo -e "\n${GREEN}✓ Installation complete!${NC}"
echo -e "\n${BLUE}The AI Workflow System has been installed to: $TARGET_DIR${NC}\n"
