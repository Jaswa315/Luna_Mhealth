## Pull Request Details

- **Repository Name:** `$(Build.Repository.Name)`
- **Source Branch:** `$(System.PullRequest.SourceBranch)`
- **Target Branch:** `$(System.PullRequest.TargetBranch)`

# Context
Describe what problem we are trying to solve.
# Changes
What did you change in the code? What files were added, removed, affected? What methods in the files were changed?
# Test Results
Screenshot output of E2E tests, relevant to PR

# Checklist

## Before submitting this PR, please make sure all boxes are checked:

### Pull Request
- [ ] Are errors handled by throwing/catching exceptions?
- [ ] Are all names descriptive (classes, methods, variables)?
- [ ] Does the method/class have a single responsibility?
- [ ] Is the logic simple and clear?
- [ ] Does code follow SOLID principles?
- [ ] Does work follow KISS principle?
- [ ] Uses simplest algorithm for today’s known use cases?
- [ ] Uses simplest data structure for today’s known use cases?
- [ ] Is the PR about one thing? (not multiple; just say no to PR creep)
- [ ] Are code comments limited to “why?” or “how?” for very complicated things?
- [ ] Do method comments clearly describe the method’s contract?
- [ ] No secrets such as configuration strings, certificates, passwords in PR?

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
- [ ] Is there appropriate telemetry in the code?

### Maintainability
- [ ] Does the code align with the DRY Principle? [see Don't Repeat Yourself (DRY)]
- [ ] Does the code not have duplicate lines of code?
- [ ] Does the code not duplicate lines of code found elsewhere in the project?
- [ ] Does the code have duplicate patterns related to the data (repeating / like use of data)?

### Test Coverage
- [ ] Is there a unit test for each code path?
- [ ] Does each unit test only test a single test case?
- [ ] Do the unit tests NOT use loops?
- [ ] Do the unit tests NOT use conditional branches?
- [ ] Do test methods have too many asserts?
- [ ] Are the set of unit tests sufficient and testing happy path, edge, and negative cases?
- [ ] Are there unit tests for expected exceptions that the production code might throw?
- [ ] Does the PR NOT include updates to the developer’s environment (e.g., version of Flutter)?

### Correctness
- [ ] **Input Validation**
  - [ ] Does the code check that the inputs are valid?
  - [ ] Does the code gracefully handle incorrect input values?
  - [ ] Are correct error responses returned, as appropriate? (4XX - not found, bad request | 5XX - server error | 2XX - OK)
  - [ ] Are the endpoint choices and verbs logical?
  - [ ] Does the code handle edge cases well?