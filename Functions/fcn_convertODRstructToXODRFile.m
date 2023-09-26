function fcn_convertODRstructToXODRFile(data)
  % This function converts a matlab struct to a xodr file
  % Input:
  % structFileName: the mat file you want to load, in string
  % Define a filename based on the time to avoid accidentally overwriting previous files
  myFilename = ['testXODR_' datestr(now,'yy-mm-ddTHH-MM-SS')];
  % Write the XODR structure to an XML formatted file
  struct2xml(data,myFilename)
  % Move the output file so that it has an XODR file extension
  movefile([myFilename '.xml'],[myFilename '.xodr'])
end