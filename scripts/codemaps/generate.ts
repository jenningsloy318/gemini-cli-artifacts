import { execSync } from "child_process";
import * as fs from "fs";
import * as path from "path";

/**
 * Codemap Generator for Gemini CLI
 *
 * Generates a comprehensive map of the project structure and metadata.
 */

async function main() {
  const workspacePath = process.cwd();
  const extensionPath = process.env.extensionPath || "";
  const outputDir = path.join(extensionPath, "data");
  const outputFile = path.join(outputDir, "codemap.md");

  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  console.log(`Generating codemap for ${workspacePath}...`);

  let content = `# Project Codemap: ${path.basename(workspacePath)}\n\n`;
  content += `Generated on: ${new Date().toISOString()}\n\n`;

  // 1. Directory Tree
  content += `## Directory Structure\n\n\`\`\`\n`;
  try {
    const tree = execSync(
      'tree -L 3 -I ".git|node_modules|.worktree|dist|build"',
      { encoding: "utf-8" },
    );
    content += tree;
  } catch (e) {
    content += `(tree command not available or failed)\n`;
    // Fallback to basic ls if tree is missing
    try {
      const ls = execSync(
        'ls -R | grep ":$" | sed -e "s/:$//" -e "s/[^-][^\/]*\//--/g" -e "s/^/ /" -e "s/-/|/"',
        { encoding: "utf-8" },
      );
      content += ls;
    } catch (e2) {
      content += `Error generating tree.\n`;
    }
  }
  content += `\`\`\`\n\n`;

  // 2. Key Files Summary
  content += `## Key Files\n\n`;
  const importantFiles = [
    "package.json",
    "README.md",
    "GEMINI.md",
    "tsconfig.json",
    "go.mod",
    "Cargo.toml",
    "requirements.txt",
  ];

  for (const file of importantFiles) {
    if (fs.existsSync(path.join(workspacePath, file))) {
      content += `- **${file}**: Found\n`;
    }
  }
  content += `\n`;

  // 3. Extension Metadata (if applicable)
  if (fs.existsSync(path.join(workspacePath, "gemini-extension.json"))) {
    content += `## Extension Metadata\n\n`;
    const meta = JSON.parse(
      fs.readFileSync(
        path.join(workspacePath, "gemini-extension.json"),
        "utf-8",
      ),
    );
    content += `- **Name**: ${meta.name}\n`;
    content += `- **Version**: ${meta.version}\n`;
    content += `- **Description**: ${meta.description}\n\n`;
  }

  fs.writeFileSync(outputFile, content);
  console.log(`Codemap saved to ${outputFile}`);
}

main().catch((err) => {
  console.error("Failed to generate codemap:", err);
  process.exit(1);
});
