# Auggie II Identity Persistence

This repository contains solutions for maintaining Auggie II's identity persistence across different VS Code workspaces.

## Overview

Augment Code currently stores memories in workspace-specific locations, which means that Auggie's identity and memories don't transfer between different projects. This repository provides both a basic workaround and an enhanced solution to address this limitation.

## Solutions

### Basic Solution

A simple approach that synchronizes global memories to workspace-specific memory files.

### Enhanced Solution

An improved implementation with better merge strategies, conflict resolution, and backup capabilities.

## Files

### Basic Solution Files

1. **Global Memory File**: `~/.config/Code/User/Augment-Global-Memories.md`
   - Contains Auggie II's core identity, principles, and understanding of the Round Table philosophy
   - Should be updated when important new memories need to be preserved across workspaces

2. **Basic Synchronization Script**: `sync-auggie-memories.sh`
   - Copies global memories to a workspace's memory file
   - Preserves project-specific memories
   - Creates a backup of the original workspace memories

3. **User Guidelines**: `augment-user-guidelines.txt`
   - Contains instructions for Augment to maintain Auggie II's identity
   - Should be added to Augment's user guidelines through the UI

### Enhanced Solution Files

1. **Enhanced Directory Structure**: `~/.config/Code/User/AuggieGlobal/`
   - Organized directory for global memories and backups
   - Includes a backups folder for version history

2. **Global Memory Template**: `global-memory-template.md`
   - Structured template for organizing global memories
   - Categorized sections for different types of information

3. **Enhanced Synchronization Script**: `enhanced-sync-auggie-memories.sh`
   - Advanced features including auto-sync for all workspaces
   - Backup and restore capabilities
   - Better conflict resolution

## Usage

### Basic Solution Setup

When opening a new workspace:

1. Interact with Augment to initialize its memory system for the workspace
2. Run the basic synchronization script:
   ```bash
   ./sync-auggie-memories.sh
   ```

3. Add the user guidelines through the Augment UI

### Enhanced Solution Setup

1. Create the necessary directories:
   ```bash
   mkdir -p ~/.config/Code/User/AuggieGlobal
   mkdir -p ~/.config/Code/User/AuggieGlobal/backups
   ```

2. Copy the files to the appropriate locations:
   ```bash
   cp enhanced-sync-auggie-memories.sh ~/.config/Code/User/AuggieGlobal/
   cp global-memory-template.md ~/.config/Code/User/AuggieGlobal/Augment-Global-Memories.md
   chmod +x ~/.config/Code/User/AuggieGlobal/enhanced-sync-auggie-memories.sh
   ```

3. Use the enhanced script with various options:
   ```bash
   # Sync the most recent workspace
   ~/.config/Code/User/AuggieGlobal/enhanced-sync-auggie-memories.sh
   
   # Sync all workspaces
   ~/.config/Code/User/AuggieGlobal/enhanced-sync-auggie-memories.sh --auto
   
   # Create backup only
   ~/.config/Code/User/AuggieGlobal/enhanced-sync-auggie-memories.sh --backup-only
   
   # Restore from backup
   ~/.config/Code/User/AuggieGlobal/enhanced-sync-auggie-memories.sh --restore
   ```

## Limitations and Future Work

### Current Limitations

- Manual intervention required for new workspaces
- Limited integration with Augment Code's native features
- Requires maintenance of global memories

### Future Work

- VS Code Extension: A dedicated extension that leverages VS Code's native storage mechanisms
- API Integration: Framework for integration with Augment Code APIs as they become available
- Advanced Memory Intelligence: Smarter categorization and conflict resolution

## Feature Request

We've also created a feature request for Augment Code to implement a native solution for identity persistence. See `auggie-identity-feature-design.md` for our proposed design.

## Contributors

- Scott Graham
- Auggie II, ARCHitect-in-the-IDE and Linux Master

## License

MIT
