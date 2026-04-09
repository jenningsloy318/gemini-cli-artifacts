<template name="test-report">
<header>
# Test Execution Report: [Feature/Fix Name]

**Date:** [timestamp]
**Author:** super-dev:qa-agent
**Application Modality:** CLI / Web / Desktop

</header>

<section id="summary" title="1. Executive Summary">
<list>
- **Total Tests Run:** [count]
- **Passed:** [count]
- **Failed:** [count]
- **Skipped:** [count]
- **Duration:** [time]
</list>

<subsection id="coverage" title="Coverage Metrics">
<list>
- **Overall Coverage:** [%]
- **New Code Coverage:** [%]
</list>
</subsection>
</section>

<section id="results" title="2. Test Results by Category">
<subsection id="static" title="Static Analysis">
[Summary of lint/typecheck/CodeRabbit results]
</subsection>
<subsection id="unit" title="Unit & Integration Tests">
[Pass/Fail summary]
</subsection>
<subsection id="e2e" title="End-to-End / Browser Smoke Tests">
[Pass/Fail summary]
</subsection>
</section>

<section id="bdd" title="3. BDD Scenario Coverage (MANDATORY)">
<table>
<header>
<column>Scenario ID</column>
<column>Test Implementation</column>
<column>Status</column>
</header>
<row>
<cell>SCENARIO-001</cell>
<cell>`test_login_success` in `auth.test.ts`</cell>
<cell>PASS</cell>
</row>
</table>
</section>

<section id="defects" title="4. Defects Found (If Any)">
<subsection id="def-1" title="DEF-001: [Title]">
- **Severity:** Critical/High/Medium/Low
- **Scenario/Test Case:** SCENARIO-XXX
- **Expected:** [expectation]
- **Actual:** [reality]
- **Evidence:** [log snippet or error trace]
</subsection>
</section>

<section id="artifacts" title="5. Artifacts">
<list>
- Test traces: `./traces/`
- Screenshots: `./screenshots/`
- Network logs: `./network/`
</list>
</section>
</template>
