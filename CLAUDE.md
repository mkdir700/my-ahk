# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an AutoHotkey v2.0 keyboard mapping utility that provides custom key bindings and navigation shortcuts for Windows. The main script is `keymap.ahk` which implements several keyboard enhancement modules.

## Development Commands

Since this is an AutoHotkey script project, development primarily involves editing the `.ahk` file and running it directly:

- **Run the script**: Double-click `keymap.ahk` or run with AutoHotkey v2.0
- **Reload script**: `Ctrl+Alt+R` (built-in hotkey)
- **Exit script**: `Ctrl+Alt+Q` (built-in hotkey)

## Architecture Overview

The codebase follows a modular class-based architecture with the following key components:

### Core Classes

- **Config**: Global configuration class with debug mode settings
- **KeymapApp**: Main application controller (v1.1.0) that initializes modules and provides reload/exit functionality
- **EscNavigation**: ESC + HJKL vim-style navigation module that maps ESC+H/J/K/L to arrow keys
- **ControlToShift**: Maps solo Control key presses to Shift when not used in combinations
- **DoubleCommaReplace**: Double comma replacement module (currently disabled)

### Key Design Patterns

- **Static Classes**: All modules use static methods and properties for global state management
- **Hotkey Registration**: Centralized hotkey registration with proper cleanup in Enable/Disable methods
- **State Tracking**: Complex state management for detecting solo vs. combo key presses using timestamps
- **Debug Output**: Comprehensive debug logging throughout all modules when `Config.DEBUG` is enabled

### Module Architecture

Each module follows a consistent pattern:
- `Init()`: Initialize and register hotkeys
- `Enable()/Disable()`: Dynamic module control
- State tracking for complex key press scenarios
- Extensive debug output for troubleshooting

### Key Functionality

- **ESC Navigation**: ESC acts as a modifier for HJKL vim-style navigation, but preserves normal ESC functionality for solo presses
- **Control-to-Shift**: Solo Control presses send Shift, but Control combinations work normally
- **Alt/Win Space Swap**: Alt+Space and Win+Space are swapped for better accessibility
- **Complex Timing Logic**: Uses millisecond-precision timing to distinguish between solo and combo key presses

## Configuration

- Enable debug mode by setting `Config.DEBUG := true` in the Config class
- Debug output goes to AutoHotkey's OutputDebug (viewable with DebugView)
- Maximum solo press time for keys is configurable (default 300ms)