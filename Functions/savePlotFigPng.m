function savePlotFigPng(fig, fullsafeName, appendix)
%SAVEPLOTFIGPNG Save a plot figure as both .fig and .png files
%   savePlotFigPng(fig, fullsafeName, appendix) saves the input figure `fig` as both a .fig and .png file.
%   The files will be named with the `fullsafeName` and `appendix` provided. The .fig file will have the
%   appendix added to the file name, while the .png file will have the `appendix` and the ".png" extension
%   added to the file name.
%
%   Inputs:
%   - fig: The figure to be saved.
%   - fullsafeName: The base file name to be used for saving the files.
%   - appendix: The appendix to be added to the file names.
%
%   Example:
%   savePlotFigPng(fig, 'myfigure', 'plot1');
%
%   See also SAVEFIG, EXPORTGRAPHICS.

% Save the figure as a .fig file
savefig(fig, append(fullsafeName, '_', appendix, '.fig'));

% Save the figure as a .png file with a resolution of 600 DPI
exportgraphics(fig, append(fullsafeName, '_', appendix, '.png'), 'Resolution', 600);

disp("Plot saved as:")
disp(append(fullsafeName, '_', appendix, '.fig'))
disp(append(fullsafeName, '_', appendix, '.png'))
disp('------------------------------------------------------------------')
end