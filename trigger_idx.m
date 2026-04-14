function [filtered_idx] = trigger_idx(ontime,offtime,timestamps)

% Logical index of timestamps between ontime(i) and offtime(i)
sess_leng = length(timestamps);
n_triggers = length(ontime);

idx_matrix = false(n_triggers, sess_leng);

for i = 1:n_triggers
	idx_matrix(i,timestamps>ontime(i) & timestamps < offtime(i)) = true;
end

filtered_idx = any(idx_matrix,1); 