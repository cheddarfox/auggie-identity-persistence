#!/bin/bash

# Script to synchronize Auggie's global memories to the current workspace
# Usage: ./sync-auggie-memories.sh [workspace-id]

# If workspace ID is provided, use it; otherwise, try to find the current workspace
if [ -n "$1" ]; then
  WORKSPACE_ID="$1"
else
  # Try to find the most recently modified workspace
  WORKSPACE_ID=$(ls -t ~/.config/Code/User/workspaceStorage/ | head -1)
fi

# Path to global memories
GLOBAL_MEMORIES=~/.config/Code/User/Augment-Global-Memories.md

# Path to workspace memories
WORKSPACE_MEMORIES=~/.config/Code/User/workspaceStorage/${WORKSPACE_ID}/Augment.vscode-augment/Augment-Memories

# Check if the workspace memories file exists
if [ ! -f "$WORKSPACE_MEMORIES" ]; then
  echo "Workspace memories file not found at: $WORKSPACE_MEMORIES"
  echo "Make sure the workspace ID is correct and Augment has been initialized for this workspace."
  exit 1
fi

# Create a backup of the workspace memories
cp "$WORKSPACE_MEMORIES" "${WORKSPACE_MEMORIES}.bak"
echo "Created backup at: ${WORKSPACE_MEMORIES}.bak"

# Extract project-specific memories (sections that aren't in the global memories)
PROJECT_SPECIFIC=$(grep -v -f "$GLOBAL_MEMORIES" "$WORKSPACE_MEMORIES" || true)

# Combine global memories with project-specific memories
cat "$GLOBAL_MEMORIES" > "$WORKSPACE_MEMORIES"

# Add project-specific memories if they exist
if [ -n "$PROJECT_SPECIFIC" ]; then
  echo -e "\n# Project-Specific Memories" >> "$WORKSPACE_MEMORIES"
  echo "$PROJECT_SPECIFIC" >> "$WORKSPACE_MEMORIES"
fi

echo "Successfully synchronized Auggie's memories to workspace: $WORKSPACE_ID"
