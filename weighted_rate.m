function comb_rate = weighted_rate(rates,times)

idx = any(times);
comb_rate = sum((rates(idx).*times(idx)))/sum(times(idx));