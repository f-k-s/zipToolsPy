function content = zip_getContent(zipFile)
%


infoCell = cell(py.zipfile.ZipFile(zipFile).infolist());


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

end