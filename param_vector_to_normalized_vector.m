function params_vec = param_vector_to_normalized_vector(params_vec, names_vec, range_vec)

global shape_params

if (nargin < 2)
    names_vec = {shape_params.name};
    range_vec = {shape_params.range};
    
    if (length(names_vec) ~= length(params_vec))
        error('Length mismatch between names and parameters');
    elseif (length(range_vec) ~= length(params_vec))
        error('Length mismatch between ranges and parameters');
    end
end

for i = 1:length(params_vec)
    if ~isempty(range_vec{i})
        params_vec(i) = (params_vec(i) - min(range_vec{i})) / diff(range_vec{i});
    end
end

end