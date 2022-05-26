function [fin_str]=IrisFetch_runner_NCEDC(bef_str)
%%
%this function fetch the data and add it to the structure
%
%input parammeter:
%bef_str : a MATALB structure contains information for requesting data
%using irisFetch.m, the MATLAB structure is defined in 
%create_Mat_structure_from_phase_inf.m function

    
    
    disp([bef_str(1).net,'--',bef_str(1).name,'--',bef_str(1).chan]);
    for i=1:length(bef_str)
        %fetch data using irisFetch
        try 
            
        data_trace=irisFetch.Traces(bef_str(i).net,bef_str(i).name,'*',...
            bef_str(i).chan,bef_str(i).st_time,bef_str(i).end_time,...
             'federated','http://service.ncedc.org/');%,'includePZ');
        catch 
            disp('error in irisFetch');
            bef_str(i).problem=3;
            continue;
        end
        
        %lets check if the data is alright and everything is fine!
        if ~isfield(data_trace,'NCEDC')
            disp('error in irisFetch');
            bef_str(i).problem=3;
            continue;
        end
        
        if length(data_trace.NCEDC)==1
        else
            if isempty(data_trace.NCEDC);
                bef_str(i).problem=1;
                continue;
            elseif length(data_trace.NCEDC)>1
                bef_str(i).problem=2;
                continue;
            end
        end
        

         try
             d = data_trace.NCEDC.data;
             d = d -mean(d);
             d   = taperd(d,0.05);
             d = bandpass(d,[1 15],data_trace.NCEDC.sampleRate);
         catch 
             disp('error in bandpass');
             bef_str(i).problem=4;
             continue;
         end
        

        %now it is time to complete the super structure 
        %////////////////////////////////////////////////
        bef_str(i).data_raw = data_trace.NCEDC.data;
        bef_str(i).data=d;
        bef_str(i).qual=data_trace.NCEDC.quality;
        bef_str(i).sta_lon=data_trace.NCEDC.longitude;
        bef_str(i).sta_lat=data_trace.NCEDC.latitude;
        bef_str(i).sta_alt=data_trace.NCEDC.elevation+data_trace.NCEDC.depth;
        bef_str(i).sens=data_trace.NCEDC.sensitivity; %sensitivity
        bef_str(i).sens_freq=data_trace.NCEDC.sensitivityFrequency;
        bef_str(i).instr=data_trace.NCEDC.instrument; %instrument
        bef_str(i).sens_units=data_trace.NCEDC.sensitivityUnits;
        bef_str(i).samp_count=data_trace.NCEDC.sampleCount; %sample count
        bef_str(i).samp_rate=data_trace.NCEDC.sampleRate;
        bef_str(i).fetch_st_time=data_trace.NCEDC.startTime;
        bef_str(i).fetch_end_time=data_trace.NCEDC.endTime;
        %///////////////////////////////////////////
        clear data_trace
    end
    
    fin_str=bef_str;
end

        
    
        