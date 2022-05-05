function [lines, offset] = zip_readlines(zipFile,txtFileName,nLines,offset)
% Reads lines in a zip-compressed text file.
% 
%
% INPUT:
%
%   zipFile:        Name of the zip file.
%   txtFileName:    Name of the compressed text file.
%   nLines:         Number of lines to read.
%   offset:         Position (in bytes) to start reading.
%
%
% OUTPUT:
%
%   lines:          Cellstring of lines read from txtFile. A cell is empty
%                   for  empty lines (containing only \n [and \r]) and
%                   contains false if there were lines requested beyond
%                   EOF. I.e. numel(lines) will allways be equal to nLines
%                   but if nLines exceed the number of lines in the text
%                   file the corresponding cells will contain false.
%
%   offset:         Position (in bytes) where we stopped reading.
%                   Offset can be reused as input to continue reading on
%                   the next line. Cave: Complexity for seeking in zip
%                   files is O(offset), see below.
% 
% Note for using offset: complexity for seeking is O(offset) because we
% need to read and decompress the data up to the desired point.
%
% See also: zip_getContent

% VERSION: 1.0, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied warranties 
% are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU General Public License.

if ~exist('nLines','var') || isempty(nLines)
    nLines = 1;
end
if ~exist('offset','var') || isempty(offset)
    offset = 0;
end

zip_init('readZipFile');

res = py.readZipFile.readlines(zipFile, txtFileName, int64(nLines), uint64(offset));


try
    lines = cellfun(@(x)char(uint8(x)),cell(res{1}),'UniformOutput',false);
    offset = double(res{2});
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