%% Poblano Toolbox for MATLAB: Truncated Newton Optimization
% Truncated Newton (TN) methods for minimization are Newton methods in
% which the Newton direction is only approximated at each iteration (thus
% reducing computation). Furthermore, the Poblano implementation of the
% truncated Newton method does not require an explicit Hessian matrix in
% the computation of the approximate Newton direction (thus reducing
% storage requirements).
%
% The Poblano function for the truncated Newton method is called |tn|.
%%
%
% <html><hr></html>
%% Introduction
%
% The general steps of the TN method in Poblano is given below in high-level
% pseudo-code [1]:
%%
%
%
% $$
%  \begin{tabular}{ll}
%  \emph{1.} & Input: $x_0$, a starting point\\
%  \emph{2.} & Evaluate $f_0 = f(x_0), g_0 = \nabla f(x_0)$\\
%  \emph{3.} & Set $i=0$\\
%  \emph{4.} & \textbf{while} $\|g_i\| > 0$\\
%  \emph{5.} & \qquad Compute the conjugate gradient stopping tolerance, $\eta_i$\\
%  \emph{6.} & \qquad Compute $p_i$ by solving $\nabla^2f(x_i)p = -g_i$ using a linear conjugate gradient (CG) method\\
%  \emph{7.} & \qquad Compute a step length $\alpha_i$ and set $x_{i+1} = x_i + \alpha_i p_i$\\
%  \emph{8.} & \qquad Set $g_i = \nabla f(x_{i+1})$\\
%  \emph{9.} & \qquad Set $i = i + 1$\\
%  \emph{10.} & \textbf{end while}\\
%  \emph{11.} & Output: $x_i \approx x^*$\\
%  \end{tabular}
% $$
%% 
% *Notes*
%
% In Step 5, the linear conjugate gradient (CG) method stopping tolerance
% is allowed to change at each iteration. The input parameter
% |CGTolType| determines how $\eta_i$ is computed.
%%
% 
% In Step 6, 
%
% * One of Matlab's CG methods is used to solve for $p_i$: |symmlq|
% (designed for symmetric indefinite systems) or |pcg| (the classical CG
% method for symmetric positive definite systems). The input parameter
% |CGSolver| controls the choice of CG method to use.
%
% * The maximum number of CG iterations is specified using the input
% parameter |CGIters|.
%
% * The CG method stops when $\|-g_i - \nabla^2f(x_i)p_i\| \leq \eta_i\|g_i\|$ .
%
% * In the CG method, matrix-vector products involving $\nabla^2f(x_i)$ times
% a vector $v$ are approximated using the following finite difference
% approximation [1]:
% $\nabla^2f(x_i)v \approx \frac{\nabla f(x_i + \sigma v) - \nabla f(x_i)}{\sigma}$
%
% * The difference step, $\sigma$, is specified using the input parameter
% |HessVecFDStep|. The computation of the finite difference approximation
% is performed using the |hessvec_fd| provided with Poblano.
%%
%
% <html><hr></html>
%% Method Specific Input Parameters
%
% The input parameters specific to the |tn| method are presented below.
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentation for more details on the Poblano parameters shared across
% all methods.
%
%  CGSolver         Matlab CG method to use {'symmlq'}
%    'symmlq'       symmlq (designed for symmetric indefinite systems) 
%    'pcg'          pcg (designed for symmetric positive definite systems)
%
%  CGIters          Maximum number of conjugate gradient iterations allowed {5}
%
%  CGTolType        CG stopping tolerance type used {'quadratic'}
%    'quadratic'    ||R|| / ||G|| <  min(0.5,||G||)
%    'superlinear'  ||R|| / ||G|| <  min(0.5,sqrt(||G||))
%    'fixed'        ||R|| < CGTol
%                   where R is the residual and G is the gradient of FUN at X
%
%  CGTol            CG stopping tolerance when CGTolType is 'fixed' {1e-6}
%
%  HessVecFDStep    Hessian vector product finite difference step {1e-10}
%    0              Use iterate-based step: 1e-8*(1+||X||)
%    >0             Fixed value to use at the difference step 
%%
%
% <html><hr></html>
%% Default Input Parameters
% The default input parameters are returned with the following call to
% |tn|:
params = tn('defaults')
%%
% 
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentation for more details on the Poblano parameters shared across
% all methods.
%%
%
% <html><hr></html>
%% Examples
% Below are the results of using the |tn| method in Poblano to solve 
% example problems solved using the |ncg| method in the <B_ncg_docs.html
% Nonlinear Conjugate Gradient Optimization> and |lbfgs| method in the
% <C_lmbfgs_docs.html Limited-Memory BFGS Optimization> documentation.
%%
% *Example 1* (from <A4_poblano_examples_docs.html#4 Poblano Examples>)
%
% In this example, we have $x \in R^{10}$ and $a = 3$, and use a random
% starting point.
randn('state',0);
x0 = randn(10,1)
out = tn(@(x) example1(x,3), x0)
%%
%
% Note that in this example the line search in |tn| method displays a
% warning during iterations 1, 3 and 5, indicating that the norm of the
% search direction is nearly 0. In those cases, the steepest descent
% direction is used for the search direction during those iterations.
%%
% *Example 2*
%
% In this example, we compute a rank 2 approximation to a $4 \times 4$
% Pascal matrix (generated using the Matlab function |pascal(4)|). The
% starting point is a random vector. Note that in the interest of space,
% Poblano is set to display only the final iteration is this example.
m = 4; n = 4; k = 4; 
Data.rank = k; 
Data.A = pascal(m);
randn('state',0);
x0 = randn((m+n)*k,1);
out = tn(@(x) example2(x,Data), x0, 'Display', 'final')
%%
%
% As for the |ncg| and |lbfgs| methods, the fact that
% |out.ExitFlag| > 0 indicates that the method did not
% converge to the specified tolerance (i.e., the default |StopTol|
% input parameter value of |1e-5|). Since the maximum number of function
% evaluations was exceeded, we can increasing the number of maximum numbers
% of function evaluations and iterations allowed, and the optimizer
% converges to a solution within the specified tolerance.
out = tn(@(x) example2(x,Data), x0, 'MaxIters',1000, ...
    'MaxFuncEvals',10000,'Display','final')
%%
%
% Verifying the solution, we see that we find a matrix decomposition which
% fits the matrix with very small relative error (given the stopping
% tolerance of |1e-5| used by the optimizer).
[U,V] = example2_extract(m,n,k,out.X);
norm(Data.A-U*V')/norm(Data.A)
%%
%
% Again, in Example 2, we see that |tn| exhibits different behavior from
% that of the |ncg| and |lbfgs| methods. Thus, it is
% recommended that several test runs on smaller problems are performed
% initially using the different methods to help decide which method and set
% of parameters works best for a particular class of problems.
%%
%
% <html><hr></html>
%% References
%
% [1] Dembo, R.S. and and Steihaug, T. (1983). Truncated-Newton Algorithms for
% Large-Scale Unconstrained Minimization., _Mathematical Programming_, 26, 190-212.
%
