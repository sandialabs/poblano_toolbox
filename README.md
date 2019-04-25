# Poblano Toolbox for MATLAB

``` 
Copyright 2009 National Technology & Engineering Solutions of Sandia,
LLC (NTESS). Under the terms of Contract DE-NA0003525 with NTESS, the
U.S. Government retains certain rights in this software.
```

Poblano is a Matlab toolbox of large-scale algorithms for
unconstrained nonlinear optimization problems. The algorithms in
Poblano require only first-order derivative information (e.g.,
gradients for scalar-valued objective functions), and therefore can
scale to very large problems. The driving application for Poblano
development has been tensor decompositions in data analysis
applications (bibliometric analysis, social network analysis,
chemometrics, etc.).

Poblano optimizers find local minimizers of scalar-valued objective
functions taking vector inputs. The gradient (i.e., first derivative)
of the objective function is required for all Poblano optimizers. The
optimizers converge to a stationary point where the gradient is
approximately zero. A line search satisfying the strong Wolfe
conditions is used to guarantee global convergence of the Poblano
optimizers. The optimization methods in Poblano include several
nonlinear conjugate gradient methods (Fletcher-Reeves, Polak-Ribiere,
Hestenes-Stiefel), a limited-memory quasi-Newton method using BFGS
updates to approximate second-order derivative information, and a
truncated Newton method using finite differences to approximate
second-order derivative information.
