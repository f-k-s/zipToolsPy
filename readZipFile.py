# -*- coding: utf-8 -*-
"""

% VERSION: 1.0, May 2022
% AUTHOR: Konrad Schumacher
%
% NOTE: This function is provided "as is" and any express or implied warranties 
% are disclaimed.

% Copyright (c) 2022, Konrad Schumacher
% All rights reserved.
% This code is free and open source software made available under the GNU General Public License.

@author: Konrad

"""
import zipfile

# TODO: support encripted zip files
def readlines(inFile, txtFile, n=1, offset=0):
    """
    Reads lines of a zip-compressed text file starting at a given offset

    Parameters
    ----------
    inFile : string
        ZIP file name that contains the text file to be read.
    txtFile : string
        Name of the compressed text file to be read.
    n : int, optional
        Number of lines to be read. The default is 1. If n<0 everything until EOF will be read.
    offset : int, optional
        Offset where we start reading in bytes. The default is 0 = BOF.

    Returns
    -------
    lns : list
        List of strings containing the lines read.
    pos : int
        Position (bytes) in file where we stopped reading.

    """
    
    with zipfile.ZipFile(inFile) as z:
        with z.open(txtFile) as f:
            f.seek(offset)
            if n<0:
                lns = f.readlines()
            else:
                lns = [f.readline() for k in range(n)]
            pos = f.tell()
    return lns, pos


def getFileList(inFile):
    z = zipfile.ZipFile(inFile)
    return z.infolist()