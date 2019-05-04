import matlab.unittest.TestSuite
import matlab.unittest.TestRunner
import matlab.unittest.plugins.CodeCoveragePlugin

suite = TestSuite.fromFolder('.');

runner = TestRunner.withTextOutput;

runner.addPlugin(CodeCoveragePlugin.forFolder('../'))
result = runner.run(suite);
