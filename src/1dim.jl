#1-dim CAs

#Elementary & totalistic CA with r-nearest neighbor and k states
mutable struct CellularAutomaton

    #user given values
    N::Int #code
    ruleset::Array{Int8,1} #set of rules
    k::Int #number of states
    r::Int #r-nearest neighbor

    #internal variables
    cells::Array{Int8,2}

    function CellularAutomaton(N::Int, init::Array{Int,1}, gen::Int; k::Int=2, r::Int=1)
        ruleset = rule(N, k, r)

        w = length(init)
        cells = Array{Int8}(undef, gen, w)
        cells[1,:] = Array{Int8}(init[:])

        if k == 2
            #Elementary CA
            mp = reverse([k^i for i = 0:2r+1])
        else
            #Totalistic CA
            mp = Array{Int8}(ones(2r+1))
        end

        for i = 2:gen
            for j = 1:w
                ind = 0 ; s = 1
                for q = (j-r):(j+r)

                    #Cyclic boundary conditions
                    if q < 1
                        q = w-q
                    end
                    if q > w
                        q = q-w
                    end

                    ind += mp[s]*cells[i-1, q]
                    s += 1
                end
                # this is a weird hack that I am just assuming is the answer to this problem:
                # BoundsError: attempt to access 8-element Vector{Int64} at index [9]
                # and
                # BoundsError: attempt to access 8-element Vector{Int64} at index [-279]
                if ind+1 <= length(ruleset) && ind > 0
                    cells[i,j] = ruleset[ind+1]
                else
                    break
                end
            end
        end

        new(N, ruleset, k, r, cells)
    end

    #Quick setup for one seed cell in the center
    function CellularAutomaton(N::Int, gen::Int; kw...)
        init = Array{Int}(zeros(2*gen))
        init[gen] = 1

        CellularAutomaton(N, init, gen; kw...)
    end
end

#Parse rule numbering according to the Wolfram code
function rule(n::Int, k=2, r=1)
    if k < 2
        error("number of states (k) must be larger than 1; you gave $k")
    elseif k == 2
        #Elementary CA
        return digits(n; base=k, pad=k^(2r+1))
    else
        #Totalistic CA
        return digits(n; base=k, pad=(2r+1)k-2)
    end
end
