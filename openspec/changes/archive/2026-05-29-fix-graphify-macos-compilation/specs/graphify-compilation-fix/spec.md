## ADDED Requirements

### Requirement: Export SDKROOT for macOS compilation
The system SHALL export the macOS SDK root path dynamically when building packages in the Home Manager activation script.

#### Scenario: Compiling Graphify on macOS
- **WHEN** Home Manager activation runs on macOS Darwin
- **THEN** it SHALL set `SDKROOT` to the output of `xcrun --show-sdk-path` before installing Graphify
