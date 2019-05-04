% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: cvsrch defaults
params = ncg('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
x0 = 2 * ones(n,1);
[f0,g0] = fun2(x0);
a0 = params.LineSearch_initialstep;
d0 = -g0;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(all(abs(x - 4.712236570537566*ones(n,1)) < close_tol));
assert(abs(f - (-9.999999883856193)) < close_tol);
assert(all(abs(g - (-0.000152409846533415)*ones(n,1)) < close_tol));
assert(abs(a - (6.517498950710673)) < close_tol);
assert(lsinfo == 1);
assert(lsnfev == 5);

%% Test 2: cvsrch incorrect inputs
params = ncg('defaults');
params.Display = 'off';
rng(1); x0 = randn(n,1);
x0 = 2 * ones(n,1);
[f0,g0] = fun2(x0);
a0 = params.LineSearch_initialstep;
d0 = -g0;
% empty x0
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,[],f0,g0,a0,d0,params);
assert(lsinfo == 0);
% negative step length
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,-1,d0,params);
assert(lsinfo == 0);
% negative xtol
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_xtol = -1;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);
% negative ftol
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_ftol = -1;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);
% negative gtol
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_gtol = -1;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);
% negative stpmin
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_stpmin = -1;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);
% stpmax < stpmin
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_stpmin = 1e-3;
params.LineSearch_stpmax = 1e-4;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);
% zero max evals 
params = ncg('defaults');
params.Display = 'off';
params.LineSearch_maxfev = 0;
[x,f,g,a,lsinfo,lsnfev] = cvsrch(fun2,x0,f0,g0,a0,d0,params);
assert(lsinfo == 0);

