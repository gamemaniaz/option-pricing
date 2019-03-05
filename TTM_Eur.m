function price = TTM_Eur(S0, K, r, T, sig, q, N, type)

    %{ 
        
        TRINOMIAL TREE MODEL FOR EUROPEAN OPTIONS
        
        S0 - SPOT PRICE
        K - STRIKE PRICE
        r - INTEREST RATE
        T - TIME TO MATURITY
        sig - VOLATILITY
        q - DIVIDEND YIELD
        N - NUMBER OF STEPS
        type - TYPE OF OPTION (CALL/PUT) : 'c' or 'p'
        
        50, 60, 0.05, 1, 0.2, 0, 10
        
        TTM_Eur(50, 60, 0.05, 1, 0.2, 0, 10, 'c')
        TTM_Eur(50, 60, 0.05, 1, 0.2, 0, 10, 'p')
        
    %}

    dt = T / N;
    u = exp(sig * sqrt(2 * dt));
    d = 1 / u;
    p_u = ((exp(r * dt / 2) - exp(-sig * sqrt(dt / 2))) / ...
        (exp(sig * sqrt(dt / 2)) - exp(-sig * sqrt(dt / 2)))) ^ 2;
    p_d = ((exp(sig * sqrt(dt / 2)) - exp(r * dt / 2))/...
        (exp(sig * sqrt(dt / 2)) - exp(-sig * sqrt(dt / 2))))^2;
    p_m = 1 - p_u - p_d;

    if type == 'c'
    
        for j = -N : N
    
            V(N + 1, j + N + 1) = max(0, S0 * u .^ j - K);
            
        end
        
    elseif type == 'p'
    
        for j = -N : N
    
            V(N + 1, j + N + 1) = max(0, K - S0 * u .^ j);
            
        end
    
    end
    
    for i = N - 1 : -1 : 0
    
        for j = -i : i
        
            V(i + 1, j + N + 1) = (exp(-r * dt)) *( ...
                p_u * V(i + 1 + 1, j + 1 + N + 1)...
                + p_m * V(i +1 + 1, j + N + 1)...
                + p_d * V(i + 1 + 1, j - 1 + N + 1));
                
        end
        
    end

    price = V(1, N + 1);
end