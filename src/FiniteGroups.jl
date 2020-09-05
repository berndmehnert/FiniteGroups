module FiniteGroups
import Base.map, Base.*, Base.^
export τ, Cyc, Perm, Permutation

"""
Abstract type to subsum all permutation types
"""
abstract type Permutation end
"""
Suppose we are given n integers a₁,a₂,...,aₙ such that 

                     a₁ < a₂ <...< aₙ (*)

then for any rearragement 
                     b₁, b₂,..., bₙ 
of the numbers (*)
                   Perm([b₁, b₂, ... , bₙ])
stands for the map that sends aᵢ to bᵢ for i=1, 2,..., n and sends x to x for all integers x which are not in {a₁ , a₂,..., aₙ}. 

Example:

σ = Perm([1,3,2]) 
is the map which sends 1 -> 1, 2 -> 3, 3 -> 2 and fixes all numbers outside of {1,2,3}.
"""
struct Perm <: Permutation
    arr :: Array{Int64,1}
    Perm(arr) = length(Set(arr)) != length(arr) ? error("Elements in array need to be pairwise distinct!") : new(arr)
end
"""
Define a cycle:

Example:

τ = Cyc(1,5,2) defines the map such that 1 -> 5 -> 2 -> 1 and x -> x for all other integers.
"""
struct Cyc <: Permutation
    dict :: Dict{Int64, Int64}
end

function Cyc(ns :: Int64 ...)
    if length(Set(ns)) != length(ns)
        error("Elements in list have to be distinct!")
    end
    if length(ns) < 2
        return Cyc(Dict([]))
    end
    dict_arr = []
    for i in 1:length(ns)-1
        push!(dict_arr, (ns[i], ns[i+1]))
    end
    push!(dict_arr, (ns[end], ns[1]))
    return Cyc(Dict(dict_arr))
end

function *(σ :: Cyc, τ :: Cyc)
    return 1
end

function ^(σ :: Cyc, n :: Int)
    return 1
end

# map extension to permutation types.
function map(τ :: Cyc, x :: Int64)
    dict = τ.dict
    if !(x ∈ keys(dict))
        return x
    end
    return dict[x]
end

function map(σ :: Perm, x :: Int64)
    array = σ.arr
    if !(x ∈ Set(array))
        return x
    end
    sorted_array = sort(array)
    index = findfirst(isequal(x), sorted_array)
    return array[index]
end
end # module
