8 Gemini CLI Hooks That Automate What You Keep Forgetting 
Have you ever told Gemini CLI to do something and it just didn't?
You said format the code - It didn't. You said don't touch that file - It did. 
You said run tests before finishing - It forgot.
That's because GEMINI.md is a suggestion.
 Gemini reads it and follows it about 80% of the time. Hooks are different. They're automatic actions that fire every time Gemini edits a file, runs a command, or finishes a task.
Below I will share 8 personal hooks you can copy straight into your settings.json and never think about again 👇
Before we dive in, I share daily notes on AI & vibe coding in my Telegram channel: https://t.me/zodchixquant🧠
How hooks work (30-second version)

What are hooks?
Hooks are automatic actions that run every time Gemini CLI does something, like editing a file or running a command. 
You set them up once and they work in the background without you thinking about it.
The two you'll use most:
PreToolUse runs before Gemini does something. You can inspect the action and block it by returning exit code 2. Think of it as a bouncer.
PostToolUse runs after Gemini does something. You can run cleanup, formatting, tests, or logging. Think of it as quality control on the assembly line.
markdown
Where hooks live:

.gemini/settings.json         project-level (shared via git)
~/.gemini/settings.json       user-level (all your projects)
.gemini/settings.local.json   local only (not committed)
You configure them in .gemini/settings.json in your project root. That file gets committed to git, so your whole team gets the same hooks automatically.
Full documentation: https://code.gemini.com/docs/en/hooks
1. Auto-format every file Gemini touches
The problem: Gemini writes correct code that breaks your formatting rules. You add "always run Prettier" to GEMINI.md and it works most of the time, but not always.
The hook: Prettier runs automatically after every file write or edit.
json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null; exit 0"
          }
        ]
      }
    ]
  }
}
Swap npx prettier --write for whatever formatter you use: black for Python, gofmt for Go, rustfmt for Rust. The pattern is the same.
This was the first hook I set up and honestly it should be the default for every project. No more "Gemini forgot to format" commits.
2. Block dangerous commands
The problem: Gemini is powerful enough to run rm -rf, git reset --hard, DROP TABLE, or curl to random URLs. It probably won't, but "probably" isn't good enough when it's your production database.
The hook: Block destructive commands before they execute.
Create .gemini/hooks/block-dangerous.sh:
bash
Create .gemini/hooks/block-dangerous.sh:
#!/usr/bin/env bash
set -euo pipefail
cmd=$(jq -r '.tool_input.command // ""')

dangerous_patterns=(
  "rm -rf"
  "git reset --hard"
  "git push.*--force"
  "DROP TABLE"
  "DROP DATABASE"
  "curl.*|.*sh"
  "wget.*|.*bash"
)

for pattern in "${dangerous_patterns[@]}"; do
  if echo "$cmd" | grep -qiE "$pattern"; then
    echo "Blocked: '$cmd' matches dangerous pattern '$pattern'. Propose a safer alternative." >&2
    exit 2
  fi
done
exit 0
Then add to your settings.json:
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
Then add to your settings.json:
json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/block-dangerous.sh"
          }
        ]
      }
    ]
  }
}
Exit code 2 is the key. It blocks the action and sends your error message back to Gemini so it can try a safer approach. Exit code 0 means "go ahead." Anything else logs a warning but doesn't block.
3. Protect sensitive files from edits
The problem: Gemini can read and edit any file in your project. That includes .env, package-lock.json, config files, and anything else you'd rather it didn't touch.
The hook: Block edits to files that should be off-limits.
Create .gemini/hooks/protect-files.sh:
bash
#!/usr/bin/env bash
set -euo pipefail
file=$(jq -r '.tool_input.file_path // .tool_input.path // ""')

protected=(
  ".env*"
  ".git/*"
  "package-lock.json"
  "yarn.lock"
  "*.pem"
  "*.key"
  "secrets/*"
)

for pattern in "${protected[@]}"; do
  if echo "$file" | grep -qiE "^${pattern//\*/.*}$"; then
    echo "Blocked: '$file' is protected. Explain why this edit is necessary." >&2
    exit 2
  fi
done
exit 0
bash
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/protect-files.sh"
          }
        ]
      }
    ]
  }
}

4. Run tests after every edit
The problem: Gemini makes a change, says "done," and you discover the tests are broken 20 minutes later when you try to commit.
The hook: Run your test suite automatically after every code change. If tests fail, Gemini sees the failure and can fix it immediately.
json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npm run test --silent 2>&1 | tail -5; exit 0"
          }
        ]
      }
    ]
  }
}
The tail -5 keeps the output short so it doesn't flood Gemini's context. You want Gemini to see "3 tests failed" not the full 200-line test output.
Boris Cherny, the creator of Gemini CLI, says giving Gemini a feedback loop like this improves output quality by 2-3x. Instead of writing code and hoping it works, Gemini writes code, sees the test results, and fixes failures on its own.
5. Require passing tests before creating a PR
The problem: Gemini finishes a feature and immediately creates a PR. Tests are failing. Your reviewer sees red CI and sends it back.
The hook: Block PR creation unless all tests pass.
Create .gemini/hooks/require-tests-for-pr.sh:
#!/usr/bin/env bash
set -euo pipefail

if npm run test --silent; then
  exit 0
else
  echo "Tests are failing. Fix all test failures before creating a PR." >&2
  exit 2
fi
json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__github__create_pull_request",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/require-tests-for-pr.sh"
          }
        ]
      }
    ]
  }
}
This is a hard gate. No green tests, no PR. Gemini will fix the failures first because exit code 2 tells it the action was blocked and why.
6. Auto-lint and report errors
The problem: Gemini writes code that works but violates your ESLint rules, style guide, or type checks. You catch it during review and send it back.
The hook: Lint after every edit. If lint fails, Gemini sees the errors and fixes them before you ever look at the code.
json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "npx eslint --fix $(jq -r '.tool_input.file_path') 2>&1 | tail -10; exit 0"
          }
        ]
      }
    ]
  }
}
You can chain this with the auto-format hook from #1. Prettier runs first, then ESLint. By the time you see the code, it's formatted and lint-clean.
7. Log every command Gemini runs
The problem: Gemini runs a lot of shell commands during a session. If something goes wrong, you want to know exactly what it did and when.
The hook: Append every Bash command to a log file with timestamps.
Create .gemini/hooks/log-commands.sh:
bash
#!/usr/bin/env bash
set -euo pipefail
cmd=$(jq -r '.tool_input.command // ""')
printf '%s %s\n' "$(date -Is)" "$cmd" >> .gemini/command-log.txt
exit 0
json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/log-commands.sh"
          }
        ]
      }
    ]
  }
}
Now you have a timestamped audit trail of every command Gemini ran. Add .gemini/command-log.txt to your .gitignore so it doesn't pollute your repo.
This is especially useful for debugging: if Gemini broke something three sessions ago, you can look at the log and find exactly when and what it ran.
8. Auto-commit after each completed task
The problem: Gemini finishes a task and you forget to commit. Then it starts another task and now you have two unrelated changes mixed together in one commit.
The hook: Automatically commit all changes when Gemini stops working on a task.
Create .gemini/hooks/auto-commit.sh:
bash
#!/usr/bin/env bash
set -euo pipefail
git add -A
if ! git diff --cached --quiet; then
  git commit -m "chore(ai): apply Gemini edit"
fi
exit 0
json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": ".gemini/hooks/auto-commit.sh"
          }
        ]
      }
    ]
  }
}
Every time Gemini finishes a response, changes get committed automatically. Your git history stays clean with atomic commits per task instead of one massive "Gemini changes" blob at the end of the day.
Combine this with gemini -w feature-branch (worktrees) and you get isolated, auto-committed feature branches for every task.
The complete settings.json
Here's everything combined into one file you can copy-paste:
Screenshot-friendly:
Copy this file into .gemini/settings.json, create the hook scripts in .gemini/hooks/, make them executable with chmod +x .gemini/hooks/*.sh, and commit everything to git. Your whole team gets the same safety nets automatically.
json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": ".gemini/hooks/block-dangerous.sh" },
          { "type": "command", "command": ".gemini/hooks/log-commands.sh" }
        ]
      },
      {
        "matcher": "Edit|Write",
        "hooks": [
          { "type": "command", "command": ".gemini/hooks/protect-files.sh" }
        ]
      },
      {
        "matcher": "mcp__github__create_pull_request",
        "hooks": [
          { "type": "command", "command": ".gemini/hooks/require-tests-for-pr.sh" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write 2>/dev/null; exit 0" },
          { "type": "command", "command": "npx eslint --fix $(jq -r '.tool_input.file_path') 2>&1 | tail -10; exit 0" }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": ".gemini/hooks/auto-commit.sh" }
        ]
      }
    ]
  }
}
The difference between a good Gemini CLI setup and a great one isn't the model or the prompts. It's the hooks. 
They're the part that runs when you're not paying attention, catching the mistakes you'd otherwise find during code review or worse, in production.
Set up hook #1 (auto-format) and #2 (block dangerous commands) today. That alone will save you from the most common Gemini CLI mistakes. Add the rest as you need them.

