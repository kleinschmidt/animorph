function [values names ranges] = param_struct_to_vector(params)

values = [params.value];
names = [params.name];
ranges = [params.range];

end