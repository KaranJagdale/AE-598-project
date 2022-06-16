function hw = headwayc(state, nxt,  dis_stp, v_bus,count)
    %nxt is the time to reach the next stop, dis_stp is the array of
    %distance between the stops.
    %Rn ignoring the effect of count on the number of passengers wailing at
    % the stop as it does not matter in the long term reward of the policy 
    %
    e1 = state(6); e2 = state(7);
    hw = zeros(1,2);
       
    if state(1) > state(2)
            i_f = 1;
            i_b = 2;
    elseif state(2)>state(1)
            i_f = 2;
            i_b = 1;
    else
        if (nxt(1) > nxt(2) && e1 == e2)||(e2 == 0 && e1 ==1)
            i_f = 2;
            i_b = 1;
        elseif (e1==0 && e2==1) || (nxt(1) < nxt(2) && e1 == e2)
            i_f = 1;
            i_b = 2;
        elseif (nxt(1) == nxt(2) && e1 == e2)
            i_f = 1;
            i_b = 2;
        end
    end

    if state(5) == 1
        joined = false;
    else
        joined = true;
    end
    
    e1 = i_f + 5; e2 = i_b + 5;
    if ~joined
        if state(e1) == 1 && state(e2) == 1
            k = 0;
            for i = state(i_b):state(i_f)-1
                k = k+ dis_stp(i);
            end
            hw(i_b) = nxt(i_b) + k/v_bus;
            
            %computing for i_f
            k = 0;
            for i = 1:size(dis_stp,2)
                if ~((i>state(i_b) || i == state(i_b)) && i<state(i_f))
                    k = k + dis_stp(i);
                end
                hw(i_f) = nxt(i_f) + k/v_bus;
            end
    
        elseif state(e1) == 1 && state(e2) == 0
            k = 0;
            for i = state(i_b)+1:state(i_f)-1
                k = k+ dis_stp(i);
            end
            hw(i_b) = nxt(i_b) + k/v_bus;

            %computing for i_f
            k = 0;
            for i = 1:size(dis_stp,2)
                if ~((i>state(i_b) || i == state(i_b)) && (i<state(i_f) || state(i_f) == i))
                    k = k + dis_stp(i);
                end
                hw(i_f) = nxt(i_f) + k/v_bus;
            end
    
        elseif state(e1) == 0 && state(e2) == 1
            k = 0;
            for i = state(i_b):state(i_f)
                k = k+ dis_stp(i);
            end
            hw(i_b) = nxt(i_b) + k/v_bus - nxt(i_f);

            %computing for i_f
            k = 0;
            for i = 1:size(dis_stp,2)
                if ~((i>state(i_b) ) && i<state(i_f))
                    k = k + dis_stp(i);
                end
                hw(i_f) = nxt(i_f) + k/v_bus - nxt(i_b);
            end
        else
            k = 0;
            for i = state(i_b) + 1:state(i_f)
                k = k+ dis_stp(i);
            end
            hw(i_b) = nxt(i_b) + k/v_bus - nxt(i_f);

            %computing for i_f
            k = 0;
            for i = 1:size(dis_stp,2)
                if ~((i>state(i_b) || i == state(i_b)) && (i<state(i_f) || i == state(i_f)))
                    k = k + dis_stp(i);
                end
                hw(i_f) = nxt(i_f) + k/v_bus - nxt(i_b);
            end
        end
    else
        hw(i_b) = sum(dis_stp)/v_bus;
        hw(i_f) = sum(dis_stp)/v_bus;
    end
            
end