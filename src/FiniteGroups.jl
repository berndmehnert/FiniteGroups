module FiniteGroups
import Base.map
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

τ = Cyc([1,5,2]) defines the map such that 1 -> 5 -> 2 -> 1 and x -> x for all other integers.
"""
struct Cyc <: Permutation
    arr :: Array{Int64, 1}
    Cyc(arr) = length(Set(arr)) != length(arr) ? error("Elements in array need to be pairwise distinct!") : new(arr)
end

# map extension to permutation types.
function map(τ :: Cyc, x :: Int64)
    array = τ.arr
    if !(x ∈ Set(array))
        return x
    end
    for i in 1:length(array)
        if x == array[i]
            if i<length(array)
                return array[i+1]
            else
                return array[1]
            end
        end
    end
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
