using Test
using CellularAutomata

@testset "CellularAutomata.jl" begin
    printstyled(color=:blue, "conway_test\n")
    @testset "conway_test" begin
        include("conway_test.jl")
        using .ConwayTest
        turbine_test()
        blinker_test()
    end

    printstyled(color=:blue, "1dim\n")
    @testset "1dim" begin
        include("1dim.jl")
    end
    printstyled(color=:blue, "2dim\n")
    @testset "2dim" begin
        include("2dim.jl")
    end
end
