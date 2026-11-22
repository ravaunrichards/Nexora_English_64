# NEXORA English x64 implementation roadmap

Status labels: **Not started**, **In progress**, **Implemented — untested**, **Tested**. A phase may be marked Tested only when evidence is recorded. Documentation alone is not implementation.

| Phase | Scope | Current status |
|---|---|---|
| 1 | Repository inspection, provenance, inventory and risk audit | In progress — baseline report committed; full provenance and binary review outstanding |
| 2 | NEXORA source layout, identity and branding | In progress — Linux source isolated; initial release metadata added |
| 3 | Ubuntu base, kernel, boot chain and core services | Implemented — untested — live-build configuration and package selection added |
| 4 | KDE Plasma desktop, NEXORA Desktop and Classic layouts | In progress — upstream Plasma package selection only |
| 5 | Settings, file manager, terminal, task, device, update and recovery tools | In progress — base applications selected; NEXORA system utility added |
| 6 | Hardware discovery and driver support | Not started — Ubuntu driver tooling selected; hardware matrix absent |
| 7 | Networking, sharing, VPN, remote access and protocols | In progress — NetworkManager and BlueZ selected; service configuration and tests outstanding |
| 8 | Administration and migration utilities | Not started — compatibility and licensing review required; Flash explicitly excluded |
| 9 | Virtualization and developer tools | Not started |
| 10 | Audio, video and multimedia | In progress — basic desktop media packages selected |
| 11 | Gaming and graphics stack | Not started |
| 12 | Security, privacy, firewall and update policy | In progress — Ubuntu package base selected; hardening and validation outstanding |
| 13 | NEXORA ecosystem, store, update, cloud and AI integration | Not started |
| 14 | Installer, partitioning, recovery and bootable release | In progress — live ISO configuration only; installer not implemented |
| 15 | Reproducible builds, CI and automated tests | In progress — manual CI build and source checks added; reproducibility and boot tests outstanding |
| 16 | Documentation, release engineering and maintenance | In progress — build, testing and architecture docs added |

## Completion gate for every phase

A phase is not complete until its source changes are committed, configuration is integrated, automated checks pass, relevant runtime tests are performed, known limitations are documented, and the owner can reproduce the result. No test status is inferred from a successful file upload or CI configuration alone.
