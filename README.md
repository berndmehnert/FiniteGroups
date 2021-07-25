# FiniteGroups

[![codecov](https://codecov.io/gh/berndmehnert/FiniteGroups/branch/develop/graph/badge.svg?token=CALPBCW07D)](https://codecov.io/gh/berndmehnert/FiniteGroups)

Simple project concerning finite groups...

Example:
```
julia> using FiniteGroups

julia> σ = Cyc(1,2,3)
(2,3,1)

julia> map(σ, 2)
3
julia> τ = Permutation(1 => 2, 2 => 1, 3 => 4, 4 => 5, 5 => 3)
(5,3,4)(2,1)

julia> σ*τ
(5,1,3,4)

julia> (σ*τ)^-1 == τ^-1*σ^-1
true
```
