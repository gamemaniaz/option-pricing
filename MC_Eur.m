function price = MC_Eur(S0, K, r, T, mu, sig, Nstep, Nrep, type)
    
    %{ 
        
        MONTE CARLO METHOD FOR EUROPEAN OPTIONS
        
        S0 - SPOT PRICE
        K - STRIKE PRICE
        r - INTEREST RATE
        T - TIME TO MATURITY
        mu - MEAN
        sig - VOLATILITY
        Nstep - NUMBER OF STEPS
        Nrep - NUMBER OF SIMULATIONS
        type - TYPE OF OPTION (CALL/PUT) : 'c' or 'p'
        
        MC_Eur(50, 60, 0.05, 1, 0.045, 0.2, 100, 1000, 'c')
        MC_Eur(50, 60, 0.05, 1, 0.045, 0.2, 100, 1000, 'p')
        
    %}
    
    dt = T / Nstep;
    AP = S0 * [ones(1, Nrep); cumprod(exp(dt * (mu - sig ^ 2 / 2) + sig * sqrt(dt) * randn(Nstep, Nrep)), 1)];
    
    if lower(type) == 'p'
    
        payoff = max(K - AP(end, : ), 0);
        price = mean(payoff) * exp(-r * dt);
        
    elseif lower(type) == 'c'
    
        payoff = max(AP(end, : ) - K, 0);
        price = mean(payoff) * exp(-r * dt);   
        
    end
        
end