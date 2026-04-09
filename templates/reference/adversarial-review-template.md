<template name="adversarial-review">
<header>
# Adversarial Review: [Feature/Fix Name]

**Date:** [timestamp]
**Reviewer:** super-dev:adversarial-reviewer
**Verdict:** PASS | CONTESTED | REJECT

</header>

<section id="intent" title="Intent">
<description>what the author is trying to achieve</description>
[Intent Content]
</section>

<section id="verdict-summary" title="Verdict Summary">
<description>one-line summary</description>
[Summary Content]
</section>

<section id="scope" title="Change Scope">
| Metric                 | Value                                |
| ---------------------- | ------------------------------------ |
| Lines changed          | X                                    |
| Files changed          | X                                    |
| Size classification    | Small/Medium/Large                   |
| Reviewers activated    | Skeptic [+ Architect] [+ Minimalist] |
| Attack vectors applied | V1-V6, V8 [+ V7]                     |
</section>

<section id="dag" title="Destructive Action Gate">
**Gate Verdict:** CLEAR | BLOCKED

| Check                       | Status     | Evidence               |
| --------------------------- | ---------- | ---------------------- |
| Data Destruction (DAT)      | CLEAR/HALT | [details or file:line] |
| Irreversible State (IRR)    | CLEAR/HALT | [details or file:line] |
| Production Impact (PRD)     | CLEAR/HALT | [details or file:line] |
| Permission Escalation (PRM) | CLEAR/HALT | [details or file:line] |
| Secret Operations (SEC)     | CLEAR/HALT | [details or file:line] |

<subsection id="halt-findings" title="HALT Findings">
[DAG-XXX entries if any, or "None"]
</subsection>
</section>

<section id="findings" title="Findings">
<description>numbered list, ordered by severity: HALT -> high -> medium -> low. each finding tagged with Lens/Vector: e.g., Skeptic/V2</description>

<subsection id="high" title="High">
**AF-001** | Skeptic/V2 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action, not vague advice]
</subsection>

<subsection id="medium" title="Medium">
**AF-002** | Architect/V7 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action]
</subsection>

<subsection id="low" title="Low">
**AF-003** | Minimalist/V7 | `file:line`
**Issue:** [description]
**Recommendation:** [concrete action]
</subsection>
</section>

<section id="vector-coverage" title="Vector Coverage">
| Vector                  | Lens      | Findings | Highest Severity |
| ----------------------- | --------- | -------- | ---------------- |
| V1: False Assumptions   | Skeptic   | 0        | --               |
| V2: Edge Cases          | Skeptic   | 0        | --               |
| V3: Failure Modes       | Skeptic   | 0        | --               |
| V4: Adversarial Input   | Skeptic   | 0        | --               |
| V5: Safety & Compliance | Skeptic   | 0        | --               |
| V6: Grounding Audit     | Skeptic   | 0        | --               |
| V7: Dependencies        | Architect | 0        | --               |
| V8: Behavior Coverage   | Skeptic   | 0        | --               |
</section>

<section id="strengths" title="What Went Well">
<description>1-3 things the reviewers found no issue with</description>
[Strengths Content]
</section>

<section id="judgment" title="Lead Judgment">
<description>for each finding: accept or reject with a one-line rationale</description>
[Judgment Content]
</section>
</template>
