@testset "2dim" begin
    init = fill(1, (4, 4))
    ca = CA2d([3], [2, 3], init, 10)
    show(ca)
end