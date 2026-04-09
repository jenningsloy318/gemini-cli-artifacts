<template name="product-design-summary">
<header>
# Product Design Summary: [Feature Name]

**Date:** [timestamp]
**Selected Option:** Combined Option [X]

</header>

<section id="architecture" title="Architecture Decision">
<list>
<item>Approach: [Name]</item>
<item>Key patterns: [list]</item>
<item>Reference: [doc-index]-architecture.md</item>
</list>
</section>

<section id="ui-ux" title="UI/UX Decision">
<list>
<item>Approach: [Name]</item>
<item>Key patterns: [list]</item>
<item>Reference: [doc-index]-design-spec.md</item>
</list>
</section>

<section id="contracts" title="Cross-Domain Contracts">
<subsection id="api-to-ui" title="API -> UI Data Flow">
| API Endpoint | UI Component | Data Shape |
| ------------ | ------------ | ---------- |
| [endpoint]   | [component]  | [shape]    |
</subsection>
<subsection id="ui-to-api" title="UI -> API Interactions">
| User Action | API Call | Expected Response |
| ----------- | -------- | ----------------- |
| [action]    | [call]   | [response]        |
</subsection>
</section>

<section id="constraints" title="Constraints Applied">
<list>
<item>Architecture constraints on UI: [list]</item>
<item>UI requirements on architecture: [list]</item>
</list>
</section>

<section id="risks" title="Risk Mitigations">
<list>
<item>[Risk 1]: [Mitigation]</item>
<item>[Risk 2]: [Mitigation]</item>
</list>
</section>
</template>
