%creating sub_catageries for REs

%The push bottons below can be changed in the way the user want to
%categaraized the REs such as short term doublets, long term coublets,
%preiodic REs, or unperiodci REs, or any other sub_catageries. 
%for costumuizing ouput see push bottons callbacks below



function [yn]=Catergaraizing_REs(clus_f,cl_inf,i)


    yn=0;
    f = figure('Visible','off');
    %set(f,'Units','normalized','Position',[1/10 1.2/10 1/1.2 1/1.4]);
    %set(f,'Units','normalized','Position',[1.2/10 1.4/10 1/2.4 1/1.2])
    
    %////////////////////////////
    Z=squareform(clus_f{i});
    ZZ=linkage(Z);
    %f=figure(i);
    set(f,'Units','normalized','Position',[.8/10 .9/10 1/1.1 1/1.2])
    [H,T,ord]=dendrogram(ZZ,0,'Orientation','left','ColorThreshold','default');
    set(H,'LineWidth',1.6)
    clear XX
    XX(1:length(clus_f{i}))=.1;
    text(XX,ord,cl_inf.st_time{i},'FontSize',20);
    text(XX+.05,ord,cl_inf.mag{i},'FontSize',20);
    xlim([0 0.2]);
    grid;
    title(num2str(i));
    
    %//////////////////////////////
    
    set(f,'Visible','on');
    
    set(gca,'fontsize',16);
    
    % Create push button
    btn1 = uicontrol('Style', 'pushbutton', 'String', 'RE case 1',...
        'Position', [40 5 200 40],'FontSize',16,...
        'Callback', @pushbutton1_Callback);
    
    
    btn2 = uicontrol('Style', 'pushbutton', 'String', 'RE case 2',...
        'Position', [400 5 200 40],'FontSize',16,...
        'Callback', @pushbutton1_Callback2);
    
    btn3 = uicontrol('Style', 'pushbutton', 'String', 'Doublet case 3',...
        'Position', [740 5 200 40],'FontSize',16,...
        'Callback', @pushbutton1_Callback3);
    
    btn4 = uicontrol('Style', 'pushbutton', 'String', 'RE case 4',...
        'Position', [1080 5 200 40],'FontSize',16,...
        'Callback', @pushbutton1_Callback4);
    
    %pause('on');
    pause;
    
    
    function pushbutton1_Callback(hObject, eventdata, handles)
    
    % change here based on you needs, such as ouputing results in a text file
    yn=1;
    close(gcf);
    %pause('off');
    
    return;
    
    end
    
    
    function pushbutton1_Callback2(hObject, eventdata, handles)
    
    
    close(gcf);
    yn=2;
    %pause('off');
    
    return;
    
    end
    
    function pushbutton1_Callback3(hObject, eventdata, handles)
    
    
    close(gcf);
    yn=3;
    %pause('off');
    
    return;
    
    end
    
    function pushbutton1_Callback4(hObject, eventdata, handles)
    
    
    close(gcf);
    yn=0;
    %pause('off');
    
    return;
    
    end
    
end






