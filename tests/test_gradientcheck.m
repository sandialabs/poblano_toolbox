% fixtures
x0 = ones(100,1);
true_MaxDiff = -8.274037099909037e-08;
true_NormGradientDiffs = 8.274037099909037e-07;
fun = @(x) unittest_sum_squares(x);

%% Test 1: gradientcheck forward differences
out = gradientcheck(fun, x0, 'DifferenceType', 'forward');
assert(abs(out.MaxDiff) < length(x0) * out.Params.DifferenceStep)
assert(abs(out.MaxDiff-true_MaxDiff) < out.Params.DifferenceStep);
assert(abs(out.NormGradientDiffs-true_NormGradientDiffs) < out.Params.DifferenceStep);

%% Test 2: gradientcheck backward differences
out = gradientcheck(fun, x0, 'DifferenceType', 'backward');
assert(abs(out.MaxDiff) < length(x0) * out.Params.DifferenceStep)
assert(abs(out.MaxDiff-true_MaxDiff) < out.Params.DifferenceStep);
assert(abs(out.NormGradientDiffs-true_NormGradientDiffs) < out.Params.DifferenceStep);

%% Test 3: gradientcheck backward differences
out = gradientcheck(fun, x0, 'DifferenceType', 'centered');
assert(abs(out.MaxDiff) < length(x0) * out.Params.DifferenceStep)
assert(abs(out.MaxDiff-true_MaxDiff) < out.Params.DifferenceStep);
assert(abs(out.NormGradientDiffs-true_NormGradientDiffs) < out.Params.DifferenceStep);

%% Test 4: gradientcheck using parameters struct
params = struct('DifferenceType', 'backward');
out = gradientcheck(fun, x0, params);
assert(strcmp(out.Params.DifferenceType, params.DifferenceType));
