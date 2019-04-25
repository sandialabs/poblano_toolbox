%% Limited-Memory BFGS Optimization
% Limited-memory quasi-Newton methods [2] are a class of methods that
% compute and/or maintain simple, compact approximations of the Hessian
% matrices of second derivatives, which are used determining search
% directions. Poblano includes the limited-memory BFGS (L-BFGS) method, a
% variant of these methods whose Hessian approximations are based on the
% BFGS method (see [1] for more details).
%
% The Poblano function for the L-BFGS method is called |lbfgs|.
%%
%
% <html><hr></html>
%% Introduction
% The general steps of L-BFGS methods are given below in high-level
% pseudo-code [2]:
%%
%
% 
% $$
% \begin{tabular}{ll}
% \emph{1.} & Input: $x_0$, a starting point; $M > 0$, an integer\\
% \emph{2.} & Evaluate $f_0 = f(x_0)$, $g_0 = \nabla f(x_0)$\\
% \emph{3.} & Set $p_0 = -g_0$, $\gamma_0 = 1$, $i = 0$\\
% \emph{4.} & \textbf{while} $\|g_i\| > 0$\\
% \emph{5.} & \qquad Choose an initial Hessian approximation: $H_i^0 = \gamma_i I$\\
% \emph{6.} & \qquad Compute a step direction $p_i = -r$ using {\tt TwoLoopRecursion} method\\
% \emph{7.} & \qquad Compute a step length $\alpha_i$ and set $x_{i+1} = x_i + \alpha_i p_i$\\
% \emph{8.} & \qquad Set $g_i = \nabla f(x_{i+1})$\\
% \emph{9.} & \qquad \textbf{if} $i > M$\\
% \emph{10.} & \qquad \qquad Discard vectors $\left\{s_{i-m}, y_{i-m}\right\}$ from storage\\
% \emph{11.} & \qquad \textbf{end if}\\
% \emph{12.} & \qquad \qquad Set and store $s_i = x_{i+1}-x_i$ and $y_i = g_{i+1} - g_i$\\
% \emph{13.} & \qquad Set $i = i + 1$\\
% \emph{14.} & \textbf{end while}\\
% \emph{15.} & Output: $x_i \approx x^*$\\
% \end{tabular}
% $$
%
%% 
% *Computing the step direction*
%
% In Step 6 in the above method, the computation of the step direction is
% performed using the following method (assume we are at iteration $i$) [2]:
%%
%
% $$
% \begin{tabular}{ll}
% \multicolumn{2}{l}{\tt TwoLoopRecursion}\\
% \emph{1.} & $q = g_i$\\
% \emph{2.} & \textbf{for} $k = i-1, i-2, \dots, i-m$\\
% \emph{3.} & \qquad $a_k = (s_k^Tq)/(y_k^Ts_k)$\\
% \emph{4.} & \qquad $q = q - a_k y_k$\\
% \emph{5.} & \textbf{end for}\\
% \emph{6.} & $r = H_i^0 q$\\
% \emph{7.} & \textbf{for} $k = i-m, i-m+1, \dots, i-1$\\
% \emph{8.} & \qquad $b = (y_k^Tr) / (y_k^Ts_k)$\\
% \emph{9.} & \qquad $r = r + (a_k - b)s_k$\\
% \emph{10.} & \textbf{end for}\\
% \emph{11.} & Output: $r = H_ig_i$\\
% \end{tabular}
% $$
%%
%
% <html><hr></html>
%% Method Specific Input Parameters
%
% The input parameters specific to the |lbfgs| method are presented below.
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentation for more details on the Poblano parameters shared across
% all methods.
%
%  M        Limited memory parameter {5}
%%
%
% <html><hr></html>
%% Default Input Parameters
% The default input parameters are returned with the following call to
% |lbfgs|:
params = lbfgs('defaults')
%%
% 
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentationfor more details on the Poblano parameters shared across
% all methods.
%%
%
% <html><hr></html>
%% Examples
% Below are the results of using the |lbfgs| method in Poblano to solve 
% example problems solved using the |ncg| method in the <B_ncg_docs.html
% Nonlinear Conjugate Gradient Optimization> documentation. Note that the
% different methods lead to slightly different solutions and a different
% number of function evaluations.
%%
% *Example 1* (from <A4_poblano_examples_docs.html#4 Poblano Examples>)
%
% In this example, we have $x \in R^{10}$ and $a = 3$, and use a random
% starting point.
randn('state',0);
x0 = randn(10,1)
out = lbfgs(@(x) example1(x,3), x0)
%%
% *Example 2* (from <A4_poblano_examples_docs.html#11 Poblano Examples>)
%
% In this example, we compute a rank-4 approximation to a $4 \times 4$
% Pascal matrix (generated using the Matlab function |pascal(4)|). The
% starting point is random vector. Note that in the interest of space,
% Poblano is set to display only the final iteration is this example.
m = 4; n = 4; k = 4; 
Data.rank = k; 
Data.A = pascal(m);
randn('state',0);
x0 = randn((m+n)*k,1);
out = lbfgs(@(x) example2(x,Data), x0, 'Display', 'final')
%%
%
% As for the |ncg| method, the fact that
% |out.ExitFlag| > 0 indicates that the method did not
% converge to the specified tolerance (i.e., using the default |StopTol|
% input parameter value of |1e-5|). Since the maximum number of function
% evaluations was exceeded, we can increasing the number of maximum numbers
% of function evaluations and iterations allowed, and the optimizer
% converges to a solution within the specified tolerance.
out = lbfgs(@(x) example2(x,Data), x0, 'MaxIters',1000, ...
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
% For Example 2, we see that |lbfgs| requires slightly fewer
% function evaluations than |ncg| to solve the problem (143 versus
% 175). Performance of the different methods in Poblano is dependent on
% both the method and the particular parameters chosen. Thus, it is
% recommended that several test runs on smaller problems are performed
% initially using the different methods to help decide which method and set
% of parameters works best for a particular class of problems.
%%
%
% <html><hr></html>
%% References
%
% [1] Dennis, Jr., J. E. and Schnabel, R. B. (1996). _Numerical Methods 
% for Unconstrained Optimization and Nonlinear Equations_. SIAM.
%
% [2] Nocedal, J. and Wright S. J. (1999). 
% _Numerical Optimization_. Springer.

