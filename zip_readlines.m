function [lines, offset] = zip_readlines(zipFile,txtFileName,nLines,offset)
%

if ~exist('nLines','var') || isempty(nLines)
    nLines = 1;
end
if ~exist('offset','var') || isempty(offset)
    offset = 0;
end

m = loadModule('readZipFile');

res = m.readlines(zipFile, txtFileName, uint64(nLines), uint64(offset));

offset = double(res{2});

lines = cellfun(@(x)char(uint8(x)),cell(res{1}),'UniformOutput',false);
emptyLines = cellfun(@isempty,lines);
lines(emptyLines) = {false};
lines(~emptyLines) = regexprep(lines(~emptyLines),'\r?\n$',''); % keep newline & cr to 

end