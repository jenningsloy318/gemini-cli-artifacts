<template name="validation-report">
<header>
# Documentation Validation: [Final File Name]

**Date:** [timestamp]
**Validator:** super-dev:doc-validator
**Status:** [PASS / REJECT]
**Phase:** [Phase Name]
**Rename Occurred:** [Yes (Old: [name]) / No]

</header>

<section id="summary" title="Executive Summary">
<description>Brief 1-2 sentence assessment of document quality.</description>
[Executive Summary Content]
</section>

<section id="checklist" title="Validation Checklist">
- [ ] Mandatory naming convention followed (`[doc-index]-...`)
- [ ] Aligns with previous artifacts
- [ ] Technically accurate and feasible
- [ ] Edge cases and error paths addressed
- [ ] No prohibited generic names
</section>

<section id="findings" title="Findings">
<subsection id="critical" title="Critical (Blocking)">
**V-001** | [Category]
**Issue:** [description]
**Required:** [concrete fix]
**Rationale:** [why it matters]
</subsection>

<subsection id="minor" title="Minor (Non-Blocking)">
[Same format]
</subsection>
</section>

<section id="verdict" title="Verdict">
**[PASS / REJECT]**

**Reasoning:** [Final technical justification for the verdict]

</section>
</template>
