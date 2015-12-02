function com2serverback(obj, ~)
global frmstate2;
global frmflag2;
global frmsqen2;
global frmstart2;
global fredata2;

data = fread(obj,1,'uint8');
if frmstart2==1
    frmsqen2=frmsqen2+1;
    fredata2(frmsqen2)=data;
 
    if frmsqen2==7
        crcb=sum(fredata2(2:6));
        if(crcb>255)
            crcb=mod(crcb,256);
        end
        if crcb==fredata2(7)
           %Ö¡½âÎö
           ytfrmpara2(fredata2); 
           frmstart2=0;
           fredata2=0;
           frmsqen2=0;
        else
           frmstart2=0;
           fredata2=0;
           frmsqen2=0;
        end   
    end
end
if frmstate2==1&&data~=255
   frmflag2=0;
   frmstate2=0;
end
if data==255
    frmflag2=frmflag2+1;
    frmstate2=1;
    if frmflag2==1
        frmstart2=1; 
        frmstate2=0;
        frmflag2=0;
        frmsqen2=1;
        fredata2=0;
        fredata2(1)=255;
    end
end
end    