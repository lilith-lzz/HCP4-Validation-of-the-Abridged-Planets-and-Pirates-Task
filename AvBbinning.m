%% Bins outcomes according to whether A vs B more proximal (given set delay)
% ie. if Pun vs Unp LP leads to rewards after 2sec delay (+/- 0.1sec), 
% AvBbinning(reward_times,PunLP_times,UnpLP_times,2) will output a logical index
% for reward_times closer to PunLP_times+2 vs UnpLP_times+2 (within tolerance.

function [A_idx,B_idx] = AvBbinning(outcomes,A_times,B_times,delay,tolerance)

n = length(outcomes);
A_idx = false(n,1);
B_idx = false(n,1);

if ~isempty(A_times) && ~isempty(B_times)
  A_delay = A_times + delay;
  B_delay = B_times + delay;

  for t = 1:n
     if min(abs(outcomes(t)-A_delay)) < min(abs(outcomes(t)-B_delay))
        if min(abs(outcomes(t)-A_delay)) < tolerance
           A_idx(t) = true;
        else
           warning(['Trial' num2str(t) ': not within tolerance']);        
        end
     elseif min(abs(outcomes(t)-A_delay)) > min(abs(outcomes(t)-B_delay))
        if min(abs(outcomes(t)-B_delay)) < tolerance
           B_idx(t) = true;
        else
           warning(['Trial' num2str(t) ': not within tolerance']);        
        end
     else
        warning(['Trial' num2str(t) ': A vs B equally probable?!'])
     end
  end
  
elseif isempty(A_times)
  warning('No A times'); 
  B_delay = B_times + delay;

  for t = 1:n
  	if min(abs(outcomes(t)-B_delay)) < tolerance
     	B_idx(t) = true;
  	else
      warning(['Trial' num2str(t) ': not within tolerance']);        
    end
  end
  
elseif isempty(B_times)
  warning('No B times'); 
  A_delay = A_times + delay;

  for t = 1:n
  	if min(abs(outcomes(t)-A_delay)) < tolerance
     	A_idx(t) = true;
  	else
      warning(['Trial' num2str(t) ': not within tolerance']);        
    end
  end
end
