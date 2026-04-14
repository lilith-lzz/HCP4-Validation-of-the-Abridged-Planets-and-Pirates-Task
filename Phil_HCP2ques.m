%% HumanCondPun questionnaires

% questionnaire subscale/overall names (must start with overall scale name as listed in HCP_aggr)
ques_names = {'audit_overall'}; 

% Scoring matrix (items included in each subscale)
ques{1} = [1 1 1];

% Options per subscale (n-1 added to negatively scored items to properly reverse score)
 rescore = [0 0 0];

% Adds this to all items (per ques) to restore item base value (assumes raw data scored as 0)
 base_score = [0 0 0];

a_leng = length(HCP_aggr);

%%
for q = 1:length(ques_names)  
  n_idx = regexp(ques_names{q},'_');
  ques_field = ['ques_' ques_names{q}(1:n_idx-1)];
  q_idx = find(ques{q} ~= 0);
  q_scoring = ques{q}(q_idx);

  q_rescore = zeros(size(ques{q}));
  if any(ques{q} < 0)
    r_idx = find(ques{q} < 0);
    q_rescore(r_idx) = rescore(q)-1;
  end

  for r = 1:a_leng
    HCP_aggr(r).(ques_names{q}) = sum(HCP_aggr(r).(ques_field)(q_idx).*q_scoring+q_rescore(q_idx)+base_score(q));
  % HCP_aggr(r).(ques_names{q}) = mean(HCP_aggr(r).(ques_field)(q_idx).*q_scoring);
  end
end

clearvars -except HCP* work_folder *keep;