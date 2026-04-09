<template name="task-list">
<header>
# Task List: [Feature Name]

**Total Tasks:** [count]

</header>

<section id="tasks" title="Tasks">
<description>Granular, atomic tasks for execution.</description>
<subsection id="m1" title="Milestone 1: [Name]">
- [ ] **T1.1** [Description]
  - **Dependencies:** [Other tasks that must be completed first, e.g., T1.0]
  - **Files:** [path]
  - **Acceptance:** [criteria]
</subsection>

<subsection id="final" title="Final Tasks">
- [ ] **TF.1** Run tests (`npm test` / `cargo test`)
- [ ] **TF.2** Update project docs
- [ ] **TF.3** Code review
- [ ] **TF.4** Commit and push changes
</subsection>
</section>

<section id="dependencies" title="Task Dependencies">
<description>Visual or list representation of task ordering.</description>
[Dependency Map]
</section>
</template>
