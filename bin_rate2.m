function [out_rate, out_time, rates, times] = bin_rate2(response_times, total_time, windows)

%% Inputs
% response_times = timestamps of responses
% total_time = total block duration (out_time = total-(window times))
% windows = cells containing array of windows 
%           {[startA1 endA1; startAn endAn]} {[startB1 endB1; startBn endBn]
%% Outputs

n_cell = length(windows);
rates = cell(n_cell,1);
idx = false(length(response_times),n_cell);
times = zeros(n_cell,1);

for n = 1:n_cell
  if ~isempty(windows{n})
    times(n) = sum(windows{n}(:,2)-windows{n}(:,1));
    idx(:,n) = trigger_idx(windows{n}(:,1),windows{n}(:,2),response_times);
    rates{n} = sum(idx(:,n))/times(n);
  else
    rates{n} = NaN;
  end
end

if any(sum(idx,2)>1)
  warning('Double counting responses: overlapping windows'); % out_time incorrect if windows overlap
end

out_time = total_time - (sum(times));
out_rate = sum(~any(idx,2))/out_time;
