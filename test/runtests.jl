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
end

@testset "perm-test" begin
    @test Permutation(1=>2,2=>1,4=>3,3=>4) == Cyc(1,2)*Cyc(4,3)
end