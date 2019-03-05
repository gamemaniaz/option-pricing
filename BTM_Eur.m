function price = BTM_Eur(S0, K, r, T, sig, q, N, type)

    %{ 
        
        BINOMIAL TREE MODEL FOR EUROPEAN OPTIONS
        
        S0 - SPOT PRICE
        K - STRIKE PRICE
        r - INTEREST RATE
        T - TIME TO MATURITY
        sig - VOLATILITY
        q - DIVIDEND YIELD
        N - NUMBER OF STEPS
        type - TYPE OF OPTION (CALL/PUT) : 'c' or 'p'
        
        BTM_Eur(50, 60, 0.05, 1, 0.2, 0, 10, 'c')
        BTM_Eur(50, 60, 0.05, 1, 0.2, 0, 10, 'p')

        
    %}

    dt = T / N;
    u = exp(sig * sqrt(dt));
    d = 1 / u;
    p = (exp((r - q) * dt) - d) / (u - d);
        
    if type == 'c'
    
        for j = 0 : N
        
            f(N + 1, j + 1) = max(S0 * u ^ j * (d ^ (N - j)) - K, 0);
            
        end
        
    elseif type == 'p'
        
        for j = 0 : N
        
            f(N + 1, j + 1) = max(K - S0 * u ^ j * (d ^ (N - j)), 0);
            
        end
    
    end
        
    for i = N - 1 : -1 : 0
        
        for j = 0 : i
        
            f(i + 1, j + 1) = exp(-r * dt) * (p * f(i + 2, j + 2) + (1 - p) * f(i + 2, j + 1));
            
        end
        
    end
    
    price = f(1);
    
end