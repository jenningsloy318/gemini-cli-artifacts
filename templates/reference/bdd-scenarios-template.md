<template name="bdd-scenarios">
<header>
# Behavior Scenarios: [Feature Name]

**Date:** [timestamp]
**Author:** super-dev:bdd-scenario-writer
**Source:** ./[doc-index]-requirements.md
**Total Scenarios:** [count]

</header>

<section id="scenarios" title="Feature: [Feature Name]">
<subsection id="scenario-1" title="SCENARIO-001: [Meaningful Behavior Title]">
<description>Describe WHAT behavior is expected, not HOW.</description>
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition in business language]
**When** [single action/event in business language]
**Then** [verifiable outcome in business language]
</subsection>

<subsection id="scenario-2" title="SCENARIO-002: [Meaningful Behavior Title]">
**Acceptance Criteria:** AC-XX from requirements
**Priority:** P0/P1/P2

**Given** [precondition]
**When** [action]
**Then** [outcome]
**And** [additional outcome if needed]
</subsection>

</section>

<section id="traceability" title="Scenario-Acceptance Criteria Traceability Matrix">
| Acceptance Criterion | Scenario IDs               | Coverage |
| -------------------- | -------------------------- | -------- |
| AC-01: [description] | SCENARIO-001, SCENARIO-002 | Covered  |
| AC-02: [description] | SCENARIO-003               | Covered  |
</section>

<section id="summary" title="Coverage Summary">
- **Total Acceptance Criteria:** [X]
- **Covered by Scenarios:** [Y]
- **Uncovered:** [Z] (must be 0)
- **Total Scenarios:** [N]
- **Scenarios per AC (avg):** [N/X]
</section>

<section id="quality" title="Quality Validation">
<subsection id="per-scenario" title="Per-Scenario Checks">
| Scenario     | Q1  | Q2  | Q3  | Q4  | Q5  | Q6  | Q7  | Q8  | Q9  | Q10 | Pass |
| ------------ | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---- |
| SCENARIO-001 | Y   | Y   | Y   | Y   | Y   | Y   | Y   | Y   | Y   | Y   | Y    |
</subsection>

<subsection id="per-document" title="Per-Document Checks">
<list type="todo">
- [x] D1: All AC covered
- [x] D2: Scenario count within limits
- [x] D3: Traceability matrix complete
- [x] D4: All IDs unique
- [x] D5: Priorities assigned
- [x] D6: Happy paths first
- [x] D7: Error cases included
- [x] D8: No duplicates
</list>
</subsection>
</section>
</template>
