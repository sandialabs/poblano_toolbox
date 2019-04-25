%% Optimization Input Parameters
% Input parameters are passed to the different optimization methods using
% Matlab |inputParser| objects. Some parameters are shared across all
% methods and others are specific to a particular method. Below are
% descriptions of the shared input parameters and examples of how to set
% and use these parameters in the optimization methods. The Poblano
% function |poblano_params| is used by the optimization methods to set the
% input parameters.
%%
%
% <html><hr></html>
%% Parameters Shared Across All Methods
%
%%
% *Display Parameters*
%
% The following parameters control the information that is displayed during
% a run of a Poblano optimizer. 
%
%  Display                 Controls amount of printed output {'iter'}
%    'iter'                Display information every iteration
%    'final'               Display information only after final iteration
%    'off'                 Display no information
%
%  DisplayIters            Number of iterations performed before displaying
%                          printed out when Display parameter is set to
%                          'iter' {1}
%
% Example using default value of |'iter'|:
ncg(@example1, pi/4);
%%
% The per iteration information displayed contains the iteration number
% (|Iter|), total number of function evaluations performed thus far
% (|FuncEvals|), the function value at the current iterate
% (|F(X)|), and the norm of the gradient at the current iterate
% scaled by the problem size (|||||G(X)||||||/N|). After the final
% iteration is performed, the total iteration and function evaluations,
% along with the function value and scaled gradient norm at the solution
% found is displayed. Below is an example of the information displayed
% using the default parameters.
%%
% *Stopping Criteria Parameters*
%
% The following parameters control the stopping criteria of the
% optimization methods.
%
%  MaxIters                Maximum number of iterations allowed {1000}
%
%  MaxFuncEvals            Maximum number of function evaluations allowed {10000}
%
%  StopTol                 Gradient norm stopping tolerance, i.e., the 
%                          method stops when the norm of the gradient is less 
%                          than StopTol times the number of variables {1e-5}
%
%  RelFuncTol              Relative function value change stopping tolerance, 
%                          i.e., the method stops when the relative change 
%                          of the function value from one iteration to the 
%                          next is less than RelFuncTol {1e-6}
%
%%
% *Trace Parameters*
%
% The following parameters control the information that is saved and output
% for each iteration.
%
%  TraceX                  Flag to save a history of X (iterates) {false}
%
%  TraceFunc               Flag to save a history of the function values 
%                          of the iterates {false}
%
%  TraceRelFunc            Flag to save a history of the relative difference 
%                          between the function values at the current and 
%                          previous iterates {false}
%
%  TraceGrad               Flag to save a history of the gradients of the 
%                          iterates {false}
%
%  TraceGradNorm           Flag to save a history of the norm of the 
%                          gradients of the iterates {false} 
%
%  TraceFuncEvals          Flag to save a history of the number of function 
%                          evaluations performed at each iteration {false}
%%
% *Line Search Parameters*
%
% The following parameters control the behavior of the line search method
% used in the optimization methods.
%
%  LineSearch_xtol         Stopping tolerance for minimum change input 
%                          variable {1e-15}
%
%  LineSearch_ftol         Stopping tolerance for sufficient decrease 
%                          condition {1e-4}
%
%  LineSearch_gtol         Stopping tolerance for directional derivative 
%                          condition {1e-2}
%
%  LineSearch_stpmin       Minimum step to take {1e-15}
%
%  LineSearch_stpmax       Maximum step to take {1e15}
%
%  LineSearch_maxfev       Maximum number of iterations {20}
%
%  LineSearch_initialstep  Initial step to be taken in the line search {1}
%
%%
%
% <html><hr></html>
%% Method-Specific Parameters
%
% *Nonlinear Conjugate Gradent Minimization* (|ncg|) <B_ncg_docs.html Method details>
%
%  Update                  Conjugate direction update {'PR'}
%    'FR'                  Fletcher-Reeves
%    'PR'                  Polak-Ribiere 
%    'HS'                  Hestenes-Stiefel
%    'SD'                  Steepest Decsent
%
%  RestartIters            Number of iterations to run before conjugate 
%                          direction restart {20}
%
%  RestartNW               Flag to use restart heuristic of Nocedal and 
%                          Wright {false}
%
%  RestartNWTol            Tolerance for Nocedal and Wright restart 
%                          heuristic {0.1}
%
%
% *Limited-memory BFGS Minimization* (|lbfgs|) <C_lmbfgs_docs.html Method details>
%
%  M                       Limited memory parameter {5}
%
%
% *Truncated Newton Minimization* (|tn|) <D_tn_docs.html Method details>
%
%  CGSolver                Matlab conjugate gradient (CG) method used to 
%                          solve for search direction {'symmlq'}
%    'symmlq'              Symmetric LQ method
%    'pcg'                 Classical CG method
%
%  CGIters                 Maximum number of CG iterations allowed {5}
%
%  CGTolType               CG stopping tolerance type used {'quadratic'}
%    'quadratic'           ||R|| / ||G|| <  min(0.5,||G||)
%    'superlinear'         ||R|| / ||G|| <  min(0.5,sqrt(||G||))
%    'fixed'               ||R|| < CGTol
%                          where R is the residual and G is the gradient 
%                          of FUN at X
%
%  CGTol                   CG stopping tolerance when CGTolType is 
%                          'fixed' {1e-6}
%
%  HessVecFDStep           Hessian vector product finite difference step {1e-10}
%    0                     Use iterate-based step: 1e-8*(1+||X||)
%    >0                    Fixed value to use as the difference step 
%%
%
% <html><hr></html>
%% Default Parameters
% The default input parameters are returned using the sole input of
% |'defaults'| to one of the Poblano optimization methods:
ncg_default_params = ncg('defaults')
lbfgs_default_params = lbfgs('defaults')
tn_default_params = tn('defaults')
%%
%
% <html><hr></html>
%% Passing Parameters to Methods
%
% As mentioned above, input parameters are passed to the Poblano
% optimization methods using Matlab |inputParser| objects. Below are
% several examples of passing parameters to Poblano methods. For more
% detailed description of |inputParser| objects, see the Matlab
% documentation.
%%
% *Case 1: Using default input parameters.*
%
% To use the default methods, simply pass the function handle to the
% function/gradient method and a starting point to the optimization method
% (i.e., do not pass any input parameters into the method).
ncg(@(x) example1(x,3), pi/4);
%%
% *Case 2: Passing parameter-value pairs into a method.*
%
% Instead of passing a structure of input parameters, pairs of parameters
% and values may be passed as well. In this case, all parameters not
% specified as input use their default values. Below is an example of
% specifying a parameter in this way.
ncg(@(x) example1(x,3), pi/4,'Display','final');
%%
% *Case 3: Passing input parameters as fields in a structure.*
%
% Input parameters can be passed as fields in a structure. Note, though,
% that since each optimization method uses method specific parameters, it
% is suggested to start from a structure of the default parameters for a
% particular method. Once the structure of default parameters has been
% created, the individual parameters (i.e., fields in the structure) can be
% changed. Below is an example of this for the |ncg| method.
params = ncg('defaults');
params.MaxIters = 1;
ncg(@(x) example1(x,3), pi/4, params);
%%
% *Case 4: Using parameters from one run in another run.*
%
% One of the outputs returned by the Poblano optimization methods is the
% |inputParser| object of the input parameters used in that run. That
% object contains a field called |Results|, which can be passed as the
% input parameters to another run. For example, this is helpful when
% running comparisons of methods where only one parameter is changed. Shown
% below is such an example, where default parameters are used in one run,
% and the same parameters with just a single change are used in another
% run.
out = ncg(@(x) example1(x,3), pi./[4 5 6]');
params = out.Params.Results;
params.Display = 'final';
ncg(@(x) example1(x,3), pi./[4 5 6]',params);
