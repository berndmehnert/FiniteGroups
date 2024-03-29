module FiniteGroups
import Base.Dict, Base.map, Base.*, Base.^, Base.==, Base.inv, Base.show
export τ, Cyc, Perm, Permutation, inv, order, Group, orbit, id, elements


"""
Abstract type to subsume all permutation types
"""
abstract type AbstractPermutation end

"""
Example:
Permutation(1=>2, 2=>1, 3=>4, 4=>3) == Cyc(1,2) * Cyc(3,4)
"""
function Permutation(npairs :: Pair{Int64, Int64} ...) :: Perm
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

function Cyc(v :: Vector{Int64}) :: Cyc
    if length(v) < 2
        return Cyc(Dict{Int64,Int64}())
    end
    if length(Set(v)) != length(v)
        error("Elements in list have to be distinct!")
    end
    dict_arr = []
    for i in 1:length(v)-1
        push!(dict_arr, (v[i], v[i+1]))
    end
    push!(dict_arr, (v[end], v[1]))
    return Cyc(Dict(dict_arr))
end

Cyc(ns :: Int64 ...) = length(ns) == 0 ? Cyc(Vector{Int64}()) : Cyc(collect(ns))
const id = Cyc()

==(σ :: Cyc, τ :: Cyc) = σ.dict == τ.dict
==(σ :: Perm, τ :: Perm) = σ.cycles == τ.cycles
==(σ :: Perm, τ :: Cyc) = τ == Cyc() ? σ == Perm(Cyc[]) : σ == Perm([τ])
==(τ :: Cyc, σ :: Perm) = ==(σ :: Perm, τ :: Cyc)
 
function customized_show(cyc :: Cyc)
    cyc_keys = keys(cyc.dict)
    if length(cyc_keys) == 0
        print("()")
        return true
    end
    start = iterate(cyc_keys)[1]
    print("("*string(start))
    x = cyc.dict[start]
    while x != start
        print(","*string(x))
        x = cyc.dict[x]
    end
    print(")")
    return true
end

function customized_show(perm :: Perm)
   if length(perm.cycles) == 0
       print("()")
   else
   for cyc in perm.cycles
       customized_show(cyc)
   end
   return true
end
end

*(σ :: Cyc, τ :: Cyc) = Perm(get_disjoint_cycles(get_dict_from_cyc_list([σ, τ])))
*(σ :: Perm, τ :: Cyc) = Perm(get_disjoint_cycles(get_dict_from_cyc_list([σ.cycles; [τ]])))
*(σ :: Cyc, τ :: Perm) = Perm(get_disjoint_cycles(get_dict_from_cyc_list([[σ]; τ.cycles])))
*(σ :: Perm, τ :: Perm) = Perm(get_disjoint_cycles(get_dict_from_cyc_list([σ.cycles; τ.cycles])))

show(io::IO, ::MIME"text/plain", x::AbstractPermutation) = customized_show(x)
map(σ :: AbstractPermutation, τ :: AbstractPermutation) = σ*τ

function inv(σ :: Cyc)
    dict = Dict{Int64, Int64}()
    for pair in σ.dict
        push!(dict, pair.second=>pair.first)
    end
    return Cyc(dict)
end

function inv(σ :: Perm)
    arr = Vector{Cyc}()
    for i in 1:length(σ.cycles)
        push!(arr, inv(σ.cycles[length(σ.cycles) + 1 - i]))
    end
    return Perm(arr)
end

function power(σ :: AbstractPermutation, n :: Integer)
    if n == 0
        return Perm(Vector{Cyc}())
    end
    if n == 1
        return σ
    end
    m = div(n,2)
    r = n%2
    τ = power(σ, m)
    if r == 0 return τ*τ
    end
    return (τ*τ)*σ
end

function ^(x :: Cyc, n :: Integer)
    m = n % order(x)
    m >= 0 ? power(x,m) : power(inv(x),-m)
end

function ^(x::Perm, n :: Integer)
    prod([(x.cycles[i])^n for i in 1:length(x.cycles)])
end

order(cyc :: Cyc) = length(keys(cyc.dict)) < 2 ? 1 : length(keys(cyc.dict))
order(perm :: Perm) = lcm(map(cyc -> order(cyc), perm.cycles))

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

abstract type AbstractGroup end
struct Group <: AbstractGroup
    generators :: Vector{AbstractPermutation}
end

function Group(generators :: AbstractPermutation ...)
    return Group([generators ...])
end

show(io::IO, ::MIME"text/plain", G::Group) = println("Finite permutation group with "*string(length(G.generators))*" generators ..")

function orbit(X, α)
    δ = Any[α]
    while true
        l = length(δ)
        for ω in δ
            for τ in X
                ω1 = map(τ, ω)
                if ω1 ∉ δ
                    push!(δ, ω1)
                end
            end
        end
        if length(δ) == l 
            break
        end 
    end
    return δ
end

orbit(g :: Group, α) = orbit(g.generators, α)
elements(g :: Group) = orbit(g, id)

# help functions
function map(dict :: Dict{Int64, Int64}, x :: Int64)
    if !(x ∈ keys(dict))
        return x
    end
    return dict[x]
end

function get_dict_from_cyc_list(arr :: Array{Cyc})
    if length(arr) == 0 
        return Dict{Int64,Int64}()
    end
    if length(arr) == 1 
        return arr[1].dict
    end 
    dict1 = get_dict_from_cyc_list(arr[1:end-1])
    dict2 = arr[end].dict
    result = Dict{Int64, Int64}()
    for i in keys(dict2)
        j = dict2[i]
        if haskey(dict1, j)
            push!(result, i=>dict1[j])
        else
            push!(result, i=>j)
        end
    end
    for i in setdiff(Set(keys(dict1)), Set(values(dict2)))
        push!(result, i => dict1[i])
    end
    return result
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
