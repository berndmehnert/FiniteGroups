using Test
using FiniteGroups
@testset "map + cycles" begin
    τ = Cyc(1,2)
    @test map(τ, 3) == 3
    @test map(τ, 2) == 1
    @test map(τ, 1) == 2
end

@testset "map + perms" begin
    σ = Perm([1,5,2])
    @test map(σ, 3) == 3
    @test map(σ, 2) == 5
end

@testset "cycles + relations" begin
    σ = Cyc([1,2,3])
    τ = Cyc(2,3,1)
    γ = Cyc(1,3,2)
    @test σ == τ
    @test !(σ == γ)
end