function params = param_vector_to_struct(params_vec, names_vec, range_vec)
% Convert vector of params to struct (suitable for drawing)
% 
% Input:
%   params_vec: Vector of parameter values
%   names_vec: Cell array of parameter names (optional, defaults to global
%     {shape_params.name})
%   range_vec: Cell array of parameter ranges (optional, defaults to global
%     {shape_params.range})
% Output:
%   params: Animal parameter struct, suitable for passing to make_animal
%     etc.

import animorph.*;

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

params = struct('value', num2cell(reshape(params_vec, size(names_vec))),...
    'name', names_vec, ...
    'range', range_vec);

end