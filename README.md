# zipToolsPy
A Matlab interface for the zipfile python module to provide basic tools to read content from zip files.  




# Functions

**Overview:**  
-  *zip_getContent:* Returns the content of a zip file.  
-  *zip_readlines:* Reads lines from a zipped text file.  
-  *zip_extract:* Extracts specific files from a zip file.  

## zip_getContent

    content = zip_getContent(zipFile)  
Returns the content of a zip file.

**Input**  
-  *zipFile*  
    Name of the zip file. *<char, string>*  

**Output**  
-  *content*  
    *<structure array>* containing information for each file in `zipFile`.  
    Fields:
     - file_name
     - file_size
     - compress_size
     - date_time    

____________________


## zip_readlines

    [lines, offset] = zip_readlines(zipFile, txtFileName, nLines, offset)  
Reads lines in a zip-compressed text file without unpacking the whole file.

**Input**  
-  *zipFile*  
      Name of the zip file. *<char, string>*  
-  *txtFileName*  
      Name of the compressed text file. *<char, string>*  
-  *nLines*  
      Number of lines to read (optional, default: 1). *<numeric>*  
-  *offset*  
      Position (in bytes) to start reading (optional, default: 0). *<numeric>*  
-  *password*  
      Password for encrypted zip files (optional). Pass an empty string if zipFile is not encrypted. *<char, string>*  

**Output**  
-  *lines*  
    Cellstring of lines read from `txtFile`. A cell is empty
    for empty lines (containing only `\n` [and `\r`]) and
    contains `false` if there were lines requested beyond
    `EOF`. I.e. `numel(lines)` will allways be equal to `nLines`
    but if `nLines` exceeds the number of lines in the text
    file, the corresponding cells will contain `false`. *<cellstring>*  
-  *offset*  
    Position (in bytes) where we stopped reading.
    `offset` can be reused as input to continue reading on
    the next line. *<double>*  
    ***Cave***: Complexity for seeking in zip files is O(offset), i.e. reading line by line like this would be *inefficient*:  
    
        offset0 = 0; offset = offset0;
        nLines = 100;
        lines = cell(nLines,1);
        for li = 1:nLines
            [lines(li), offset] = zip_readlines(zipFile, txtFileName, 1, offset);
        end

     On each interation all data unti `li` has to be decompressed. So instead do:
     
         lines = zip_readlines(zipFile, txtFileName, nLines, offset0);  

____________________


## zip_extract

    extracted = zip_extract(zipFile, extrctFiles, outPath, password)  
Extracts compressed files from a zip file.

**Input**  
-  *zipFile*  
      Name of the zip file. *<char, string>*  
-  *extrctFiles*  
      Name(s) of the compressed file(s) that should be extracted. Specify '/all' (case insensitive) to extract all files. *<char, string, cellstring>*  
-  *outPath*  
      Path to extract file(s) to. Non-existing directories will be created (optional). *<char, string>*  
-  *password*  
      Password for encrypted zip files (optional). Pass an empty string if zipFile is not encrypted.  *<char, string>*  

**Output**  
-  *extracted*  
      Path of the extraced file(s). *<cellstring>*  
