function extracted = zip_extract(zipFile,extrctFiles,outPath,password)
% Extracts compressed files from a zip file.
%
%
% INPUT:
%
% zipFile:    Name of the zip file.
%             <char, string>
% 
% extrctFiles: Name(s) of the compressed file(s) that should be extracted.
%             Specify '/all' (case insensitive) to extract all files.
%             <char, string, cellstring> 
% 
% outPath:    Path to extract file(s) to. Non-existing directories will be
%             created. Optional. 
%             <char, string>
% 
% password:   Password for encrypted zip files. Optional.
%             <char, string>
%
%
% OUTPUT:
%
% extracted: Path to the extraced file(s).
%            <cellstring>
%
% See also: zip_readlines, zip_getContent

% VERSION: 1.0, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied warranties 
% are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU General Public License.

zip_init();

if ~exist('outPath','var') || isempty(outPath)
    outPath = fileparts(zipFile);
end

if ~exist('password','var') || isempty(password)
    password = '';
end


validateattributes(zipFile,{'char','string'},{'scalartext'},mfilename,'zipFile',1);
validateattributes(extrctFiles,{'char','string','cell'},{},mfilename,'extrctFiles',2);
validateattributes(outPath,{'char','string'},{'scalartext'},mfilename,'outPath',3);
validateattributes(password,{'char','string'},{'scalartext'},mfilename,'password',4);


if ~iscell(extrctFiles)
    extrctFiles = {extrctFiles};
end

passw = py.bytes(uint8(password));

if any(strcmpi(extrctFiles,'/all'))
    % TODO: extractall() does not return a list of extracted files. use
    % getContent() ... TEST THIS:
    py.zipfile.ZipFile(zipFile).extractall( ...
                            outPath, py.None, passw);
    content = zip_getContent(zipFile);
    names = strrep({content.file_name},'/',filesep);
    extracted = strcat(regexprep(outPath,sprintf('%s$',filesepEscp),''), filesep, names);

else
    extracted = cell(size(extrctFiles));
    for k = 1:numel(extrctFiles)
        extracted{k} = py.zipfile.ZipFile(zipFile).extract( ...
                            extrctFiles{k}, outPath, passw);
    end
    extracted = cellfun(@char,extracted,'UniformOutput',0);
end


% try
%     infoCell = cell(infoList);
%     file_name = cellfun(@(x)char(x.filename),infoCell,'UniformOutput',false);
% 
%     file_size = cellfun(@(x)double(x.file_size),infoCell,'UniformOutput',false);
% 
%     compress_size = cellfun(@(x)double(x.compress_size),infoCell,'UniformOutput',false);
% 
%     dateTimeTPL = cellfun(@(x)cell(x.date_time),infoCell,'UniformOutput',false);
%     dateTimeTPL = vertcat(dateTimeTPL{:});
%     dateTimeDBL = cellfun(@double,dateTimeTPL);
%     date_time = num2cell(datetime(dateTimeDBL)).';
%     
%     fieldnames = {'file_name' 'file_size' 'compress_size' 'date_time'};
%     cntData = [file_name; file_size; compress_size; date_time];
%     content = cell2struct(cntData, fieldnames, 1);
%    
%     
% catch ME
%     switch ME.identifier
%         case {'MATLAB:invalidConversion'}
%             infoCell = split(char(infoList),', <ZipInfo');
%             c = regexp(infoCell, ...
%                             ['(?<=filename='')(?<file_name>[^'']+).*' ...
%                              '(?<=file_size=)(?<file_size>\d+).*' ...
%                              '(?<=compress_size=)(?<compress_size>\d+)'], ...
%                     'names','once');
%             content = vertcat(c{:});
% 
%         otherwise
%             rethrow(ME);
%     end
% end
% 


end


function fsesc = filesepEscp

if ispc, fsesc = '\\';
else,    fsesc = filesep;
end

end