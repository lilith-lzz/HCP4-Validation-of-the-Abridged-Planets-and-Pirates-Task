%% HCP ship/shield binner
function windows = HCP_windowbins(PunShips,PunShields,UnpShips,UnpShields,...
  shield_charging_time,feedback_duration)

%% Inputs
% Pun/UnpShips (col1 = start, col2 = outcome (disappear = col2 + feedback_duration)
% Pun/UnpShields (col1 = start, col2 = rt activated, col3 = outcome (disappear = col3 + feedback_duration)
% shield_charging_time (time in same time units as Ships/Shields!)
% feedback_duration (time in same time units as Ships/Shields!)

%% Output
% Ship/shield bins (all else = ITI) 
windows = cell(12,1); % cells containing [start1 end1; startN endN] matrix

%% PunShip {1-6}: 
% PreShield
windows{1} = PunShips;
windows{1}(:,2) = windows{1}(:,1)+shield_charging_time;

% ShieldAvail
idx = ~isnan(PunShields(:,1));
f_idx = find(idx);
windows{2} = PunShields(idx,[1,3]);
idx2 = ~isnan(PunShields(idx,2));
windows{2}(idx2,2) = windows{2}(idx2,1)+PunShields(f_idx(idx2),2);

% Shielded
windows{3} = PunShields(f_idx(idx2),[1,3]);
windows{3}(:,1) = windows{2}(idx2,2);

% NoShield
windows{4} = PunShips(~idx,:);
windows{4}(:,1) = windows{4}(:,1)+shield_charging_time;

% ShieldedOutcome
windows{5} = windows{3};
windows{5}(:,1) = windows{5}(:,2);
windows{5}(:,2) = windows{5}(:,1)+feedback_duration;

% UnshieldedOutcome
windows{6} = PunShips;
windows{6}(:,1) = windows{6}(:,2);
windows{6} = windows{6}(~ismember(windows{6}(:,1),windows{5}(:,1)),:);
windows{6}(:,2) = windows{6}(:,1)+feedback_duration;

%% UnpShip {7-12}: 
% PreShield
windows{7} = UnpShips;
windows{7}(:,2) = windows{7}(:,1)+shield_charging_time;

% ShieldAvail
idx = ~isnan(UnpShields(:,1));
f_idx = find(idx);
windows{8} = UnpShields(idx,[1,3]);
idx2 = ~isnan(UnpShields(idx,2));
windows{8}(idx2,2) = windows{8}(idx2,1)+UnpShields(f_idx(idx2),2);

% Shielded
windows{9} = UnpShields(f_idx(idx2),[1,3]);
windows{9}(:,1) = windows{8}(idx2,2);

% NoShield
windows{10} = UnpShips(~idx,:);
windows{10}(:,1) = windows{10}(:,1)+shield_charging_time;

% ShieldedOutcome
windows{11} = windows{9};
windows{11}(:,1) = windows{11}(:,2);
windows{11}(:,2) = windows{11}(:,1)+feedback_duration;

% UnshieldedOutcome
windows{12} = UnpShips;
windows{12}(:,1) = windows{12}(:,2);
windows{12} = windows{12}(~ismember(windows{12}(:,1),windows{11}(:,1)),:);
windows{12}(:,2) = windows{12}(:,1)+feedback_duration;