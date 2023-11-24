%% Derivatives:
%  Find value given the key and value array with
%  the query (key) through binary search.
%
function value = binary_search(keys, values, query)    
    i = 1;
    j = length(keys);

    while(j - i > 1)
        k = floor((i + j) / 2);
        if (keys(k) < query)
            i = k;
        elseif (keys(k) > query)
            j = k;
        else
            value = values(k);
            return;
        end
    end

    value = 0.5 * (values(i) + values(j));
    return;
end