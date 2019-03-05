function price = BS_Eur(S0, K, r, T, sig, q, type);

    %{ 
        
        BLACK SCHOLES FORMULA FOR EUROPEAN OPTIONS
        
        S0 - SPOT PRICE
        K - STRIKE PRICE
        r - INTEREST RATE
        T - TIME TO MATURITY
        sig - VOLATILITY
        q - DIVIDEND YIELD
        type - TYPE OF OPTION (CALL/PUT) : 'c' or 'p'
        
        BS_Eur(50, 60, 0.05, 1, 0.2, 0, 'c')
        BS_Eur(50, 60, 0.05, 1, 0.2, 0, 'p')
        
    %}
    
    d1 = (log(S0 / K) + (r - q + sig * sig / 2) * T) / (sig * sqrt(T));
    d2 = d1 - sig * sqrt(T);
    
    if lower(type) == 'p'
    
        price = K * exp(-r * T) * normcdf(-d2) - S0 * exp(-q * T) * normcdf(-d1);
        
    elseif lower(type) == 'c'
    
        price = S0 * exp(-q * T) * normcdf(d1) - K * exp(-r * T) * normcdf(d2);
        
    end
    
end