function p = tranprob(s,a,ns,lmd,p_s)
    %s is [p1 p2 l1 l2 sp]
    %p:location of bus, l:load, sp: if splitted, 0 otherwise 1
    %a is [a1 a2]
    %1:stop, 2:skip, 3:join, 4:split
    %Assuming no two bus reach at stops at the same time
    %let the action array be such that a(1) is action and a(2) is the index
    %of the bus for which the action is executed
    l = a(2) + 2;
    m = a(2);
    dec = false;
    if a(1) == 1  %stop action 
        if ns(m) == s(m) + 1             
            dec = true;
            for i = 1:5
                if ns(i)~=s(i) && i~=l && i ~= m  %load of the bus is at i = a(2) + 2
                    dec = false;
                    break
                end
            end
        end
       
        if dec
            p = loadprob(s(l),ns(l),lmd(ns(m)),p_s(ns(m)));
        else
            p = 0;
        end 

    elseif a(1) == 2  %Skip action 
        if ns(m) == s(m) + 1            
            dec = true;
            for i = 1:5
                if ns(i)~=s(i) && i~=m
                    dec = false;
                    break
                end
            end
        end
       
        if dec
            p = 1;
        else
            p = 0;
        end 

    elseif a(1) == 3 %Join
        dec = true;
        s(5) = 0;  %0:joined, 1:splitted
        si = s;    %intermediate state
        if m == 1
            
            si(2) = s(1);
        else
            si(1) = s(2);
        end

        for i = 1:5
            if ns(i) ~= si(i)
                dec = false;
            end
        end
        
        if dec
            p = 1;
        else
            p = 0;
        end
%In real world one module will be at front and another will be back, but 
% here we are not discriminating that and we will have one of the modules
% skipping the stop and other stopping at the stop
% Right now the split transition probability is written almost same as the stop
% action. This is because, split is essentialy the same as the module in
% the front skipping the stop and the module in the back stopping at the
% stop. We will take care of who will reach the next stop first in the main
% code. Moreover assuming the bus with smaller index is in the front so
% that will leave and the bus with larget index will stop at the stop
    elseif a(1) == 4  %Split action
        if ns(1) == s(1) + 1  && ns(2) == s(2) + 1 && ns(5) == 1    
            dec = true;
%             for i = 3:5
%                 if ns(i)~=s(i) %&& i~=l && i ~= m  %load of the bus is at i = a(2) + 2
%                     dec = false;
%                     break
%                 end
%             end
        end
        if dec
            p_back = floor(s(3)*p_s(ns(1)));  %Number of passengers taken to the back module
            if ns(3) == s(3) - p_back     %because we are taking passengers getting down at the stop to the back module                   
                if ns(4) == s(4) + p_back
                    p = loadprob(s(4),ns(4),lmd(ns(m)),p_s(ns(m))); %Writing ns(m) or ns(2) won't matter as ns(1) = n(2)
                else
                    p = 0;
                end
            else
                p = 0;
            end
        else
            p = 0;
        end
    end