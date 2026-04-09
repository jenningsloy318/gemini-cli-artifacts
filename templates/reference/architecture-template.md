<template name="architecture">
<header>
# Architecture: [Feature Name]

**Date:** [timestamp]
**Author:** super-dev:architecture-agent
**Status:** Draft

</header>

<section id="overview" title="Overview">
<description>2-3 sentences describing the architecture.</description>
[Overview Content]
</section>

<section id="drivers" title="Architectural Drivers">
<list>
<item>[Primary driver 1]</item>
<item>[Primary driver 2]</item>
</list>
</section>

<section id="modules" title="Module Architecture">
<description>ASCII diagram or Mermaid diagram showing modules and relationships.</description>
[Module Diagram]
</section>

<section id="specs" title="Module Specifications">
<subsection id="module-1" title="Module 1: [Name]">
- **Purpose:** [single sentence]
- **Responsibilities:**
  - [responsibility 1]
  - [responsibility 2]
- **Dependencies:** [list of modules this depends on]
- **Public Interface:**
  ```typescript
  interface [Name]Service {
    operation(): Promise<Result>;
  }
  ```
</subsection>
</section>

<section id="data-flow" title="Data Flow">
<description>Sequence or flow diagram showing data movement.</description>
[Data Flow Diagram]
</section>

<section id="tech-stack" title="Technology Stack">
| Layer | Technology | Rationale |
|-------|------------|-----------|
| [layer] | [tech] | [why] |
</section>

<section id="adrs" title="ADRs">
<list>
<item>ADR-001: [Title] - [link]</item>
<item>ADR-002: [Title] - [link]</item>
</list>
</section>

<section id="security" title="Security Considerations">
<list>
<item>[Security measure 1]</item>
<item>[Security measure 2]</item>
</list>
</section>

<section id="performance" title="Performance Considerations">
<list>
<item>[Performance measure 1]</item>
<item>[Performance measure 2]</item>
</list>
</section>

<section id="future" title="Future Considerations">
<list>
<item>[Item for future - NOT to be implemented now]</item>
</list>
</section>
</template>
