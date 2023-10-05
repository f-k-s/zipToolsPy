function [lines, offset] = zip_readlines(zipFile,txtFileName,nLines,offset,password)
% Reads lines in a zip-compressed text file.
% 
%
% INPUT:
%
%   zipFile:        Name of the zip file.
%                   <char, string>
%   txtFileName:    Name of the compressed text file. 
%                   <char, string>
%   nLines:         Number of lines to read (optional, default: 1). 
%                   <numeric>
%   offset:         Position (in bytes) to start reading (optional,
%                    default: 0). 
%                   <numeric>
%   password:       Password for encrypted zip files (optional). Pass an
%                    empty string if zipFile is not encrypted. 
%                   <char, string>
%
%
% OUTPUT:
%
%   lines:          Cellstring of lines read from txtFile. A cell is empty
%                    for  empty lines (containing only \n [and \r]) and
%                    contains false if there were lines requested beyond
%                    EOF. I.e. numel(lines) will allways be equal to nLines
%                    but if nLines exceed the number of lines in the text
%                    file the corresponding cells will contain false.
%                   <cellstring>
%
%   offset:         Position (in bytes) where we stopped reading.
%                    Offset can be reused as input to continue reading on
%                    the next line. Cave: Complexity for seeking in zip
%                    files is O(offset), see below. 
%                   <double>
% 
% Note for using offset: complexity for seeking is O(offset) because we
%  need to read and decompress the data up to the desired point.
%
% See also: zip_getContent, zip_extract

% VERSION: 1.1, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied
% warranties are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU
% General Public License. 

if ~exist('nLines','var') || isempty(nLines)
    nLines = 1;
end
if ~exist('offset','var') || isempty(offset)
    offset = 0;
end
if ~exist('password','var') || isempty(password)
    password = '';
end

validateattributes(zipFile,{'char','string'},{'scalartext'},mfilename,'zipFile',1);
validateattributes(txtFileName,{'char','string'},{'scalartext'},mfilename,'txtFileName',2);
validateattributes(nLines,{'numeric'},{'scalar','integer'},mfilename,'nLines',3);
validateattributes(offset,{'numeric'},{'scalar','nonnegative','integer'},mfilename,'offset',4);
validateattributes(password,{'char','string'},{'scalartext'},mfilename,'password',5);
[~,pvers] = zip_init('readZipFile');

if offset>0  && str2double(pvers)<3.7
    error('zipToolsPy:pythonVersionDoesNotSupportSeeking','This python version (%s) does not support seeking in compressed files.',pvers);
end


res = py.readZipFile.readlines(zipFile, txtFileName, int64(nLines), uint64(offset), password);


try
    lines = cellfun(@(x)char(uint8(x)),cell(res{1}),'UniformOutput',false);
    if isa(py.None,'py.NoneType')
        offset = NaN;
    else
        offset = double(res{2});
    end
    fallback = false;

catch ME
    switch ME.identifier
        case {'MATLAB:invalidConversion'}
            resChar = erase(char(res),regexpPattern({'^\(\[b''','\)$'}));
            res = split(resChar,regexpPattern('''\], '));
            lines = split(res{1},regexpPattern(''', b'''));
            offset = str2double(res{2});
            fallback = true;
        otherwise
            rethrow(ME);
    end
end


emptyLines = cellfun(@isempty,lines);
lines(emptyLines) = {false};
lines(~emptyLines) = regexprep(lines(~emptyLines),'\r?\n$','');
if fallback
    lines(~emptyLines) = regexprep(lines(~emptyLines),'(\\r)?\\n$','');
end

end