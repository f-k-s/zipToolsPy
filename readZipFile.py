# -*- coding: utf-8 -*-
"""
Created on Fri Apr 29 10:14:23 2022

@author: Konrad
"""
import zipfile

def readlines(inFile, txtFile, n=1, offset=0):
    """
    

    Parameters
    ----------
    inFile : TYPE
        DESCRIPTION.
    txtFile : TYPE
        DESCRIPTION.
    n : TYPE, optional
        DESCRIPTION. The default is 1.
    offset : TYPE, optional
        DESCRIPTION. The default is 0.

    Returns
    -------
    lns : TYPE
        DESCRIPTION.
    TYPE
        DESCRIPTION.

    """
    
    with zipfile.ZipFile(inFile) as z:
        with z.open(txtFile) as f:
            f.seek(offset)
            lns = [f.readline() for k in range(n)]
            pos = f.tell()
    return lns, pos



def getFileList(inFile):
    z = zipfile.ZipFile(inFile)
    return z.infolist()