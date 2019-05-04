% fixtures
n = 10;
fun1 = @(x) unittest_sum_squares(x);
fun1_true_F = 0;
fun2 = @(x) unittest_sum_sin(x,1);
fun2_true_F = -1.0 * n;
close_tol = 1e-8;

%% Test 1: poblano_out default parameters fun1
params = inputParser;
params = poblano_params(params);
params.parse('Display','off');
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
out = poblano_out(x0, fx0, gx0, 1, params);

%% Test 2: poblano_out using previous result
params = inputParser;
params = poblano_params(params);
params.parse('Display','off');
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
out = poblano_out(x0, fx0, gx0, 1, params);
out2 = poblano_out(x0, fx0, gx0, 1, params, out);

%% Test 3: poblano_out using 0 old F
params = inputParser;
params = poblano_params(params);
params.parse('Display','off');
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
out = poblano_out(x0, fx0, gx0, 1, params);
out.F = 0;
out2 = poblano_out(x0, fx0, gx0, 1, params, out);

%% Test 4: poblano_out trace iterations
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off', ...
    'TraceX', true, ...
    'TraceFunc', true, ...
	'TraceRelFunc', true, ...
	'TraceGrad', true, ...
	'TraceGradNorm', true, ...
	'TraceFuncEvals', true ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
out = poblano_out(x0, fx0, gx0, 1, params);
out = poblano_out(x0, fx0, gx0, 1, params, out);
assert(all(all(abs(out.TraceX - [x0 x0]) < close_tol)));
assert(all(abs(out.TraceFunc - 9.092974268256818 * [1 1]) < close_tol));
assert(out.TraceRelFunc == 0);
assert(all(all(abs(out.TraceGrad - (-0.416146836547142 * ones(n,2))) < close_tol)));
assert(all(abs(out.TraceGradNorm - 1.315971844562770 * [1 1]) < close_tol));
assert(all(out.TraceFuncEvals == [1 1]));

%% Test 5: poblano_out MaxIters reached
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off', ...
    'MaxIters', 1 ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
out = poblano_out(x0, fx0, gx0, 1, params);
out.Iters = 1;
out = poblano_out(x0, fx0, gx0, 1, params, out);
assert(out.ExitFlag == 1);
assert(strcmp(out.ExitDescription, 'Maximum number of iterations exceeded'));

%% Test 6: poblano_out MaxFuncEvals reached
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off', ...
    'MaxFuncEvals', 1 ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
out = poblano_out(x0, fx0, gx0, 1, params);
out.MaxFuncEvals = 1;
out = poblano_out(x0, fx0, gx0, 1, params, out);
assert(out.ExitFlag == 2);
assert(strcmp(out.ExitDescription, 'Maximum number of function evaluations exceeded'));

%% Test 7: poblano_out NANs found F
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off' ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
out = poblano_out(x0, Inf, gx0, 1, params);
assert(out.ExitFlag == 4);
assert(strcmp(out.ExitDescription, 'NaN/Inf found in F, G, or norm(G)'));

%% Test 8: poblano_out NANs found G
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off' ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
gx0(end) = nan;
out = poblano_out(x0, fx0, gx0, 1, params);
assert(out.ExitFlag == 4);
assert(strcmp(out.ExitDescription, 'NaN/Inf found in F, G, or norm(G)'));

%% Test 9: poblano_out NANs found GXNORM
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','off' ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun2(x0);
out = poblano_out(x0, fx0, realmax*ones(n,1), 1, params);
assert(out.ExitFlag == 4);
assert(strcmp(out.ExitDescription, 'NaN/Inf found in F, G, or norm(G)'));

%% Test 10: poblano_out default parameters fun1
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','final', ...
    'StopTol', realmax ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
T = evalc('out = poblano_out(x0, fx0, gx0, 1, params);');
T2 = sprintf('%s\n%s\n%s\n', ...
    ' Iter  FuncEvals       F(X)          ||G(X)||/N        ', ...
    '------ --------- ---------------- ----------------', ...
    '     0         1      20.00000000       0.63245553');
assert(strcmp(T, T2));

%% Test 11: poblano_out default parameters fun1
params = inputParser;
params = poblano_params(params);
params.parse(...
    'Display','iter', ...
    'DisplayIters', 1 ...
);
x0 = 2 * ones(n,1);
[fx0,gx0] = fun1(x0);
T = evalc('out = poblano_out(x0, fx0, gx0, 1, params);');
out.Iters = 2;
T = evalc('out = poblano_out(x0, fx0, gx0, 1, params, out);');
T2 = sprintf('%s\n', ...
    '     3         2      20.00000000       0.63245553' ...
    );
assert(strcmp(T, T2));
