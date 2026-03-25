---
description: How to update the app version and build number for App Store Connect
---

# Versioning Workflow

This workflow describes how to update the version and build number for the NotifyPR app.

## Rules

1. **Marketing Version (`MARKETING_VERSION`)**:
    - This is the user-facing version (e.g., 1.2, 1.3).
    - It should be incremented for new features or major fixes.
2. **Build Version (`CURRENT_PROJECT_VERSION`)**:
    - This is the internal build number (e.g., 1, 2, 3, 4, 5).
    - **CRITICAL**: The build version must **ALWAYS** be strictly higher than the highest build number ever uploaded to App Store Connect for *any* version of the app.
    - If you encounter a "Redundant Binary Upload" error, increment the build number.
    - If you encounter a "must contain a higher version than that of the previously uploaded version" error, increment the build number to be higher than the one mentioned in the error.

## Steps

### 1. Update Version and Build

You can use `agvtool` or update the `project.pbxproj` file manually.

#### Using agvtool:
```bash
xcrun agvtool new-marketing-version <new_version>
xcrun agvtool new-version <new_build>
```

#### Manually:
Update all occurrences of `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in `NotifyPR.xcodeproj/project.pbxproj`.

### 2. Verify

Run the following command to verify the current settings:
```bash
xcrun agvtool what-marketing-version && xcrun agvtool what-version
```
