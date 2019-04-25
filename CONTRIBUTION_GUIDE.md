# Poblano Toolbox Contribution Guide

## Checklist

- [ ] **Issue** Before the pull request, submit an issue for the change, providing as much detailed information as possible. For bug reports, please provide enough information to reproduce the problem.

- [ ] **Fork** Create a branch or fork of the code and make your changes.

- [ ] **Help Comments** Create or update comments for the m-files, following the style of the existing files. Be sure to explain all code options.

- [ ] **Documentation** For any major new functionality, please follow the following steps.
  - [ ] Add MATLAB script documentation in the `doc` directory with the name `XXX_doc.m`
  - [ ] Use the MATLAB `publish` command on `XXX_doc.m` and the `mxdom2simplehtml_poblano.xsl` as the stylesheet to create a new file in `doc\html` 
  - [ ] Add a pointer to this documentation file in `doc\html\helptoc.xml`
  - [ ] Add pointers in any related higher-level files, e.g., a new method for be referenced in the `html/methods.html` file
  - [ ] Add link to HTML documentation from help comments in function

- [ ] **Tests** Create or update tests in the `tests` directory, especially for bug fixes or strongly encouraged for new code.

- [ ] **Contents** If new functions were added at top level, go to `maintenance` and run `update_topcontents` to update the Contents.m file at the top level.

- [ ] **Release Notes** Include release notes in this checklist in the pull request associated with this contribution. Include any significant bug fixes or additions.

- [ ] **Contributors List** Update `CONTRIBUTORS.md` with your name and a brief description of the contributions.

- [ ] **Pass All Tests** Confirm that all tests (including existing tests) pass in `tests` directory.

- [ ] **Create Pull Request** At any point, create a work-in-progress pull request, referencing the issue number and with this checklist and `WIP` in the header.

- [ ] **Submit Pull Request** Once all of the items of this checklist in the pull request have been completed, submit the pull request.

