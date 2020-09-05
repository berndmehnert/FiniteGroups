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
