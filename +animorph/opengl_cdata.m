function cdata = opengl_cdata(hfig)
% Get CDATA from hardcopy using opengl

% Need to have PaperPositionMode be auto 
orig_mode = get(hfig, 'PaperPositionMode');
orig_rend = get(hfig, 'Renderer');
set(hfig, 'PaperPositionMode', 'auto', 'Renderer', 'opengl');

cdata = hardcopy(hfig, '-Dopengl', '-r0');

% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode, 'Renderer', orig_rend); % end
