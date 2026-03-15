# Contributing to ClaudePM

## Development Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Dammyjay93/claudepm.git
   cd claudepm
   ```

2. Install in Claude Code for testing:
   ```
   /plugin marketplace add ./
   /plugin install claudepm
   ```

## Project Structure

```
claudepm-marketplace/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace configuration
├── plugins/
│   └── claudepm/
│       ├── .claude-plugin/
│       │   └── plugin.json     # Plugin metadata
│       ├── commands/           # Slash commands
│       │   ├── claudepm.md     # Main dispatcher
│       │   └── claudepm/       # Subcommands
│       │       ├── save.md
│       │       ├── plan.md
│       │       ├── review.md
│       │       ├── handoff.md
│       │       └── help.md
│       ├── skills/
│       │   └── claudepm/
│       │       └── SKILL.md    # Core knowledge base
│       ├── hooks/
│       │   ├── hooks.json
│       │   ├── session-start-memory.sh
│       │   ├── session-stop-reminder.sh
│       │   └── validate-vault.py
│       └── vault/
│           └── .schemas/       # File format schemas
├── CHANGELOG.md
└── README.md
```

## How Commands Work

Commands are markdown files that Claude interprets as prompts. Each command has YAML frontmatter that specifies allowed tools and a description.

The main dispatcher (`claudepm.md`) routes to subcommands based on the argument. Subcommands are in the `claudepm/` directory.

## Testing

1. Make your changes
2. Restart Claude Code to pick up command changes
3. Test the affected commands
4. Hooks are picked up automatically from `hooks/hooks.json`

## Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to command behavior or vault format
- **MINOR**: New features, new commands
- **PATCH**: Bug fixes

Update `CHANGELOG.md` with your changes.

## Pull Requests

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Update CHANGELOG.md
5. Submit a pull request

Keep changes focused. Update documentation if behavior changes. Add a changelog entry.

## Reporting Issues

Use GitHub Issues. Include steps to reproduce, expected vs actual behavior, and your environment.
