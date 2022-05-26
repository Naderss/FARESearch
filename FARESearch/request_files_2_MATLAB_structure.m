function [sta_str]=request_files_2_MATLAB_structure(t_lines)

%This function creates a MATLAB structure for each  station and loop  over
%each events detected by that station
%Most of the fields are just predefined here and will be assigned later


for i=1:length(t_lines{1})
    
    sta_str(i).net=t_lines{1}{i};
    sta_str(i).name=t_lines{2}{i};
    sta_str(i).chan=t_lines{3}{i};
    sta_str(i).eventID=t_lines{8}(i);
    sta_str(i).st_time=[t_lines{4}{i},' ',t_lines{5}{i}];
    sta_str(i).end_time=[t_lines{6}{i},' ',t_lines{7}{i}];
    sta_str(i).eq_lon=-1*t_lines{10}(i);
    sta_str(i).eq_lat=t_lines{9}(i);
    sta_str(i).eq_mag=t_lines{11}(i);
    sta_str(i).eq_depth=t_lines{12}(i);
    %check if there is gape in  the data or data doesn't exist or
    %everything is fine
    sta_str(i).problem=0; %0 fine %1 doesn't exist %2 gap 
    %Will be asighned after retreiving data. 
    sta_str(i).data=[1;2;3;4];
    sta_str(i).qual=' ';
    sta_str(i).sta_lon=123;
    sta_str(i).sta_lat=123;
    sta_str(i).sta_alt=123;
    sta_str(i).sens=123; %sensitivity
    sta_str(i).sens_freq=123;
    sta_str(i).instr=' '; %instrument
    sta_str(i).sens_units=' ';
    sta_str(i).samp_count=123; %sample count
    sta_str(i).samp_rate=123;
    sta_str(i).fetch_st_time=123;
    sta_str(i).fetch_end_time=123;
end
