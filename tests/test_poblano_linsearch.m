% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: poblano_linesearch default parameters fun1
params = ncg('defaults');
params.Display = 'off';
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
[x,f,g,a] = poblano_linesearch(fun1, x0, fx0, gx0, 2, -gx0, params);
assert(all(abs(x - zeros(n,1)) < close_tol));
assert(abs(f - 0) < close_tol);
assert(all(abs(g - zeros(n,1)) < close_tol));
assert(abs(a - 1) < close_tol);

%% Test 2: poblano_linsearch too few arguments
params = ncg('defaults');
params.Display = 'off';
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
try
    [x,f,g,a] = poblano_linesearch(fun1, x0, fx0, gx0, 2, -gx0)
catch ME
    assert(strcmp(ME.message, 'POBLANO_LINESEARCH: too few arguments'));
end