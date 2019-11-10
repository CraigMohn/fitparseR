# -*- coding: utf-8 -*-

from fitparse import FitFile
from fitparse import FitParseError
import sys
import pandas

def message_df(fitfile=None,msgtype='record',
               outfile=None,
               appendunits=True,dropmissing=True,
               fromR=False) :
    if fitfile is None:
        print ("No fitfile given")
        sys.exit(1)

    msgdf =  pandas.DataFrame()
    for msg in fitfile.get_messages(msgtype):
        #msgdict = msg.get_values()
        msgdict = {}
        # Go through all the data entries in this msg
        for msg_data in msg:
            if msg_data.units and appendunits:
                keyname = msg_data.name + "." + msg_data.units
            else:
                keyname = msg_data.name

            msgdict[keyname] = msg_data.value

        msgdf = msgdf.append(msgdict,ignore_index=True)

    msgdf.dropna(axis=0,how='all',inplace=True)
    
    #cnames = msgdf.columns.tolist()
    # old code to filter variables
    #cnames = [i for i in cnames if not ('unknown_' in i or
    #                                    '_position' in i or
    #                                    '.degrees' in i or
    #                                    'power_phase' in i)]
    #msgdf = msgdf[cnames]

    msgdf = msgdf.where((pandas.notnull(msgdf)), None)
    if dropmissing :
        msgdf = msgdf.dropna(axis=1,how='all')

    #msgdf = msgdf.infer_objects()
    if not fromR :
        print("variables extracted:")
        print("\n".join(str(x) for x in msgdf.columns))
        print("dtypes: ")
        print(msgdf.dtypes)

    if outfile is None :
        return msgdf
    else:
         msgdf.to_json(path_or_buf=outfile,date_format='iso',
                       date_unit='s')
         return

def readff(ffname=None) :
    if ffname is None:
        print ("No fit file name given")
        sys.exit(1)
    try:
        fitfile = FitFile(ffname)
        fitfile.parse()
    except FitParseError as e:
        print ("Error while parsing .FIT file: %s" % e)
        sys.exit(1)

    return fitfile

