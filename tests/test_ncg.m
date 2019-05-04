% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: ncg default parameters fun1
params = ncg('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = ncg(fun1, x0, params);
assert(abs(out.F - fun1_true_F) < close_tol);

%% Test 2: ncg default parameters fun2
params = ncg('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 3: ncg too few arguments
% should result in an error
try
    out = ncg(fun2);
catch ME    
    assert(strcmp(ME.message, 'Error: invalid input arguments'));
end

%% Test 4: ncg flectcher-reeves update
% method does not converge to close_tol, but does to sqrt(close_tol)
params = ncg('defaults');
params.Display = 'off';
params.Update = 'FR';
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < sqrt(close_tol));

%% Test 5: ncg polak-ribiere update
params = ncg('defaults');
params.Display = 'off';
params.Update = 'PR';
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 6: ncg hestenes-stiefel update
params = ncg('defaults');
params.Display = 'off';
params.Update = 'HS';
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 7: ncg steepest descent update
params = ncg('defaults');
params.Display = 'off';
params.Update = 'SD';
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 8: ncg invalid update
% should result in an error
try
    params = ncg('defaults');
    params.Display = 'off';
    params.Update = 'FOO';
    rng(1); x0 = randn(n,1);
    out = ncg(fun2, x0, params);
catch ME    
    assert(strcmp(ME.message, 'The value of ''Update'' is invalid. It must satisfy the function: @(x)ismember(x,{''FR'',''PR'',''HS'',''SD''}).'));
end

%% Test 9: ncg RestartIters 1
params = ncg('defaults');
params.Display = 'off';
params.RestartNW = true;
params.RestartIters = 1;
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 10: ncg RestartIters 20
params = ncg('defaults');
params.Display = 'off';
params.RestartNW = true;
params.RestartNWTol = 1e-18;
params.RestartIters = 20;
rng(1); x0 = randn(n,1);
out = ncg(fun2, x0, params);
assert(abs(out.F - fun2_true_F) < close_tol);

%% Test 11: ncg invalid RestartNWTol
% should result in an error
try
    params = ncg('defaults');
    params.Display = 'off';
    params.RestartNW = true;
    params.RestartNWTol = 0;
    rng(1); x0 = randn(n,1);
    out = ncg(fun2, x0, params);
catch ME    
    assert(strcmp(ME.message, 'The value of ''RestartNWTol'' is invalid. It must satisfy the function: @(x)x>0.'));
end

%% Test 12: ncg linesearch nonzero return
params = ncg('defaults');
params.Display = 'iter';
params.LineSearch_maxfev = 1;
rng(1); x0 = randn(n,1);
S = evalc('out = ncg(fun2, x0, params);');
assert(contains(S,'ncg: line search warning'));
