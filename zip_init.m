function [m,pvers] = zip_init(mName)
% [m,pvers] = zip_init(mName)
% Adds path and imports module for python; for internal use only.

% VERSION: 1.0, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied warranties 
% are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU General Public License.

if verLessThan('Matlab','8.4')
    error('zipToolsPy:tooOldMatlabVersion','It seems that this version of Matlab is tool old and does not provide an interface to python.');
elseif verLessThan('Matlab','9.7')
    pvers = pyversion; %#ok
    helpfun = 'pyversion';
else
    pvers = pyenv().Version;
    helpfun = 'pyenv';
end
if strlength(pvers)==0
    error('zipToolsPy:noCPythonFound', ...
        ['No Python interpreter configured.\n', ...
         'Use <a href="matlab:doc(''%s'')">%s</a> to setup a python interpreter. ', ...
          'This is persistent across Matlab sessions.'], ... 
        helpfun, helpfun);
end

try cell(py.list({'a'}));
catch ME
    switch ME.identifier
        case {'MATLAB:invalidConversion'}
            % might by incompatible python version...
            compatTableLink = 'https://www.mathworks.com/content/dam/mathworks/mathworks-dot-com/support/sysreq/files/python-compatibility.pdf';
            warnID = 'zipToolsPy:pythonVersionMayBeUnsupported';
            warnOffCmd = sprintf('warning(''off'',''%s'')',warnID);
            warning('zipToolsPy:pythonVersionMayBeUnsupported',...
               ['Type-cast from python data type failed. This may be caused by an unsupported version of python.\n',...
                'See <a href="%1$s">', ...
                'here</a> for a list of versions supported by different Matlab releases.\n', ...
                'Run <a href="matlab:%2$s">', ...
                '%2$s</a> to disable this warning.'], compatTableLink, warnOffCmd);
        otherwise
            throwAsCaller(ME);
    end
end


py_addpath(fileparts(mfilename('fullpath')));

if nargin>0 && ~isempty(mName)
    validateattributes(mName,{'char','string'},{'scalartext'},mfilename,'mName',1);
    m = py.importlib.import_module(mName);
else
    m = [];
end


end