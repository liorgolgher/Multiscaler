%% List File Readout
function [binary_data, time_patch, range] = LSTDataRead(FileName)

fileID = fopen(FileName);

%% Find the range value
formatSpec = 'range=%d';
range_cell = textscan(fileID, formatSpec, 'HeaderLines', 1);
range_before_bit_depth = cell2mat(range_cell);

%% Find the bit depth value
formatSpec = 'bitshift=%d';
bitshift_cell = textscan(fileID, formatSpec, 'HeaderLines', 32);
bitshift = mod(bitshift_cell{1,1}, 100);
range = range_before_bit_depth * 2^(bitshift);

%% Find the time_patch value
formatSpec = 'time_patch=%s';
time_patch_str = textscan(fileID, formatSpec, 'HeaderLines', 45);
time_patch = cell2mat(time_patch_str{1,1});

%% Reach Data
formatSpec = '%s';
temp1 = {'[DATA]'}; % Start of DATA text line
temp2 = {'abc'}; % Initialization
tic;
while ~cellfun(@strcmp, temp1, temp2);
    temp2 = textscan(fileID, formatSpec, 1);
end
toc;

%% Read Data
tic;
hex_data = textscan(fileID, formatSpec);
toc;

%% Depending on time_patch number, read the data vector accordingly
if (strcmp('32', time_patch) || strcmp('1a', time_patch)) % CURRENTLY ONLY FITS TIMEPATCH_32 OR TIMEPATCH_1a
    tic;
    binary_data = hex2bin(hex_data{1,1}(:,1), 48);
    toc;
end

end
