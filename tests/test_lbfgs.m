% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: lbfgs default parameters fun1
params = lbfgs('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = lbfgs(fun1, x0, params);
assert(abs(out.F - fun1_true_F) < close_tol);

%% Test 2: lbfgs default parameters fun2
params = lbfgs('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = lbfgs(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 3: lbfgs too few arguments
% should result in an error
try
    out = lbfgs(fun2);
catch ME    
    assert(strcmp(ME.message, 'Error: invalid input arguments'));
end