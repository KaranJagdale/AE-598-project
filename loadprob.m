function lp = loadprob(l1, l2, lmd, p_s, nst)
    lp = 0;
    for m = 0:l1
        if l2> l1-m || l2 == l1-m
            lp = lp + nCr(l1,m)*p_s^m*(1-p_s)^(l1-m)*lmd^(l2-l1+m)*exp(-lmd)/factorial(l2 - l1 + m);
        else
            lp = 0;
        end
    end
end