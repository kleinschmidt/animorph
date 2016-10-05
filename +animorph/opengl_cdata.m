function cdata = opengl_cdata(hfig)
% Get CDATA from hardcopy using opengl

% NOTE: getframe is the more kosher way to do this, but it can't be used with
% invisible figures, which means we can't use it in the experiment control code
% which uses an invisible figure window to generate the images on the fly. Hence
% the hardcopy-based approach in opengl_cdata. This works for now but may be
% deprecated eventually.
%
% cdata = frame2im(getframe(hfig));

% Need to have PaperPositionMode be auto 
orig_mode = get(hfig, 'PaperPositionMode');
orig_rend = get(hfig, 'Renderer');
set(hfig, 'PaperPositionMode', 'auto', 'Renderer', 'opengl');

cdata = hardcopy(hfig, '-Dopengl', '-r0');

% Restore figure to original state
set(hfig, 'PaperPositionMode', orig_mode, 'Renderer', orig_rend); % end
