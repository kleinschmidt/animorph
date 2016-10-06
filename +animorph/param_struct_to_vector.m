function [values names ranges] = param_struct_to_vector(params)
% Extract parameter values, names, and ranges from struct
% 
% Input:
%   params: Parameter struct
% Output:
%   values: Vector of parameter values
%   names
%   ranges

values = [params.value];
names = [params.name];
ranges = [params.range];

end