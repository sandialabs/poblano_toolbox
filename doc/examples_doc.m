%% Poblano Toolbox for MATLAB: Examples
% This section describes the examples provided with Poblano. These examples
% can be used as templates for other function/gradient M-files.
%%
%
% <html><hr></html>
%% Solving a Problem Using Poblano
% To solve a problem using Poblano, the following steps are performed: 
%
% * *Step 1: Create M-file for objective and gradient.* An M-file which
% takes a vector as input and provides a scalar function value and gradient
% vector (the same size as the input) must be provided to the Poblano
% optimizers. 
% * *Step 2: Call the optimizer.* One of the Poblano optimizers is called,
% taking an anonymous function handle to the function to be minimized, a
% starting point, and an optional set of optimizer parameters as inputs. 
%
% Poblano provides two example function/gradient M-files:
% 
% * |example1|: simple multivariate function
% * |example2|: more complicated function of a matrix variable
%%
%
% <html><hr></html>
%% Example 1: Multivariate Sum
%
% The following example is a simple multivariate function, $f_1 : R^N \to R$, 
% that can be minimized using Poblano:
%%
% 
% $$f_1(x) = \sum_{n=1}^N \sin(ax_i)$$
%%
% 
% $$\left(\nabla f_1(x)\right)_i = a \cos(ax_i)\; , \quad i=1,\dots,N$
%%
%
% where $a$ is a scalar parameter. 
%%
%
% Listed below are the contents of the |example1.m| M-file 
% distributed with the Poblano code. This is an example of a self-contained
% function requiring a vector of independent variables and an
% _optional_ scalar input parameter for $a$.
%
%     function [f,g]=example1(x,a)
%          if nargin < 2, a = 1; end
%          f = sum(sin(a*x));
%          g = a*cos(a*x);
%%
% 
% The following presents a call to |ncg| optimizer using the default
% parameters (see <B_ncg_docs.html NCG method> documentation for more
% details) along with the information displayed and output return by
% Poblano. By default, at each iteration Poblano displays the number of
% function evaluations (|FuncEvals|), the function value at the current
% iterate (|F(X)|), and the Euclidean norm of the scaled gradient at the
% current iterate (|||||G(X)||||||/N|, where |N| is the size of |X|) for
% each iteration. The output of Poblano optimizers is a Matlab structure
% containing the solution. See the <A3_poblano_out_docs.html Output
% Parameters> documentation for more details.
out = ncg(@(x) example1(x,3), pi/4)
%%
% The problem dimension, $N$, of |example1| is determined by the size of the
% initial guess. For example, to solve a problem with $N=10^6$, simply use
% an initial guess vector of size $N=10^6$ when calling the Poblano optimizer:
randn('state',0);
x0 = randn(1e6,1);
out = ncg(@(x) example1(x,3), x0, 'Display', 'final')
%% Example 2: Matrix Decomposition
%
% The following example is a more complicated function involving matrix
% variables. As the Poblano methods require scalar functions with vector
% inputs, variable matrices must be reshaped into vectors first. The
% problem in this example is to find a rank-$k$ decomposition, $UV^T$, of
% a $m \times n$ matrix, $A$, which minimizes the Frobenius norm of the fit
%%
%
% $$f_2 = \frac12\| A - UV^T \|_F^2$$
%%
%
% $$\nabla_U f_2 = -(A-UV^T)V$$
%%
%
% $$\nabla_V f_2 = -(A-UV^T)^T U$$
%%
%
% where $A \in R^{m \times n}$ is a matrix with rank $\geq k$, $U
% \in R^{m \times k}$, and $V \in R^{n \times k}$. This problem can be
% solved using Poblano by providing an M-file that computes the function
% and gradient shown above but that takes $U$ and $V$ as input in
% vectorized form.
%
% This problem can be solved using Poblano by providing an M-?le that
% computes the function and gradient shown above but that takes U and V as
% input in vectorized form.
%%
%
% Listed below are the contents of the |example2.m| M-file
% distributed with the Poblano code. Note that the input |Data| is
% required and is a structure containing the matrix to be decomposed, $A$,
% and the desired rank, $k$. This example also illustrates how the
% vectorized form of the factor matrices, $U$ and $V$, are converted to
% matrix form for the function and gradient computations.
%
%     function [f,g]=example2(x,Data)
%          % Data setup
%          [m,n] = size(Data.A);
%          k = Data.rank;
%          U = reshape(x(1:m*k),m,k);
%          V = reshape(x(m*k+1:m*k+n*k),n,k);
%
%          % Function value (residual)
%          AmUVt = Data.A-U*V';
%          f = 0.5*norm(AmUVt,'fro')^2;
%
%          % First derivatives computed in matrix form
%          g = zeros((m+n)*k,1);
%          g(1:m*k) = -reshape(AmUVt*V,m*k,1);
%          g(m*k+1:end) = -reshape(AmUVt'*U,n*k,1);
%%
%
% Included with Poblano are two helper functions and which can be used to
% generate problems instances along with starting points
% (|example2_init.m|) and extract the factors $U$ and $V$ from a solution
% vector (|example2_extract.m|). We show an example of their use below.
randn('state',0);
m = 4; n = 3; k = 2;
[x0,Data] = example2_init(m,n,k)
out = ncg(@(x) example2(x,Data), x0, 'RelFuncTol', 1e-16, 'StopTol', 1e-8, ...
    'MaxFuncEvals',1000,'Display','final')
%%
%
% Extracting the factors from the solution, we see that we have found a
% solution, since the the Euclidean norm of the difference between the
% matrix and the approximate solution is equal to the the $k+1$ singular
% value of $A$ [1, Theorem 2.5.3].
[U,V] = example2_extract(4,3,2,out.X);
norm_diff = norm(Data.A-U*V')
sv = svd(Data.A); 
sv_k_plus_1 = sv(k+1)
%%
%
% <html><hr></html>
%% References
%
% [1] Golub, G. H. and Loan, C. F. V. (1996). _Matrix Computations_. 
% Johns Hopkins University Press.
%
