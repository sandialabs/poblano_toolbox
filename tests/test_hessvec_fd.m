% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: hessvec_fd 3 parameters
v = (1:n)';
x0 = 2 * ones(n,1);
hv = hessvec_fd(v, fun1, x0);
assert(all(abs(hv - v) < close_tol));

%% Test 2: hessvec_fd 4 parameters
v = (1:n)';
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
hv = hessvec_fd(v, fun1, x0, gx0);
assert(all(abs(hv - v) < close_tol));

%% Test 3: hessvec_fd 5 parameters
v = (1:n)';
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
small_step = 1e-10;
hv = hessvec_fd(v, fun1, x0, gx0, small_step);
assert(all(abs(hv - v) < sqrt(small_step)));

%% Test 4: hessvec_fd too few arguments
% should result in an error
try
    v = (1:n)';
    x0 = 2 * ones(n,1);
    [fx0,gx0] = fun1(x0);
    hv = hessvec_fd(v, fun1);
catch ME    
    assert(strcmp(ME.message, 'HESSVEC_FD => at least two input arguments are required (V,FUN,X)'));
end