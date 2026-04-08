<template name="requirements">
<header>
# Requirements: [Feature/Fix Name]

**Date:** [timestamp]
**Type:** Feature/Bug Fix/Improvement
**Priority:** High/Medium/Low

</header>

<section id="summary" title="Executive Summary">
<description>2-3 sentence overview of the real need, not just the surface request.</description>
## Executive Summary

[Executive Summary Content]

</section>

<section id="need" title="The Real Need (Root Cause Analysis)">
<subsection id="surface" title="Surface Request">
### Surface Request

[What the user explicitly asked for]
</subsection>

<subsection id="5whys" title="5 Whys Analysis">
### 5 Whys Analysis

1. Why: [First why and answer]
2. Why: [Second why and answer]
3. Why: [Third why and answer]
4. Why: [Fourth why and answer]
5. Why: [Root cause identified]
   </subsection>

<subsection id="jtbd" title="Job to Be Done">
### Job to Be Done

**When** [situation/context]
**I want to** [motivation/goal]
**So I can** [expected outcome]

**Job Type:**

- Functional: [practical task]
- Emotional: [how they want to feel]
- Social: [how they want to be perceived]
</subsection>
</section>

<section id="workflow" title="Workflow Context">
<subsection id="current" title="Current State">
### Current State

[How the user currently accomplishes this]
</subsection>

<subsection id="pain" title="Pain Points">
### Pain Points

- [Pain point 1]
- [Pain point 2]
  </subsection>

<subsection id="map" title="Workflow Map">
### Workflow Map

```mermaid
[Before] → [Requested Action] → [After]
↓
[Related Actions]
```

</subsection>

<subsection id="stakeholders" title="Stakeholders">
### Stakeholders
- [Who else is involved or affected]
</subsection>
</section>

<section id="requirements" title="Requirements">
<subsection id="functional" title="Functional Requirements">
### Functional Requirements
1. [Requirement 1]
2. [Requirement 2]
</subsection>

<subsection id="non-functional" title="Non-Functional Requirements">
### Non-Functional Requirements
- Performance: [requirements]
- Security: [requirements]
- Accessibility: [requirements]
</subsection>

<subsection id="downstream" title="Anticipated Downstream Needs">
### Anticipated Downstream Needs
Based on workflow analysis:
- [Anticipated need 1]: [rationale]
- [Anticipated need 2]: [rationale]
</subsection>
</section>

<section id="options" title="Proposed Solution Options">
<subsection id="opt1" title="Option 1: [Minimum Viable]">
### Option 1: [Minimum Viable]
[Description of simplest solution]
- Pros: [benefits]
- Cons: [limitations]
</subsection>

<subsection id="opt2" title="Option 2: [Recommended]">
### Option 2: [Recommended]
[Description of recommended solution that addresses root need]
- Pros: [benefits]
- Cons: [limitations]
</subsection>

<subsection id="opt3" title="Option 3: [Comprehensive]">
### Option 3: [Comprehensive]
[Description of full-featured solution]
- Pros: [benefits]
- Cons: [limitations]
</subsection>
</section>

<section id="impact" title="Impact Assessment">
<subsection id="business" title="Business Outcome">
### Business Outcome
[What business goal does this support?]
</subsection>

<subsection id="metrics" title="Success Metrics">
### Success Metrics
- [Metric 1]: [target]
- [Metric 2]: [target]
</subsection>

<subsection id="behavior" title="Behavior Change Expected">
### Behavior Change Expected
[How will user behavior change after implementation?]
</subsection>
</section>

<section id="technical" title="Technical Considerations">
<subsection id="integration" title="Integration Points">
### Integration Points
- [System/API 1]
- [System/API 2]
</subsection>

<subsection id="constraints" title="Technical Constraints">
### Technical Constraints
- [Constraint 1]
- [Constraint 2]
</subsection>

<subsection id="references" title="Design References">
### Design References
- [Links to designs if applicable]
</subsection>
</section>

<section id="assumptions" title="Assumptions">
## Assumptions
- [Assumption 1]: [rationale]
- [Assumption 2]: [rationale]
</section>

<section id="questions" title="Open Questions">
## Open Questions
- [ ] [Question 1]
- [ ] [Question 2]
</section>

<section id="ac" title="Acceptance Criteria">
## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
</section>

<section id="recommendations" title="Recommendations">
## Recommendations

Based on the analysis, I recommend:

1. **Immediate**: [What to build now]
2. **Next**: [What to consider for follow-up]
3. **Future**: [What to keep in mind for roadmap]
</section>
</template>
