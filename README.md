# Photoshop MCP Server 🎨

[![npm version](https://img.shields.io/npm/v/@alisaitteke/photoshop-mcp.svg)](https://www.npmjs.com/package/@alisaitteke/photoshop-mcp)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.7-blue.svg)](https://www.typescriptlang.org/)

A Model Context Protocol (MCP) server that enables AI assistants like Claude, Cursor, and **Antigravity** to control Adobe Photoshop programmatically.

> **Note:** This is a fork/customized version. For the **original repository** and full documentation, please visit: [alisaitteke/photoshop-mcp](https://github.com/alisaitteke/photoshop-mcp). This is an unofficial, community-maintained project and is not affiliated with Adobe Inc.

## Installation & Configuration

No installation is required if you are using `npx`. Just add the following configurations to your respective AI assistant client.

### For Antigravity

Update your MCP configuration file for Antigravity (e.g., `mcp_config.json`):

```json
{
  "mcpServers": {
    "photoshop": {
      "command": "npx",
      "args": ["-y", "@alisaitteke/photoshop-mcp"],
      "env": {
        "LOG_LEVEL": "1"
      }
    }
  }
}
```

### For Cursor

Add to your Cursor settings (`.cursor/config.json` or workspace settings):

```json
{
  "mcpServers": {
    "photoshop": {
      "command": "npx",
      "args": ["-y", "@alisaitteke/photoshop-mcp"],
      "env": {
        "LOG_LEVEL": "1"
      }
    }
  }
}
```

### For Claude Desktop

Add to your Claude Desktop config (`~/Library/Application Support/Claude/claude_desktop_config.json` on macOS or `%APPDATA%\Claude\claude_desktop_config.json` on Windows):

```json
{
  "mcpServers": {
    "photoshop": {
      "command": "npx",
      "args": ["-y", "@alisaitteke/photoshop-mcp"],
      "env": {
        "LOG_LEVEL": "1"
      }
    }
  }
}
```

## Features Overview

This MCP server provides your AI assistant with 50+ tools to automate Photoshop seamlessly:
- **Document Management**: Create, open, save, close, crop documents.
- **Layer Operations**: Create, delete, duplicate, merge, transform, and arrange layers.
- **Layer Properties**: Opacity, blend modes, visibility, locking.
- **Text Formatting**: Font, size, color, alignment controls.
- **Filters & Adjustments**: Gaussian Blur, Sharpen, Brightness/Contrast, Hue/Saturation, Levels.
- **Selections & Masks**: Rectangular selections, layer masks.
- **Automation**: Play recorded actions, undo/redo, or execute custom ExtendScript code.

*To view the extensive list of all available commands and detailed usage examples, please check the [origin repository README](https://github.com/alisaitteke/photoshop-mcp).*
