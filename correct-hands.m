%% correct saved animal parameters for bug in hand size calculation

animals = {'dog', 'hippo', 'horse', 'monkey', 'mouse', 'sheep', 'tiger'};

for i = 1:length(animals)
    load([animals{i} '.mat']);
    shape_params_uncorrected = shape_params;
    shape_params = setp(shape_params, 'hand length', ...
        getp(shape_params, 'hand length') * getp(shape_params, 'size') * getp(shape_params, 'lo fr leg radius'));
    save([animals{i} '.mat'], 'shape_params', 'shape_params_uncorrected');
end