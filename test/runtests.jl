using Test
using FiniteGroups
@testset "map + cycles" begin
    τ = Cyc(1,2)
    @test map(τ, 3) == 3
    @test map(τ, 2) == 1
    @test map(τ, 1) == 2
end

@testset "cycles + relations" begin
    σ = Cyc([1,2,3])
    τ = Cyc(2,3,1)
    γ = Cyc(1,3,2)
    @test σ == τ
    @test !(σ == γ)
    @test order(Cyc(1,3,2)*Cyc(1,3)) == 2
    @test σ^-1 == Cyc(3,2,1)
    @test (σ*τ)^-1 == τ^-1 * σ^-1
    @test Cyc(1,5,4)^10 == Cyc(1,5,4)
    @test map(Cyc(1,5,4)^2, 1) == 4
end

@testset "perm-test" begin
    c = Cyc(1,3,5)
    d = Cyc(6,7)
    @test c^1334 * d^1334 == (c*d)^1334 
    @test Permutation(1=>2,2=>1,4=>3,3=>4) == Cyc(1,2)*Cyc(4,3)
end

@testset "groups and actions" begin
    c1 = Cyc(1,2,3,4,5)
    c2 = Cyc(1,6)
    c3 = Permutation(1=>2, 2=>1)
    c4 = Cyc(1,3)
    G = Group([c1, c2])
    G1 = Group(c3, c4)
    @test Set(orbit(G,1)) == Set([1,2,3,4,5,6])
    @test Set(orbit(G1,3)) == Set([1,2,3])
end

@testset "show-test" begin
    σ = Cyc([1,2,3,4])
    @test FiniteGroups.customized_show(σ)
    @test FiniteGroups.customized_show(σ^2)
end