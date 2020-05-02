
function solve_steady_state(initial_guess, parameter_values)
    _, model_rhs, _, variables, params = get_internal_model(nothing)
    @assert length(initial_guess) == length(model_rhs) == length(variables)
    variable_count = length(variables)
    _eqs = zeros(length(model_rhs)) .~ model_rhs
    _nl_system = MTK.NonlinearSystem(_eqs, [variables...], [params...][2:end])
    nlsys_func = MTK.generate_function(_nl_system, expression = Val{false})[2]
    _parameter_values = [x.second for x in parameter_values]
    # second is in-place
    sol = NLsolve.nlsolve((out, x) -> nlsys_func(out, x, _parameter_values), initial_guess)
    println(sol)
    return sol.zero
end

function instantiate_initial_conditions(model, parameter_values, system::PSY.System;)



    initial_conditions = Array{Pair}(undef, length(_initial_conditions))

    for (ix, val) in enumerate(_initial_conditions)
        initial_conditions[ix] = MTK.states(model)[ix] => val
    end
    return initial_conditions
end
