function m = zip_init(mName)
%

% TODO: the try/catch workaround for type casting python lists is only
% required if a Cpython is used that is not supported by the Matlab
% release (discoverd with 2020b and python 3.10).
% one can use list.pop to get the elements instead of casting to cell, but
% this does not work for tupels.
% -> check that things work with:
pe = pyenv;
if isempty(pe.Version)
    error('Python not installed.')
end
try cell(py.list({'a'}));
catch ME
    switch ME.identifier
        case {'MATLAB:invalidConversion'}
            % might by incompatible python version...
        otherwise
    end
    throwAsCaller(ME);
end


py_addpath(fileparts(mfilename('fullpath')));

if nargin>0 && ~isempty(mName)
    validateattributes(mName,{'char','string'},{'scalartext'},mfilename,'mName',1);
    m = py.importlib.import_module(mName);
end


end