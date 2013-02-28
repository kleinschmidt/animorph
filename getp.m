function p = getp(params, name)

try
    p = params(strcmp(name, {params.name})).value;
catch
    error(['Parameter name not found: ' name]);
end

end