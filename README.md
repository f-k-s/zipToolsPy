# zipToolsPy
A Matlab interface for the zipfile python module to provide basic tools to read content from zip files.  
Descending into subdirectories within a zip file is currently not supported.


# Functions


## zip_getContent

    content = zip_getContent(zipFile)  
Returns the content of a zip file.

**Input**  
-  *zipFile*  
    Name of the zip file.

**Output**  
-  *content*  
    Structure array with fields
     - file_name
     - file_size
     - compress_size
     - date_time
              containing information for each file in `zipFile`.


## zip_readlines

    [lines, offset] = zip_readlines(zipFile, txtFileName, nLines, offset)  
Reads lines in a zip-compressed text file.

**Input**  
-  *zipFile*  
      Name of the zip file.  
-  *txtFileName*  
      Name of the compressed text file.  
-  *nLines*  
      Number of lines to read.  
-  *offset*  
      Position (in bytes) to start reading.

**Output**  
-  *lines*  
    Cellstring of lines read from `txtFile`. A cell is empty
    for empty lines (containing only `\n` [and `\r`]) and
    contains `false` if there were lines requested beyond
    `EOF`. I.e. `numel(lines)` will allways be equal to `nLines`
    but if `nLines` exceed the number of lines in the text
    file the corresponding cells will contain `false`.  
-  *offset*  
    Position (in bytes) where we stopped reading.
    `offset` can be reused as input to continue reading on
    the next line.  
    ***Cave***: Complexity for seeking in zip files is O(offset).  
