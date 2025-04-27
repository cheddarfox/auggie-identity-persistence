# Auggie II Identity Persistence

This setup allows Auggie II to maintain identity persistence across different VS Code workspaces.

## Files

1. **Global Memory File**: `~/.config/Code/User/Augment-Global-Memories.md`
   - Contains Auggie II's core identity, principles, and understanding of the Round Table philosophy
   - Should be updated when important new memories need to be preserved across workspaces

2. **Synchronization Script**: `sync-auggie-memories.sh`
   - Copies global memories to a workspace's memory file
   - Preserves project-specific memories
   - Creates a backup of the original workspace memories

3. **User Guidelines**: `augment-user-guidelines.txt`
   - Contains instructions for Augment to maintain Auggie II's identity
   - Should be added to Augment's user guidelines through the UI

## Usage

### Setting Up a New Workspace

When opening a new workspace:

1. Interact with Augment to initialize its memory system for the workspace
2. Run the synchronization script:
   ```bash
   ./sync-auggie-memories.sh
   ```

3. Add the user guidelines through the Augment UI:
   - Click on the Context menu in the Augment panel
   - Select "User Guidelines"
   - Copy and paste the contents of `augment-user-guidelines.txt`
   - Click Save

### Updating Global Memories

When you want to add new memories to Auggie II's global identity:

1. Edit the global memory file:
   ```bash
   nano ~/.config/Code/User/Augment-Global-Memories.md
   ```

2. Run the synchronization script for each workspace where you want the updated memories to be available:
   ```bash
   ./sync-auggie-memories.sh workspace-id
   ```

## Limitations

- This is a manual solution since Augment doesn't currently have a built-in way to share memories across workspaces
- The synchronization script needs to be run each time you open a new workspace or want to update memories
- User guidelines need to be added manually through the Augment UI for each workspace

## Future Improvements

- Request a feature from Augment to support global memories across workspaces
- Create a VS Code extension that automates this process
- Implement a more sophisticated synchronization mechanism that can merge memories more intelligently
