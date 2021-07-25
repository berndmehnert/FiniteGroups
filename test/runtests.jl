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
    @test Permutation(1=>2,2=>1,4=>3,3=>4) == Cyc(1,2)*Cyc(4,3)
end

@testset "show-test" begin
    σ = Cyc([1,2,3,4])
    @test FiniteGroups.customized_show(σ)
    @test FiniteGroups.customized_show(σ^2)
end