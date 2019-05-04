# Tests for Poblano Toolbox for MATLAB

Name each test file as `test_<something>.m`, replacing `<something>`
with the name of the method being tested.

## Running the Tests
``` matlab
r=runtests; % Runs all tests
table(r) % View results
r=runtests('test_gradientcheck.m'); % Runs just the tests in that file
```

## Creating New Tests
Copy one of the existing tests as a guide and modify to do tests
relvant for the m-files being created. See the MATLAB documentation on
`Script-Based Unit Tests` for more information.

## Coverage Report
You can run a coverage report associated with the tests in this
directory by running `poblano_coverage`.