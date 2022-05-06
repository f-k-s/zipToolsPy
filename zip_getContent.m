function content = zip_getContent(zipFile)
% Returns information about the files contained in a zip file.
%
%
% INPUT:
%
% zipFile:    Name of the zip file.
%
%
% OUTPUT:
%
% content:    Structure array with fields
%                  - file_name
%                  - file_size
%                  - compress_size
%                  - date_time
%               containing information for each file in zipFile.
%
% See also: zip_readlines

% VERSION: 1.0, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied warranties 
% are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU General Public License.

zip_init();
infoList = py.zipfile.ZipFile(zipFile).infolist();


    
try
    infoCell = cell(infoList);
    file_name = cellfun(@(x)char(x.filename),infoCell,'UniformOutput',false);

    file_size = cellfun(@(x)double(x.file_size),infoCell,'UniformOutput',false);

    compress_size = cellfun(@(x)double(x.compress_size),infoCell,'UniformOutput',false);

    dateTimeTPL = cellfun(@(x)cell(x.date_time),infoCell,'UniformOutput',false);
    dateTimeTPL = vertcat(dateTimeTPL{:});
    dateTimeDBL = cellfun(@double,dateTimeTPL);
    date_time = num2cell(datetime(dateTimeDBL)).';
    
    fieldnames = {'file_name' 'file_size' 'compress_size' 'date_time'};
    cntData = [file_name; file_size; compress_size; date_time];
    content = cell2struct(cntData, fieldnames, 1);
   
    
catch ME
    switch ME.identifier
        case {'MATLAB:invalidConversion'}
            infoCell = split(char(infoList),', <ZipInfo');
            c = regexp(infoCell, ...
                            ['(?<=filename='')(?<file_name>[^'']+).*' ...
                             '(?<=file_size=)(?<file_size>\d+).*' ...
                             '(?<=compress_size=)(?<compress_size>\d+)'], ...
                    'names','once');
            content = vertcat(c{:});

        otherwise
            rethrow(ME);
    end
end



end