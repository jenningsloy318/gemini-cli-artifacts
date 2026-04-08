<template name="handoff">
<header>
# Handoff Document: [Feature/Fix Name]

**Date:** [timestamp]
**From:** AI Agent (Session N)
**To:** Next AI Agent
**Spec Directory:** specification/[spec-index]-[spec-name]

</header>

<section id="objective" title="1. Current Task Objective">
<subsection id="problem" title="Problem">
[What problem was being solved — one paragraph, specific]
</subsection>
<subsection id="deliverables" title="Deliverables">
[Bulleted list of what was expected to be produced]
</subsection>
<subsection id="criteria" title="Completion Criteria">
[How "done" is defined — reference specific AC IDs from requirements.md]
</subsection>
</section>

<section id="progress" title="2. Current Progress">
<subsection id="decisions" title="Analysis & Decisions">
[Key analysis performed, options evaluated, decisions made with rationale]
</subsection>
<subsection id="changes" title="Changes Made">
[Files created/modified/deleted, with specific paths — use git diff summary]
</subsection>
<subsection id="outputs" title="Outputs Produced">
[Spec artifacts, code modules, test suites — bulleted list with file paths]
</subsection>
</section>

<section id="context" title="3. Key Context">
<subsection id="background" title="Background">
[Why this task exists, what preceded it, how it fits into the project]
</subsection>
<subsection id="requirements" title="User Requirements & Constraints">
[Explicit user conventions: git rules, workflow preferences, commit format, etc.]
</subsection>
<subsection id="rationale" title="Key Decisions & Rationale">
[Architecture choices, design trade-offs, option selections — each with reasoning]
</subsection>
</section>

<section id="findings" title="4. Key Findings">
<subsection id="conclusions" title="Conclusions">
[What was learned during implementation]
</subsection>
<subsection id="patterns" title="Patterns & Anomalies">
[Codebase patterns discovered, unexpected behaviors, naming conventions found]
</subsection>
</section>

<section id="unfinished" title="5. Unfinished Items (Priority Order)">
<subsection id="p0" title="P0: Critical">
[Items that MUST be addressed next — blocking issues, broken functionality]
</subsection>
<subsection id="p1" title="P1: Important">
[Items deferred from this session — follow-ups]
</subsection>
</section>

<section id="path" title="6. Suggested Handoff Path">
<subsection id="files" title="Files to Read First">
[Ordered list of most important files to read, with paths and WHY each matters]
</subsection>
<subsection id="verify" title="What to Verify First">
[Specific commands to run, state to check]
</subsection>
<subsection id="next" title="Recommended Next Actions">
[Concrete actionable steps for the next session, in order]
</subsection>
</section>

<section id="risks" title="7. Risks and Warnings">
<subsection id="pitfalls" title="Pitfalls">
[Known tricky areas, file complexity warnings]
</subsection>
</section>

<section id="first-steps" title="First Steps for the Next Agent">
1. Read this handoff document completely
2. [Concrete step]
3. [Concrete step]
</section>
</template>
