<template name="code-review">
<header>
# Code Review: [Feature/Fix Name]

**Date:** [timestamp]
**Reviewer:** super-dev:code-reviewer
**Secondary Reviewer:** code-review-expert (if available)
**Status:** [Approved / Approved with Comments / Changes Requested / Blocked]
**Base SHA:** [sha or N/A]
**Head SHA:** [sha or N/A]

</header>

<section id="stats" title="Summary Statistics">
| Severity | Count |
| -------- | ----- |
| Critical | X     |
| High     | X     |
| Medium   | X     |
| Low      | X     |
| Info     | X     |

| Dimension       | Issues |
| --------------- | ------ |
| Correctness     | X      |
| Security        | X      |
| Performance     | X      |
| Maintainability | X      |
| Testability     | X      |
| Error Handling  | X      |
| Consistency     | X      |
| Accessibility   | X      |

</section>

<section id="validation" title="Specification Validation">
| Criterion           | Status              | Evidence    |
| ------------------- | ------------------- | ----------- |
| AC-1: [description] | Met/Not Met/Partial | [file:line] |
| AC-2: [description] | Met/Not Met/Partial | [file:line] |
| ...                 | ...                 | ...         |

<subsection id="nongoals" title="Non-Goals Check">
<list type="todo">
<item>[x] NG-1: [non-goal] - Not implemented (correct)</item>
<item>[ ] NG-2: [non-goal] - Implemented (issue - see F-XXX)</item>
</list>
</subsection>
</section>

<section id="bdd-coverage" title="BDD Scenario Coverage">
| Scenario ID  | Title   | Test Reference                | Status            |
| ------------ | ------- | ----------------------------- | ----------------- |
| SCENARIO-001 | [title] | [test file:line or test name] | Covered / Missing |

**Coverage:** [M/N] scenarios covered
**Gate:** PASS / FAIL

</section>

<section id="findings" title="Findings">
<description>Findings include both specification-first review (internal) and senior engineer review (external code-review-expert skill, if available). Findings identified by both reviewers are marked with **[Dual]**.</description>

<subsection id="critical" title="Critical">
**F-001** | [Dimension] | `file:line` **[Dual]** (if identified by both)
**Issue:** [description]
**Suggestion:** [concrete fix]
**Rationale:** [why it matters]
</subsection>

<subsection id="high" title="High">
**F-002** | [Dimension] | `file:line`
**Issue:** [description]
**Suggestion:** [fix]
**Rationale:** [why]
</subsection>

<subsection id="medium" title="Medium">
[Same format]
</subsection>

<subsection id="low" title="Low">
[Same format]
</subsection>

<subsection id="info" title="Info">
[Same format]
</subsection>
</section>

<section id="strengths" title="Strengths">
<list>
<item>[Specific good patterns with file:line references]</item>
</list>
</section>

<section id="recommendations" title="Recommendations">
<list>
<item>[Actionable improvement recommendations]</item>
</list>
</section>
</template>
