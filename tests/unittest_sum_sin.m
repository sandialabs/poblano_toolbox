% fixture: function
function [f,g] = sum_sin(x,a)

if nargin < 2, a = 1; end
f = sum(sin(a*x));
g = a*cos(a*x);

end
