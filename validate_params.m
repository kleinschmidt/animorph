function params = validate_params(params_in, end_padding_factor)

% what proportion of the range to restrict to?
if nargin < 2
    % default to 5% on each end
    end_padding_factor = 0.05;
end

if ~isstruct(params_in)
    params = param_vector_to_struct(params_in);
else
    params = params_in;
end

% check each parameter against its range. if it's outside the end padding
% factor (default: 5%-95% of range), then hard threshold it.
for i = 1:length(params)
    if ~isempty(params(i).range)
        %val_norm = (params(i).value - min(params(i).range)) / diff(params(i).range);
%         if val_norm > 1-end_padding_factor
%             val_norm = 1-end_padding_factor + ...
%                 end_padding_factor * exp(1-end_padding_factor - val_norm);
%         elseif val_norm < end_padding_factor
%             val_norm = end_padding_factor;
%         end
        %val_norm = exp_threshold(val_norm, [0 1]+[1 -1]*end_padding_factor, [0 1]);
        %params(i).value = val_norm * diff(params(i).range) + min(params(i).range);
        params(i).value = exp_threshold(params(i).value, ...
            params(i).range + [1 -1]*end_padding_factor*diff(params(i).range), ...
            params(i).range);
    end
end

if ~isstruct(params_in)
    params = param_struct_to_vector(params);
end

end



function x = hard_threshold(x, limits)

x(x < limits(1)) = limits(1);
x(x > limits(2)) = limits(2);

end

function x = exp_threshold(x, thresholds, limits)

x(x < thresholds(1)) = limits(1) + (thresholds(1) - limits(1)) * exp((x(x<thresholds(1)) - thresholds(1)) / (thresholds(1)-limits(1)));
x(x > thresholds(2)) = limits(2) - (limits(2) - thresholds(2)) * exp((thresholds(2) - x(x>thresholds(2))) / (limits(2)-thresholds(2)));

end