function rw = reward(s,a,lmd,p_s, w_st, w_b, alpha, beta, delta)
%s:state, a:[action, bus on which the action is applied], lmd:lmbda
%parameter (poisson process) for the relevent stop, p_s: p parameter (binomial process)
%w_st:walking time between stations, w_b: waiting time for bus, alpha:
%deboarding time per passenger, beta: boarding time per passenger, delta:
%Time the front module should wait before the rear module reaches to it
%before joining
%state s is defined as s = [location1, location2, load1, load2]
    m = a(2);
    l = a(2) + 2;
    sp  = 5;
    
    switch a(1)
        case 1
            if s(sp) == 1
                rw = s(l)*p_s*w_st - s(l)*(1-p_s)*(alpha*s(l)*p_s + beta*lmd) + lmd*w_b;
            else
                rw = (s(3)+s(4))*p_s*w_st - (s(3)+s(4))*(1-p_s)*(alpha*s(l)*p_s + beta*lmd) + lmd*w_b;
            end
        case 2
            if s(sp) == 1
                rw = -(s(l)*p_s*w_st - s(l)*(1-p_s)*(alpha*s(l)*p_s + beta*lmd) + lmd*w_b);
            else
                rw = -((s(3)+s(4))*p_s*w_st - (s(3)+s(4))*(1-p_s)*(alpha*s(l)*p_s + beta*lmd) + lmd*w_b);
            end
        case 4
            rw = (s(3) + s(4))*p_s*w_st + (s(3)+s(4))*(1-p_s)*(alpha*(s(3)+s(4))*p_s + beta*lmd) + lmd*w_b;
        case 3
            rw = 0.5*((s(3) + s(4))*p_s*w_st + (s(3)+s(4))*(1-p_s)*(alpha*(s(3)+s(4))*p_s + beta*lmd) + lmd*w_b) - delta*(s(3)+s(4))*(1-p_s);
        case 5
            rw = -(0.5*((s(3) + s(4))*p_s*w_st + (s(3)+s(4))*(1-p_s)*(alpha*(s(3)+s(4))*p_s + beta*lmd) + lmd*w_b) - delta*(s(3)+s(4))*(1-p_s));
    end
end