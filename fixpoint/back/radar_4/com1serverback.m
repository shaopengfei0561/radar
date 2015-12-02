function com1serverback(obj, ~)
global frmstate1;
global frmflag1;
global frmsqen1;
global frmstart1;
global fredata1;

data = fread(obj,1,'uint8');
if frmstart1==1
    frmsqen1=frmsqen1+1;
    fredata1(frmsqen1)=data;
 
    if frmsqen1==7
        crcb=sum(fredata1(2:6));
        if(crcb>255)
            crcb=mod(crcb,256);
        end
        if crcb==fredata1(7)
           %Ö¡½âÎö
           ytfrmpara1(fredata1); 
           frmstart1=0;
           fredata1=0;
           frmsqen1=0;
        else
           frmstart1=0;
           fredata1=0;
           frmsqen1=0;
        end   
    end
end
if frmstate1==1&&data~=255
   frmflag1=0;
   frmstate1=0;
end
if data==255
    frmflag1=frmflag1+1;
    frmstate1=1;
    if frmflag1==1
        frmstart1=1; 
        frmstate1=0;
        frmflag1=0;
        frmsqen1=1;
        fredata1=0;
        fredata1(1)=255;
    end
end
end    