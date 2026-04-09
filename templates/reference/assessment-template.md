<template name="assessment">
<header>
# Code Assessment: [Project/Feature Area]

**Date:** [timestamp]
**Scope:** [folders/files]

</header>

<section id="summary" title="Executive Summary">
<description>3–5 key findings with impact.</description>
<list>
- [Key finding 1]
- [Key finding 2]
</list>
</section>

<section id="architecture" title="Architecture">
<subsection id="current-state" title="Current State">
<description>Brief description of current architecture.</description>
[Current State Description]
</subsection>

<subsection id="best-practices" title="Comparison to Best Practices">
| Aspect | Current | Best Practice | Gap | Priority |
|--------|---------|---------------|-----|----------|
| Structure | [current] | [best] | [gap] | High/Med/Low |
| Coupling | [current] | [best] | [gap] | High/Med/Low |
| Data Flow | [current] | [best] | [gap] | High/Med/Low |
</subsection>

<subsection id="arch-recommendations" title="Recommendations">
<list type="numbered">
<item>[Actionable recommendation 1]</item>
<item>[Actionable recommendation 2]</item>
</list>
</subsection>
</section>

<section id="standards" title="Code Standards">
<subsection id="current-standards" title="Current Standards">
| Type | Tool | Config File |
|------|------|-------------|
| Linter | [name] | [file] |
| Formatter | [name] | [file] |
| Type Checker | [name] | [file] |
</subsection>

<subsection id="conventions" title="Conventions">
<list>
<item>Naming: [convention]</item>
<item>Files: [convention]</item>
<item>Imports: [convention]</item>
<item>Comments: [convention]</item>
</list>
</subsection>

<subsection id="compliance" title="Compliance">
<description>Brief summary of adherence to standards.</description>
[Compliance Summary]
</subsection>

<subsection id="standards-recommendations" title="Recommendations">
<description>Enforcements and fixes.</description>
[Standards Recommendations]
</subsection>
</section>

<section id="dependencies" title="Dependencies">
<subsection id="current-deps" title="Current Dependencies">
| Package | Current | Latest | Status | Action |
|---------|---------|--------|--------|--------|
| [pkg] | [ver] | [latest] | OK/Outdated/Vulnerable | [action] |
</subsection>

<subsection id="security" title="Security Issues">
| Package | Severity | CVE | Fix |
|---------|----------|-----|-----|
| [pkg] | Critical/High/Med/Low | [CVE] | [fix] |
</subsection>

<subsection id="deps-recommendations" title="Recommendations">
<list type="numbered">
<item>[Actionable recommendation 1]</item>
<item>[Actionable recommendation 2]</item>
</list>
</subsection>
</section>

<section id="patterns" title="Framework Patterns">
<subsection id="identified" title="Identified Patterns">
<list>
<item>State Management: [approach]</item>
<item>Routing: [approach]</item>
<item>API Integration: [approach]</item>
<item>Testing: [approach]</item>
</list>
</subsection>

<subsection id="to-follow" title="Patterns to Follow">
| Pattern | Location | Example |
|---------|----------|---------|
| [pattern] | [file] | [brief example] |
</subsection>
</section>

<section id="options" title="Better Options">
<subsection id="improvements" title="Potential Improvements">
| Area | Current | Better Option | Effort | Impact |
|------|---------|---------------|--------|--------|
| [area] | [current] | [better] | High/Med/Low | High/Med/Low |
</subsection>

<subsection id="tech-debt" title="Technical Debt">
| Issue | Location | Severity | Fix Effort |
|-------|----------|----------|------------|
| [issue] | [file(s)] | High/Med/Low | [estimate] |
</subsection>
</section>

<section id="final-summary" title="Summary">
<subsection id="must-follow" title="Must Follow">
<description>Critical patterns/standards to adhere to.</description>
[Critical patterns]
</subsection>

<subsection id="should-consider" title="Should Consider">
<description>Recommended improvements.</description>
[Recommended improvements]
</subsection>

<subsection id="future-work" title="Future Work">
<description>Future considerations.</description>
[Future considerations]
</subsection>
</section>

<section id="files-examined" title="Files Examined">
<list>
<item>`[file1]` - [purpose]</item>
<item>`[file2]` - [purpose]</item>
</list>
</section>
</template>
