Decisions Register
================

This file documents design decisions - 

---
## ADR-001: Adopt a data-model-first development strategy

### Decision

The whole system is to be modelled using VO-DML and the [VO-DML tooling](https://ivoa.github.io/vo-dml/)

### Consequences

- Artefacts for use in OpenAPI schema are automatically generated
- There is tight coupling between the derived components
  - This will be speed early development and integration
  - There might need to be some decoupling in later development 

---