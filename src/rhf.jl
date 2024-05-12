using OohataHuzinaga
using BasisSets
using BenchmarkTools
using Plots

function scalingmeasurements(fun::Function, file)
    times = []
    memory = []

    s = ["sto-2g", "sto-3g", "sto-6g", "def2-svp", "def2-tzvp"]

    sizes = [2, 3, 4, 5, 6]

    for dim in s
        mol = molecule(file)
        basis = parsebasis(mol, dim)
        res = @benchmark $fun($basis, $mol)
        push!(times, minimum(res).time)
        push!(memory, minimum(res).memory)
        println("Dimension: ", dim)
        println("Time: ", minimum(res).time)
        println("Allocated memory: ", minimum(res).memory)
    end

    return sizes, times, memory
end

sizes, times, memory = scalingmeasurements(rhf, "/Users/leticiamadureira/OohataHuzinaga.jl/test/data/hydrogen/h2.xyz")

plot(sizes, times, label="Time", xaxis="Dimension", yaxis="Time (ns)", legend=:topleft)
savefig("indices_time.png")
plot(sizes, memory, label="Memory", xaxis="Dimension", yaxis="Memory (bytes)", legend=:topleft)
savefig("indices_memory.png")
