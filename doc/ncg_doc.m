%% Nonlinear Conjugate Gradient Optimization
% Nonlinear conjugate gradient (NCG) methods [3] are used to solve 
% unconstrained nonlinear optimization problems. They are extensions of the
% conjugate gradient iterative method for solving linear systems adapted to
% solve unconstrained nonlinear optimization problems.
%
% The Poblano function for the nonlinear conjugate gradient methods is
% called |ncg|.
%%
%
% <html><hr></html>
%% Method Description
%
% The general steps of NCG methods are given below in high-level
% pseudo-code:
%%
%
% 
% $$
% \begin{tabular}{ll}
% \emph{1.} & Input: $x_0$, a starting point\\
% \emph{2.} & Evaluate $f_0 = f(x_0), g_0 = \nabla f(x_0)$\\
% \emph{3.} & Set $p_0 = -g_0, i = 0$\\
% \emph{4.} & \textbf{while} $\|g_i\| > 0$\\
% \emph{5.} & \qquad Compute a step length $\alpha_i$ and set $x_{i+1} = x_i + \alpha_i p_i$\\
% \emph{6.} & \qquad Set $g_i = \nabla f(x_{i+1})$\\
% \emph{7.} & \qquad Compute $\beta_{i+1}$\\
% \emph{8.} & \qquad Set $p_{i+1} = -g_{i+1} + \beta_{i+1} p_i$\\
% \emph{9.} & \qquad Set $i = i + 1$\\
% \emph{10.} & \textbf{end while}\\
% \emph{11.} & Output: $x_i \approx x^*$\\
% \end{tabular}
% $$
%
%% 
% *Conjugate direction updates*
%
% The computation of $\beta_{i+1}$ in Step 7 above leads to different NCG
% methods. The update methods for $\beta_{i+1}$ available in Poblano are
% listed below. Note that the special case of $\beta_{i+1} = 0$ leads to
% the steepest descent method [3], which is available by specifying this
% update using the input parameter described in the <B_ncg_docs.html#9
% Method Specific Input Parameters> section below.
%%
%
% _Fletcher-Reeves_ [1]:
%
% $$\beta_{i+1} = \frac{g_{i+1}^T {-} g_{i+1}}{g_{i}^T g_{i}} $$ 
%
% _Polak-Ribiere_ [4]:
%
% $$\beta_{i+1} = \frac{g_{i+1}^T (g_{i+1} {-} g_{i})}{g_{i}^T g_{i}} $$
%
% _Hestenes-Stiefel_ [2]:
%
% $$\beta_{i+1} = \frac{g_{i+1}^T (g_{i+1} {-} g_{i})}{p_i^T (g_{i+1} {-} g_{i})} $$
%
%% 
% *Negative update coefficients*
%
% In cases where the update coefficient $\beta_{i+1} < 0$, it is 
% set to $0$ to avoid directions that are not descent directions [3]. 
%% 
% *Restart procedures*
%
% The NCG iterations are restarted every _n_ iterations, where _n_ is 
% specified by user by setting the |RestartIters| parameter.
%
% Another restart modification available in |ncg| that was suggested by
% Nocedal and Wright [3] is taking a step in the direction of steepest
% descent when two consecutive gradients are far from orthogonal.
% Specifically, a steepest descent step is taking when
% 
% $$\frac{|g_{i+1}^T g_{i}|}{\|g_{i+1}\|} \geq \nu $$ 
%
% where $\nu$ is specified by the user by setting the |RestartNWTol| 
% parameter. This modification is off by default, but can be 
% used by setting the |RestartNW| parameter to "true".
%%
%
% <html><hr></html>
%% Method Specific Input Parameters
%
% The input parameters specific to the |ncg| method are presented below.
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentation for more details on the Poblano parameters shared across
% all methods.
%
%  Update        Conjugate direction update {'PR'}
%    'FR'        Fletcher-Reeves
%    'PR'        Polak-Ribiere 
%    'HS'        Hestenes-Stiefel
%    'SD'        Steepest Decsent
%
%  RestartIters  Number of iterations to run before conjugate direction restart {20}
%
%  RestartNW     Flag to use restart heuristic of Nocedal and Wright {false}
%
%  RestartNWTol  Tolerance for Nocedal and Wright restart heuristic {0.1}
%%
%
% <html><hr></html>
%% Default Input Parameters
% The default input parameters are returned with the following call to
% |ncg|:
params = ncg('defaults')
%%
% 
% See the <A2_poblano_params_docs.html Optimization Input Parameters>
% documentation for more details on the Poblano parameters shared across
% all methods.
%%
%
% <html><hr></html>
%% Examples
%%
% *Example 1* (from <A4_poblano_examples_docs.html#4 Poblano Examples>)
%
% In this example, we have $x \in R^{10}$ and $a = 3$, and use a random
% starting point.
randn('state',0);
x0 = randn(10,1)
out = ncg(@(x) example1(x,3), x0)
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
out = ncg(@(x) example2(x,Data), x0, 'Display', 'final')
%%
%
% The fact that |out.ExitFlag| > 0 indicates that the method did not
% converge to the specified tolerance (i.e., using the default |StopTol|
% input parameter value of |1e-5|). This exit flag indicates that the
% maximum number of function evaluations was exceeded. (See the
% <A3_poblano_out_docs.html Optimization Output Parameters> documentation
% for more details.) Increasing the number of maximum numbers of function
% evaluations and iterations allowed, the optimizer converges to a solution
% within the specified tolerance. 
out = ncg(@(x) example2(x,Data), x0, 'MaxIters',1000, ...
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
% <html><hr></html>
%% References
%
% [1] Fletcher, R. & Reeves, C.M. (1964). 
% Function minimization by conjugate gradients. 
% _The Computer Journal_, 7, 149-154.
%
% [2] Hestenes, M. R. and Stiefel, E. (1952). 
% Methods of conjugate gradients for solving linear systems. 
% _J. Res. Nat. Bur. Standards Sec. B._, 48, 409-436.
%
% [3] Nocedal, J. and Wright S. J. (1999). 
% _Numerical Optimization_. Springer.
%
% [4] Polak, E. and Ribiere, G. (1969). 
% Note sur la convergence de methods de directions conjugres. 
% _Revue Francaise Informat. Recherche Operationnelle_, 16, 35-43.
