# 4 Queens problem

We need to place 4 queens on a 4x4 chessboard without them attacking each other.

# CSP (Constraint Satisfaction Problem)

A CSP is made of:
- A set of variables *V = {V1, ..., Vn}*
- A set of domains *D = {D1, ..., Dn}*
- A set of **CONSTRAINTS** *C* on the variables *V*

Our goal is to find for one, or every, admissible solution, namely we are looking for an assignment
*σ : V -> D1 ∪ ... ∪ Dn* that satisfies all domains and constraints.

The difference between a declaretive way compared to the imperative programming is:
- We focus on a model 
- Compositionality of constraints, it helps us avoiding to rewrite code 
- Shorter, but denser, code 

We don't directly work on algorithms but we take advantage of solvers that offer solving algorithms.
This allows us to focus on modelling the problem rather than solving it.

# COP (Constraint Optimization Problem)

A COP is made of:
- A set of variables *V = {V1, ..., Vn}*
- A set of domains *D = {D1, ..., Dn}*
- A set of **CONSTRAINTS** *C* on the variables *V*
- A function *f : D^n -> A*

We look for one or every assignment *σ* that is an admissible solution of the CSP and that **MINIMIZES** or **MAXIMIZES** the value of *f*.

CSPs and COPs are closely related to each other.


# Search Space

- Given a CSP *< X1 ∈ D1, ... , Xn ∈ Dn: C>* (*C* denotes the set of all constraints)
- The **SEARCH SPACE** is the set of n-tuples of domani elements:
  *D1 x ... x Dn*

In this set we look for points that satisfy the *C*
This set is commonly represented as a tree, called the **SEARCH TREE**, we should take into consideration that in general *Di* can be infinite.


When we try to solver our 4 Queens problem we want to spend as less time as possible working on a incorrect solution, so we can save time and reduce the search tree.
We can use filtering, which allows us to remove values that do not appear in our solutions.
We can also exploit check redundancy -> allows us to exclude some solutions from the search space.

"Solvers are not good at discovering redundancies"

Our search space for our 4 queens problem is -> 4^4  = 256; the base is the *options domains* and the exponent is the *number of variables*.

We can also model the 4 Queens problem into a SAT Problem: we basically use boolean values to represent the available positions on our chessboard. 
If we model the 4 queens problem into a SAT problem our search space becomes 2¹⁶ = 64k. A SAT solver for this problem can be better than propagation.
