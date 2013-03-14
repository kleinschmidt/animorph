function [vec, scaled_vec] = feature_to_param_vector(feature_name, params)

if nargin < 2
    global shape_params;
    params = shape_params;
end

if iscell(feature_name)
    vec = zeros(1, length(params));
    for p = feature_name
        this_vec = strcmp({params.name}, p{1});
        if sum(this_vec)==0
            error(['Feature not found: ' p{1}]);
        end
        vec = vec + this_vec;
    end
else
    vec = strcmp({params.name}, feature_name);
end

if sum(vec)==0
    error(['Feature not found: ' feature_name]);
end

scaled_vec = vec;
for i = find(vec > 0)
    scaled_vec(i) = scaled_vec(i) * diff(params(i).range);
end
