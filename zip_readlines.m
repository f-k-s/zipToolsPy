function [lines, offset] = zip_readlines(zipFile,txtFileName,nLines,offset)
%
% Note for using offset: complexity for seeking is O(offset) because we
% need to read and decompress the data up to the desired point.

if ~exist('nLines','var') || isempty(nLines)
    nLines = 1;
end
if ~exist('offset','var') || isempty(offset)
    offset = 0;
end

m = loadModule('readZipFile');

res = py.readZipFile.readlines(zipFile, txtFileName, uint64(nLines), uint64(offset));

try
    lines = cellfun(@(x)char(uint8(x)),cell(res{1}),'UniformOutput',false);
    offset = double(res{2});
    fallback = false;
catch
    resChar = erase(char(res),regexpPattern({'^\(\[b''','\)$'}));
    res = split(resChar,regexpPattern('''\], '));
    lines = split(res{1},regexpPattern(''', b'''));
    offset = str2double(res{2});
    fallback = true;
end

emptyLines = cellfun(@isempty,lines);
lines(emptyLines) = {false};
lines(~emptyLines) = regexprep(lines(~emptyLines),'\r?\n$','');
if fallback
    lines(~emptyLines) = regexprep(lines(~emptyLines),'(\\r)?\\n$','');
end

end