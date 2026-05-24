# Cacomi - Example Projects

## Sample Projects for App Review

This repository contains sample projects that App Review can use to verify the main features and functionality of **Cacomi**.

**Cacomi** is a macOS developer tool that analyzes app project source files and helps identify:

- Potentially unused Swift code
- Potentially unused SwiftUI code
- Potentially unused Objective-C code
- Debug logging statements such as `print`, `debugPrint`, `NSLog`, and similar calls
- Code sections that can be reviewed, commented out, deleted, or wrapped in debug-only compilation blocks

These sample projects are provided specifically so App Review can test the app without needing to supply their own project files.

## How the App Works

1. Open Cacomi on macOS.
2. Click **Analyze Project**.
3. Select one of the sample project folders included in this repository.
4. Cacomi scans the supported source files in the selected project.
5. The app displays files and code sections that may contain unused code or debug logging statements.
6. Select any result to preview the detected code.
7. Use the available actions to comment out code, delete code, wrap debug logs inside `#if DEBUG` blocks, or undo the last action.
8. After each action, the preview updates and Cacomi recalculates the remaining detected items.

## Sample Projects Included

This repository includes small example projects designed to trigger different parts of the app analysis.

### Example projects are located in:

```text
Examples/SwiftExamples/CalculatorDemo
Examples/ObjectiveCExamples/CalculatorOld

```


## Screenshots 

### 1. Open Cacomi
Start by opening Cacomi and choosing a project to analyze. You can drag and drop a supported project folder into the drop area.
![Open Cacomi](screenshots/1.png)

### 2. Analyze the project
After selecting a project, Cacomi scans the supported source files and looks for potentially unused code and debug logging statements.
![Select a Sample Project](screenshots/2.png)

### 3. Preview the Prints
The **Prints & Logs** tab shows detected debug statements such as `print`, `debugPrint`, `NSLog`, and similar logging calls. Select any result to preview the exact code before making changes.

![Detected Unused Code](screenshots/3.png)

### 4. Review Detected Unused Code and Comment It, also you can delete it.

Cacomi shows potentially unused code with a preview of the detected section. Review each result, then choose whether to comment it out or delete it from the selected sample project.
![Code Preview](screenshots/4_1.png)

### 5. You can Wrap the print() blocks of code as well
Detected print or log blocks can be wrapped inside debug-only compilation blocks, such as `#if DEBUG ... #endif`, so they are excluded from release builds.
![Comment or Delete Code](screenshots/3_1.png)

### 6. It supports Objective-C projects too.
Cacomi also supports Objective-C projects. It can detect potentially unused Objective-C methods and logging statements such as `NSLog`.

Objective-C log results can be previewed, commented, deleted, or wrapped in debug-only blocks just like Swift and SwiftUI results.

![Print and Log Results](screenshots/7.png)

![Wrap Logs and Undo](screenshots/8.png)

