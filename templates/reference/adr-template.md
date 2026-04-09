<template name="adr">
<header>
# ADR-[index]: [Title - Concise Decision Statement]
</header>

<section id="status" title="Status">
[Proposed | Accepted | Deprecated | Superseded by ADR-YYYY]
</section>

<section id="context" title="Context and Problem Statement">
<description>What is the issue motivating this decision? 2-3 sentences describing the problem.</description>
[Context Content]
</section>

<section id="drivers" title="Decision Drivers">
<list>
<item>[Driver 1: e.g., "Need to support 10K concurrent users"]</item>
<item>[Driver 2: e.g., "Team has experience with technology X"]</item>
</list>
</section>

<section id="options" title="Considered Options (≥3 required)">
<list type="numbered">
<item>[Option 1]</item>
<item>[Option 2]</item>
<item>[Option 3]</item>
</list>
</section>

<section id="outcome" title="Decision Outcome">
<description>Final recommendation + rationale.</description>
**Chosen option:** "[option]", because [justification in 1-2 sentences].

**Reversibility Plan:** [outline concrete steps to revert or pivot if the decision proves suboptimal; include triggers, rollback approach, and cost/time estimate]

<subsection id="consequences" title="Consequences">
<list>
<item>Good: [positive consequence 1]</item>
<item>Good: [positive consequence 2]</item>
<item>Bad: [negative consequence, and how we'll mitigate]</item>
</list>
</subsection>
</section>

<section id="pros-cons" title="Pros and Cons of the Options">
<subsection id="opt1" title="[Option 1]">
<list>
<item>Good, because [argument]</item>
<item>Bad, because [argument]</item>
</list>
</subsection>
</section>

<section id="evaluation" title="Evaluation Matrix">
| Criteria | Weight | Option 1 | Option 2 | Option 3 |
|----------|--------|----------|----------|----------|
| [Criterion 1] | [1-5] | [1-5] | [1-5] | [1-5] |
| **Weighted Total** | | [sum] | [sum] | [sum] |
</section>

<section id="links" title="Links">
<list>
<item>[Link to related requirement or issue]</item>
<item>[Link to research or documentation]</item>
</list>
</section>
</template>
