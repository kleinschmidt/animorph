function params = setp(params, name, value)

try
    params(strcmp(name, {params.name})).value = value;
catch
    error(['Parameter name not found: ' name]);
end

end