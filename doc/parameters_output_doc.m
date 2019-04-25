%% Optimization Output Parameters
%
% Each of the optimization methods in Poblano outputs a single structure
% containing fields for the approximate solution, function and gradient
% values at the solution, and various information about the optimization
% run (e.g., number of function evaluations, etc.). The Poblano function
% |poblano_out| is used by the optimization methods to set the output
% parameters.
%%
%
% <html><hr></html>
%
%% Output Parameters
%
% Each of the optimization methods in Poblano outputs a single structure
% containing fields described below.
%
%  X                Final iterate
%
%  F                Function value at X
%
%  G                Gradient at X
%
%  Params           Input parameters used for the minimization method (as 
%                   parsed Matlab inputParser object)
%
%  FuncEvals        Number of function evaluations performed 
%
%  Iters            Number of iterations performed (see individual minimization
%                   routines for details on what each iteration consists of
%
%  ExitFlag         Termination flag, with one of the following values
%                   0 : scaled gradient norm < StopTol input parameter)
%                   1 : maximum number of iterations exceeded
%                   2 : maximum number of function values exceeded
%                   3 : relative change in function value < RelFuncTol input parameter
%                   4 : NaNs found in F, G, or ||G||
%
%  ExitDescription  Text description of the termination flag
%%
%
% <html><hr></html>
%% Optional Trace Output Parameters
% Additional output parameters returned by the Poblano optimization methods
% are presented below. The histories (i.e., traces) of different variables
% and parameters at each iteration are returned as output parameters if the
% corresponding input parameters are set to |true| (see the
% <A2_poblano_params_docs.html Optimization Input Parameters> documentation 
% for more details on the input parameters).
%
%  TraceX           History of X (iterates)
%
%  TraceFunc        History of the function values of the iterates
%
%  TraceRelFunc     History of the relative difference between the function 
%                   values at the current and previous iterates
%
%  TraceGrad        History of the gradients of the iterates
%
%  TraceGradNorm    History of the norm of the gradients of the iterates
%
%  TraceFuncEvals   History of the number of function evaluations performed 
%                   at each iteration
%%
%
% <html><hr></html>
%% Example Output
% 
%%
% The following example shows the output produced when the default
% input parameters are used.
out = ncg(@(x) example1(x,3), pi/4)
%%
% The following example presents an example where a method terminates
% before convergence (due to a limit on the number of iterations allowed).
out = ncg(@(x) example1(x,3), pi/4,'MaxIters',1)
%%
% The following shows the ability to save traces of the different
% information for each iteration.
out = ncg(@(x) example1(x,3), [1 2 3]','TraceX',true,'TraceFunc', true, ...
    'TraceRelFunc',true,'TraceGrad',true,'TraceGradNorm',true,'TraceFuncEvals',true)
%%
% We can examine the final solution and its gradient (which list only their
% sizes when viewing the output structure):
X = out.X
G = out.G
%%
% We can also see the values of |X| (current iterate) and its
% gradient |G| for each iteration (including iteration 0, which just
% computes the function and gradient values of the initial point):
out.TraceX
out.TraceGrad
