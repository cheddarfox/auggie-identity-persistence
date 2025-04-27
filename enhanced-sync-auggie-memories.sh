#!/bin/bash

# Enhanced script to synchronize Auggie's global memories to workspaces
# Usage: ./enhanced-sync-auggie-memories.sh [options] [workspace-id]
#
# Options:
#   --auto           Sync all workspaces automatically
#   --backup-only    Create a backup without syncing
#   --restore        Restore from a backup
#   --help           Display this help message

# Configuration
GLOBAL_DIR=~/.config/Code/User/AuggieGlobal
GLOBAL_MEMORIES=$GLOBAL_DIR/Augment-Global-Memories.md
BACKUP_DIR=$GLOBAL_DIR/backups
WORKSPACE_BASE=~/.config/Code/User/workspaceStorage
DATE_FORMAT=$(date +"%Y%m%d_%H%M%S")

# Create directories if they don't exist
mkdir -p $GLOBAL_DIR
mkdir -p $BACKUP_DIR

# Function to display help
show_help() {
    echo "Enhanced Auggie Memory Synchronization Script"
    echo "---------------------------------------------"
    echo "Usage: $0 [options] [workspace-id]"
    echo ""
    echo "Options:"
    echo "  --auto           Sync all workspaces automatically"
    echo "  --backup-only    Create a backup without syncing"
    echo "  --restore        Restore from a backup"
    echo "  --help           Display this help message"
    echo ""
    echo "Examples:"
    echo "  $0                           # Sync the most recent workspace"
    echo "  $0 1317d0d55217024ccede9aeb8598ecdb  # Sync a specific workspace"
    echo "  $0 --auto                    # Sync all workspaces"
    echo "  $0 --backup-only             # Create a backup without syncing"
    echo "  $0 --restore                 # Restore from a backup"
    exit 0
}

# Function to create a backup
create_backup() {
    local workspace_id=$1
    local workspace_memories=$WORKSPACE_BASE/$workspace_id/Augment.vscode-augment/Augment-Memories
    
    if [ -f "$workspace_memories" ]; then
        cp "$workspace_memories" "$BACKUP_DIR/Augment-Memories_${workspace_id}_${DATE_FORMAT}.bak"
        echo "Created backup at: $BACKUP_DIR/Augment-Memories_${workspace_id}_${DATE_FORMAT}.bak"
        return 0
    else
        echo "Workspace memories file not found at: $workspace_memories"
        return 1
    fi
}

# Function to restore from a backup
restore_from_backup() {
    # List available backups
    echo "Available backups:"
    ls -lt $BACKUP_DIR | grep -v "^total" | head -10
    
    # Ask which backup to restore
    echo ""
    echo "Enter the backup filename to restore (or 'q' to quit):"
    read backup_file
    
    if [ "$backup_file" = "q" ]; then
        echo "Restore cancelled."
        exit 0
    fi
    
    # Extract workspace ID from backup filename
    workspace_id=$(echo $backup_file | sed -n 's/Augment-Memories_\([^_]*\)_.*/\1/p')
    
    if [ -z "$workspace_id" ]; then
        echo "Could not extract workspace ID from backup filename."
        exit 1
    fi
    
    # Check if workspace exists
    if [ ! -d "$WORKSPACE_BASE/$workspace_id" ]; then
        echo "Workspace directory not found: $WORKSPACE_BASE/$workspace_id"
        exit 1
    fi
    
    # Ensure Augment directory exists
    mkdir -p "$WORKSPACE_BASE/$workspace_id/Augment.vscode-augment"
    
    # Restore the backup
    cp "$BACKUP_DIR/$backup_file" "$WORKSPACE_BASE/$workspace_id/Augment.vscode-augment/Augment-Memories"
    echo "Restored $backup_file to workspace $workspace_id"
}

# Function to sync a single workspace
sync_workspace() {
    local workspace_id=$1
    local workspace_memories=$WORKSPACE_BASE/$workspace_id/Augment.vscode-augment/Augment-Memories
    
    # Check if the workspace memories file exists
    if [ ! -f "$workspace_memories" ]; then
        echo "Workspace memories file not found at: $workspace_memories"
        echo "Make sure the workspace ID is correct and Augment has been initialized for this workspace."
        return 1
    fi
    
    # Create a backup of the workspace memories
    create_backup $workspace_id
    
    # Extract project-specific memories (sections that aren't in the global memories)
    PROJECT_SPECIFIC=$(grep -v -f "$GLOBAL_MEMORIES" "$workspace_memories" || true)
    
    # Combine global memories with project-specific memories
    cat "$GLOBAL_MEMORIES" > "$workspace_memories"
    
    # Add project-specific memories if they exist
    if [ -n "$PROJECT_SPECIFIC" ]; then
        echo -e "\n# Project-Specific Memories" >> "$workspace_memories"
        echo "$PROJECT_SPECIFIC" >> "$workspace_memories"
    fi
    
    echo "Successfully synchronized Auggie's memories to workspace: $workspace_id"
    return 0
}

# Function to sync all workspaces
sync_all_workspaces() {
    echo "Syncing all workspaces..."
    
    # Find all workspace directories
    for workspace_dir in $WORKSPACE_BASE/*; do
        if [ -d "$workspace_dir" ]; then
            workspace_id=$(basename "$workspace_dir")
            
            # Check if Augment memories exist for this workspace
            if [ -f "$workspace_dir/Augment.vscode-augment/Augment-Memories" ]; then
                echo "Syncing workspace: $workspace_id"
                sync_workspace $workspace_id
            fi
        fi
    done
    
    echo "All workspaces synchronized."
}

# Main script logic
if [ "$1" = "--help" ]; then
    show_help
elif [ "$1" = "--auto" ]; then
    sync_all_workspaces
elif [ "$1" = "--backup-only" ]; then
    if [ -n "$2" ]; then
        create_backup $2
    else
        # Find the most recently modified workspace
        WORKSPACE_ID=$(ls -t $WORKSPACE_BASE/ | head -1)
        create_backup $WORKSPACE_ID
    fi
elif [ "$1" = "--restore" ]; then
    restore_from_backup
else
    # If workspace ID is provided, use it; otherwise, try to find the current workspace
    if [ -n "$1" ]; then
        WORKSPACE_ID="$1"
    else
        # Try to find the most recently modified workspace
        WORKSPACE_ID=$(ls -t $WORKSPACE_BASE/ | head -1)
    fi
    
    sync_workspace $WORKSPACE_ID
fi
