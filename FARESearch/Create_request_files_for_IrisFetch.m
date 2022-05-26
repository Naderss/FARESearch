function Create_request_files_for_IrisFetch(text,site,sub_grid_dir)
%%
%Grab/calculate phase start and end time from Northern California 
%Earthquake Catalog Search(http://www.ncedc.org/ncedc/catalog-search.html)
%for specific station and outputs it as a text file.
%
%Author: David Guenaga
%dguen001@ucr.edu
%5/17/2016

%modified by Nader Shakibay Senobari winter/2017
%modified by NSS to fix a bug related to the decimal degree, spring 2022

%______________________________________________________________________
%Input Parameters:

%text: phase information of earhtquake catalog in a text format similar 
%to ouputs from textscan(id,'%s %*[^\n]','Delimiter','|') function.

%site: Here is refred to the station name and Netwrok, channel also can be
%specified, but by defualt it is assumed to be the vertical channel

%sub_grid_dir: the file directory to store the request files

%________________________________________________________________________
%some parameters to be set

t_start=-5; %start time in seconds to request data before the station
            %arrival phase 
            
t_end=15;   %end time in seconds to request data after the station arrival 
            %phase
            

%Calculate date/time and print to textfile.
T=1; % 1=true,0=false.

datalines='';
first=1; %1=true,0=false.
all=length(text{1})
for i=1:all;
    if length(text{1}{i})<10
        continue;
    end
    if  (T==strcmp(text{1}{i}(1:3),site))||(T==strcmp(text{1}{i}(1:4),site));
        %testline=strcat(['_',int2str(i),'\n']);
        %fprintf(testid,testline);
        %disp(strcat('Line ',int2str(i)));
        if strcmp(text{1}{i}(31:32),'  ')==1;
            if strcmp(text{1}{i}(33:34),'  ')==1;
                date=datenum(text{1}{i}(18:29),'yyyymmddhhMM');
            else
                date=addtodate(datenum(text{1}{i}(18:29),'yyyymmddhhMM'),str2double(text{1}{i}(33:34))*10,'millisecond');
            end
        elseif strcmp(text{1}{i}(33:34),'  ')==1;
            date=datenum(text{1}{i}(18:32),'yyyymmddhhMM ss');
        else
            date=addtodate(datenum(text{1}{i}(18:32),'yyyymmddhhMM ss'),str2double(text{1}{i}(33:34))*10,'millisecond');
        end
        starttime=datestr(addtodate(date,t_start,'second'),'yyyy-mm-dd hh:MM:ss.FFF0');
        endtime=datestr(addtodate(date,t_end,'second'),'yyyy-mm-dd hh:MM:ss.FFF0');
        
        %magnitude, ID, lon lat and depth calclulating
        j=i;
        
        while strcmp(text{1}{j}(8),' ') == 1
        j=j-1;
        end
    
        depth=num2str(str2num(text{1}{j}(32:36))/100);
        mag=num2str(str2num(text{1}{j}(148:150))/100);
        evID=text{1}{j}(137:146);
        lon = num2str(-1*(str2num(text{1}{j}(24:26)) + (round(str2num(text{1}{j}(28:31))*(100/60)))/10000));
        lat = num2str(str2num(text{1}{j}(17:18))+ (round(str2num(text{1}{j}(20:23))*(100/60)))/10000);

        
        if first==1;
            st=text{1}{i}(6:7);
            comp=text{1}{i}(10:12);
            datalines=[st,' ',site,' ',comp,' ',starttime,' ',endtime,' ',evID,' ',lat,' ',lon,' ',mag,' ',depth];
            first=0;
        else
            datalines=strcat([datalines,'\n',st,' ',site,' ',comp,' ',starttime,' ',endtime,' ',evID,' ',lat,' ',lon,' ',mag,' ',depth]);
        end
    end
end

%Create new text file.
extra='';
newfile=strcat(sub_grid_dir,'/',site,'_',st,'_',comp,extra,'.txt');
newid=fopen(newfile,'wt');
fprintf(newid,datalines);
fclose(newid);
end



