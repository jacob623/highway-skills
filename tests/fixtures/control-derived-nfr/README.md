# Control-Derived NFR Fixtures

These fixtures model disposable user-owned governance trees for the Control-derived NFR contract.
Focused tests copy them under a temporary `library/governance/` directory and never write the live
root-level user-owned governance baseline.

The fixture set covers deterministic candidate rules, zero candidates, multiple candidates, existing
relationships, safe NFR allocation, malformed catalogs, and unsafe `next_id` state. It is not a
second relationship store and does not represent a shipped governance baseline.
