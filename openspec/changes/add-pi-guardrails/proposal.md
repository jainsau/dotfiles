## Why

Pi extension setup should include workspace/file/command guardrails in addition to the existing rhubarb-pi utilities. This keeps secret and destructive-operation protections reproducible from the kit rather than relying on ad-hoc local installs.

## What Changes

- Add `npm:@aliou/pi-guardrails` to the declarative Pi extension kit.
- Keep `rhubarb-pi` installed for SCIP tooling and optional notification/safety utilities.
- Install the guardrails package in the current user Pi environment for immediate use.

## Scope

- Does not remove rhubarb-pi or its selected extensions.
- Does not change model/provider configuration.
