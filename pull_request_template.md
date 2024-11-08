# Context
Describe what problem we are trying to solve.
# Changes
What did you change in the code?
Why did you change code?
# Notes


# Checklist

## Before submitting this PR, please make sure all boxes are checked:

### Pull Request
- [ ] Are errors handled by throwing/catching exceptions?
- [ ] Are all names descriptive (classes, methods, variables)?
- [ ] Does the code align with the DRY Principle? [see Don't Repeat Yourself (DRY)]
- [ ] Does the code handle edge cases well?
- [ ] Does the method/class have a single responsibility?
- [ ] Is the logic simple and clear?
- [ ] Does code follow SOLID principles?
- [ ] Does work follow KISS principle?
- [ ] Is the PR about one thing? (not multiple; just say no to PR creep)

### Understandability
- [ ] Do you understand the code?
- [ ] Does each method name clearly describe what that method does?
- [ ] Does each class name clearly describe what that class does?
- [ ] Are code comments limited to describing rationales for code design, rather than what the code does?
- [ ] Is each method less than ~30 lines of code? [see Short methods]
- [ ] Does the code have low cyclomatic complexity? [see Cyclomatic complexity]
- [ ] Does the code use constants for all magic literals?
- [ ] Are there meaningful, necessary triple slashed comments (for Dart documentation) for all public functions?

### Process
- [ ] Is the PR “right sized”?
- [ ] Is the PR a small chunk of tightly-coupled code changes? [Not a mega-PR.]
- [ ] Was there a new branch for each user story or bug, at least?

### Test Coverage
- [ ] Is there a unit test for each code path?
- [ ] Does each unit test only test a single test case?
- [ ] Do the unit tests NOT use loops?
- [ ] Do the unit tests NOT use conditional branches?
- [ ] Do test methods have too many asserts?
- [ ] Are the set of unit tests sufficient and testing happy path, edge, and negative cases?
- [ ] Are there unit tests for expected exceptions that the production code might throw?
- [ ] Does the PR NOT include updates to the developer’s environment (e.g., version of Flutter)?


  For a more comprehensive checklist, please visit the Luna mHealth Code Checklist at https://docs.google.com/document/d/1uwLg5870LtvyxgchD7Cz7HWUYzQWyyVghyBRTG7YKMA/edit?usp=sharing