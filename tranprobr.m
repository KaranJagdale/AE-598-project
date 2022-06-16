function p = tranprobr(s,a,ns,lmd,p_s)
    %s is [p1 p2 l1 l2 sp]
    %p:location of bus, l:load, sp: if splitted, 1 otherwise 0
    %a is [a1 a2]
    %1:stop, 2:skip, 3:join, 4:split, 5:nextbs
    %Assuming no two bus reach at stops at the same time
    %let the action array be such that a(1) is action and a(2) is the index
    %of the bus for which the action is executed
    l = a(2) + 2;
    m = a(2);
    ei = a(2) + 5; %Index corresponding to the component for whether the 
    %bus is reached the stop or leaving it
    dec = false;
    if a(1) == 1  %stop action 
        if ns(ei) == 0 && s(ei)== 1            
            dec = true;
            for i = 1:7 
                if ns(i)~=s(i) && i~=l && i~=ei %except load and e other states are same
                    dec = false;
                    break
                end
                
            end
        end
       
        if dec
            p = loadprob(s(l),ns(l),lmd(s(m)),p_s(s(m)));
        else
            p = 0;
        end 

    elseif a(1) == 2  %Skip action 
        if ns(ei) == 0 && s(ei)== 1           
            dec = true;
            for i = 1:7
                if ns(i)~=s(i) && i~=ei
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
        %The join action will be applied only when the corresponding e is 1
        %thus not including that condition here. This action produces
        %deterministic state transition
        if ns(1) == s(m) && ns(2) == s(m) && ns(3) == s(3) 
            if ns(4) == s(4) && ns(5) == 1 && ns(6) == 1 && ns(7) == 0
                p = 1;
            else
                p = 0;
            end
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
        if ns(6) == 0  && ns(7) == 0 && ns(5) == 1    
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
                p = loadprob(s(4),ns(4),lmd(ns(m)),p_s(ns(m))); %Writing ns(m) or ns(2) won't matter as ns(1) = n(2)                
            else
                p = 0;
            end
        else
            p = 0;
        end
    elseif a(1) == 5 %nextbs action
        dec = false;
        if ns(m) == s(m) + 1 && ns(ei) == 1
            dec = true;
        end
        for i = 1:7
            if ns(i) ~= s(i) && i ~= m && i ~= ei
                dec = false;
                break
            end
        end

        if dec
            p = 1;
        else
            p = 0;
        end
        
    end
end