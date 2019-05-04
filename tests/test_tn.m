% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: tn default parameters fun1
params = tn('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = tn(fun1, x0, params);
assert(abs(out.F - fun1_true_F) < close_tol);

%% Test 2: tn default parameters fun2
params = tn('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = tn(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 3: tn too few arguments
% should result in an error
try
    out = tn(fun2);
catch ME    
    assert(strcmp(ME.message, 'Error: invalid input arguments'));
end

%% Test 4: tn CGTolType superlinear
params = tn('defaults');
params.Display = 'off';
params.CGTolType = 'superlinear';
rng(1); x0 = randn(n,1);
out = tn(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 5: tn HessVecFDStep default
params = tn('defaults');
params.Display = 'off';
params.HessVecFDStep = 0;
rng(1); x0 = randn(n,1);
out = tn(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 6: tn linesearch nonzero return
params = tn('defaults');
params.Display = 'iter';
params.LineSearch_maxfev = 1;
rng(1); x0 = randn(n,1);
S = evalc('out = tn(fun2, x0, params);');
assert(contains(S,'tn: line search warning'));

