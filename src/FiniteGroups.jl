module FiniteGroups
import Base.Dict
import Base.map, Base.*, Base.^, Base.==
export τ, Cyc, Perm, Permutation

"""
Abstract type to subsume all permutation types
"""
abstract type AbstractPermutation end
"""
Example:
σ = Permutation(1=>2, 2=>1, 3=>4, 4=>3) 
  = Cyc(1,2) * Cyc(3,4)
"""
function Permutation(npairs :: Pair{Int64, Int64} ...)
    dict = Dict(npairs)
    if Set(keys(dict)) != Set(values(dict))
        error("The set of keys has to be the same as the set of values ..")
    end
    return Perm(get_disjoint_cycles(dict))
end

"""
Define a cycle:

Example:

τ = Cyc(1,5,2) defines the map such that 1 -> 5 -> 2 -> 1 and x -> x for all other integers.
"""
struct Cyc <: AbstractPermutation
    dict :: Dict{Int64, Int64}
end

struct Perm <: AbstractPermutation
    cycles :: Vector{Cyc}
end

function Cyc(v :: Vector{Int64})
    if length(Set(v)) != length(v)
        error("Elements in list have to be distinct!")
    end
    if length(v) < 2
        return Cyc(Dict([]))
    end
    dict_arr = []
    for i in 1:length(v)-1
        push!(dict_arr, (v[i], v[i+1]))
    end
    push!(dict_arr, (v[end], v[1]))
    return Cyc(Dict(dict_arr))
end

Cyc(ns :: Int64 ...) = Cyc(collect(ns))

==(σ :: Cyc, τ :: Cyc) = σ.dict == τ.dict
==(σ :: Perm, τ :: Perm) = σ.cycles == τ.cycles
 
function *(σ :: Cyc, τ :: Cyc)
    S = keys(σ.dict) ∪ keys(τ.dict)
    dict = Dict{Int64, Int64}()
    for s in S
        push!(dict, s=>map(Perm([σ, τ]), s))
    end
    return Perm(get_disjoint_cycles(dict))
end

function *(σ :: Perm, τ :: Cyc)
    if length(σ.cycles) == 0
        return τ
    end
    if length(σ.cycles) == 1
        return σ.cycles[1]*τ
    end
    return (Perm(σ.cycles[1::end-1])*σ.cycles[end])*τ
end

function ^(σ :: Cyc, n :: Int)
    return 1
end

# map extension to permutation types.
map(τ :: Cyc, x :: Int64) = map(τ.dict, x)

function map(σ :: Perm, x :: Int64)
    array = σ.cycles
    if length(array) == 0
        return x
    end
    if length(array) == 1
        return map(array[1], x)
    end
    return map(array[1], map(Perm(array[2:end]), x))
end

# help functions
function map(dict :: Dict{Int64, Int64}, x :: Int64)
    if !(x ∈ keys(dict))
        return x
    end
    return dict[x]
end

function extract_cycle_from_dict(dict :: Dict{Int64, Int64}, x)
    result = Dict{Int64, Int64}()
    z = map(dict, x)
    y = x
    while z != x
        push!(result, y=>z)
        y = z
        z = map(dict, y)
    end
    push!(result, y=>z)
    return Cyc(result)
end

function get_disjoint_cycles(dict :: Dict{Int64, Int64})
    result = Vector{Cyc}()
    set = Set(keys(dict))
    while length(set) > 0
        x = iterate(set)[1]
        cyc = extract_cycle_from_dict(dict, x)
        if length(keys(cyc.dict)) > 1 
            push!(result, cyc)
        end
        set = setdiff!(set, Set(keys(cyc.dict)))
    end
    return result
end
end # module
