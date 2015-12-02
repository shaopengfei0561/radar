function tcpserverback(obj, ~)
global frmstate;
global frmflag;
global frmsqen;
global frmstart;
global fredata;
global frmlength;
data = fread(obj,1,'uint8');
if frmstart==1
    frmsqen=frmsqen+1;
    fredata(frmsqen)=data;
    if frmsqen==7
        frmlength=fredata(7)*256+fredata(6);
    end
    if frmsqen==frmlength
        if crc(fredata(1:(frmlength-1)))==fredata(frmlength)
           %Ö¡½âÎö
           frmpara(fredata); 
           frmstart=0;
           fredata=[];
           frmsqen=0;
           frmlength=0;
        else
           frmstart=0;
           fredata=[];
           frmsqen=0;
           frmlength=0;
        end   
    end
end
if frmstate==1&&data~=223
   frmflag=0;
   frmstate=0;
end
if data==223
    frmflag=frmflag+1;
    frmstate=1;
    if frmflag==4
        frmstart=1; 
        frmstate=0;
        frmflag=0;
        frmsqen=4;
        fredata=[];
        frmlength=0;
        fredata(1:4)=223;
    end
end
end    
