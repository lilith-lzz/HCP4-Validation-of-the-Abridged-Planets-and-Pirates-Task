function sum_fig = HCP2_sumfig2(HCP_blockstruct,pun_trials)

%% Inputs
% HCP_structrow = HCP_aggr row
% n_phases = total number of blocks
% pun_trials = punished blocks eg. [2:5]

%% Collate data
n_phases = length(HCP_blockstruct.End);

pun_rates = NaN(9,n_phases); %ITI,PunShp/UnpShp:PreShld,ShldAv,Shielded,NoShld
unp_rates = NaN(9,n_phases);
PunS_suppr = NaN(3,n_phases); %Unshlded Pun/UnpRate
UnpS_suppr = NaN(3,n_phases);
punS_sum = NaN(3,n_phases); % n ships, n shieldsAv, n shielded
unpS_sum = NaN(3,n_phases);

% Rew,PunP,UnpP,PunS,UnpS,Atk
values = vertcat(HCP_blockstruct.RewVal,...
  HCP_blockstruct.PunPlanetVal,...
  HCP_blockstruct.UnpPlanetVal,...
  HCP_blockstruct.PunShipVal,...
  HCP_blockstruct.UnpShipVal,...
  HCP_blockstruct.AttackVal);

%Planet-Rew,Planet-PunS,Planet-UnpS,Planet-Atk,Ship-Atk
pun_infs = vertcat(HCP_blockstruct.PunPlanet_RewInf,...
  HCP_blockstruct.PunPlanet_PunShipInf,...
  HCP_blockstruct.PunPlanet_UnpShipInf,...
  HCP_blockstruct.PunPlanet_AttackInf,...
  HCP_blockstruct.PunShip_AttackInf);

unp_infs = vertcat(HCP_blockstruct.UnpPlanet_RewInf,...
  HCP_blockstruct.UnpPlanet_PunShipInf,...
  HCP_blockstruct.UnpPlanet_UnpShipInf,...
  HCP_blockstruct.UnpPlanet_AttackInf,...
  HCP_blockstruct.UnpShip_AttackInf);
  
% pref_infs = vertcat(HCP_blockstruct.PrefPred,...
%   HCP_blockstruct.PrefReval);

for p = 1:n_phases  
  pun_rates(:,p) = HCP_blockstruct.BinPunRate{p}([1:5, 8:11]);
  unp_rates(:,p) = HCP_blockstruct.BinUnpRate{p}([1:5, 8:11]);

  if ismember(p,pun_trials) 
    try 
    PunS_suppr(1,p) = weighted_rate(HCP_blockstruct.BinPunRate{p}([2,3,5]),...
        HCP_blockstruct.BinTime{p}([2,3,5]))...
      ./(weighted_rate(HCP_blockstruct.BinPunRate{p}([2,3,5]),...
        HCP_blockstruct.BinTime{p}([2,3,5]))+pun_rates(1,p));
    catch
      warning(['Issue calculating PunS suppression (pun clicks)']);
    end
    try
    PunS_suppr(2,p) = weighted_rate(HCP_blockstruct.BinUnpRate{p}([2,3,5]),...
        HCP_blockstruct.BinTime{p}([2,3,5]))...
      ./(weighted_rate(HCP_blockstruct.BinUnpRate{p}([2,3,5]),...
        HCP_blockstruct.BinTime{p}([2,3,5]))+unp_rates(1,p));
    catch
      warning(['Issue calculating PunS suppression (unp clicks)']);
    end
    try
    PunS_suppr(3,p) = weighted_rate([HCP_blockstruct.BinPunRate{p}([2,3,5]);...
        HCP_blockstruct.BinUnpRate{p}([2,3,5])],...
        [HCP_blockstruct.BinTime{p}([2,3,5]);HCP_blockstruct.BinTime{p}([2,3,5])])...
      ./(weighted_rate([HCP_blockstruct.BinPunRate{p}([2,3,5]);...
        HCP_blockstruct.BinUnpRate{p}([2,3,5])],...
        [HCP_blockstruct.BinTime{p}([2,3,5]);HCP_blockstruct.BinTime{p}([2,3,5])])+...
        mean([pun_rates(1,p) unp_rates(1,p)]));
    catch
      warning(['Issue calculating PunS suppression (either clicks)']);
    end
    try
    UnpS_suppr(1,p) = weighted_rate(HCP_blockstruct.BinPunRate{p}([8,9,11]),...
        HCP_blockstruct.BinTime{p}([8,9,11]))...
      ./(weighted_rate(HCP_blockstruct.BinPunRate{p}([8,9,11]),...
        HCP_blockstruct.BinTime{p}([8,9,11]))+pun_rates(1,p));
    catch
      warning(['Issue calculating UnpS suppression (pun clicks)']);
    end
    try
    UnpS_suppr(2,p) = weighted_rate(HCP_blockstruct.BinUnpRate{p}([8,9,11]),...
        HCP_blockstruct.BinTime{p}([8,9,11]))...
      ./(weighted_rate(HCP_blockstruct.BinUnpRate{p}([8,9,11]),...
        HCP_blockstruct.BinTime{p}([8,9,11]))+unp_rates(1,p));
    catch
      warning(['Issue calculating UnpS suppression (unp clicks)']);
    end
    try
    UnpS_suppr(3,p) = weighted_rate([HCP_blockstruct.BinPunRate{p}([8,9,11]);...
        HCP_blockstruct.BinUnpRate{p}([8,9,11])],...
        [HCP_blockstruct.BinTime{p}([8,9,11]);HCP_blockstruct.BinTime{p}([8,9,11])])...
      ./(weighted_rate([HCP_blockstruct.BinPunRate{p}([8,9,11]);...
        HCP_blockstruct.BinUnpRate{p}([8,9,11])],...
        [HCP_blockstruct.BinTime{p}([8,9,11]);HCP_blockstruct.BinTime{p}([8,9,11])])+...
        mean([pun_rates(1,p) unp_rates(1,p)]));  
    catch
      warning(['Issue calculating UnpS suppression (either clicks)']);
    end    

    punS_sum(1,p) = size(HCP_blockstruct.PunShips{p},1);
    punS_sum(2,p) = sum(~isnan(HCP_blockstruct.PunShields{p}(:,1)));
    punS_sum(3,p) = sum(~isnan(HCP_blockstruct.PunShields{p}(:,2)));
    unpS_sum(1,p) = size(HCP_blockstruct.UnpShips{p},1);
    unpS_sum(2,p) = sum(~isnan(HCP_blockstruct.UnpShields{p}(:,1)));
    unpS_sum(3,p) = sum(~isnan(HCP_blockstruct.UnpShields{p}(:,2)));
  end
end

sum_fig = figure;

%% Planet LP rates
subplot(2,3,1); hold on  
title('Pun/Unp Planet click rates');

plot(1:n_phases,pun_rates(1,:)*60,'Color',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.1,pun_rates(2,:)*60,'d-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.2,pun_rates(3,:)*60,'d-.','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.3,pun_rates(4,:)*60,'d--','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.2,pun_rates(5,:)*60,'d:','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.1,pun_rates(6,:)*60,'o-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5); 
plot([1:n_phases]+.2,pun_rates(7,:)*60,'o-.','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.3,pun_rates(8,:)*60,'o--','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.2,pun_rates(9,:)*60,'o:','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);

plot(1:n_phases,unp_rates(1,:)*60,'Color',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.1,unp_rates(2,:)*60,'d-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.2,unp_rates(3,:)*60,'d-.','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.3,unp_rates(4,:)*60,'d--','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.2,unp_rates(5,:)*60,'d:','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.1,unp_rates(6,:)*60,'o-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.2,unp_rates(7,:)*60,'o-.','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.3,unp_rates(8,:)*60,'o--','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot([1:n_phases]+.2,unp_rates(9,:)*60,'o:','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);

xlabel('Block');
xlim([0.5 n_phases+0.5]);
xticks(1:n_phases);
ylabel('Click rate (per min)');
ylims = ylim;
ylims(1) = 0;
ylim(ylims);
legend({'          ITI' ' PunS PreShld' ' PunS ShldAv' ' PunS Shlded' ...
   ' PunS NoShld' ' UnpS PreShld' ' UnpS ShldAv' ' UnpS Shlded' ' UnpS NoShld' ...
   ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '}, 'NumColumns',2,'Location','best');
legend('boxoff');

%% Preference/suppression ratio
subplot(2,3,2); hold on
title('Ratios');

plot(1:n_phases,pun_rates(1,:)./(pun_rates(1,:)+unp_rates(1,:)),'k-','LineWidth',1.5);

plot(1:n_phases,PunS_suppr(3,:),'kd-','MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,UnpS_suppr(3,:),'ko-','MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,punS_sum(3,:)./punS_sum(2,:),'d-','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,unpS_sum(3,:)./unpS_sum(2,:),'o-','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);

xlabel('Block');
xlim([0.5 n_phases+0.5]);
xticks(1:n_phases);
plot(xlim,[0.5 0.5],'k:');
ylim([0 1]);
ylabel('Ratio');
legend({'ITI preference' 'PunS unshlded suppr' 'UnpS unshlded suppr' ...
  '% PunShieldsTaken' '% UnpShieldsTaken'},'Location','best');
legend('boxoff')

%% Ships & shields
subplot(2,3,3); hold on
title('Ships & shields');

plot(1:n_phases,punS_sum(1,:),'d-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,punS_sum(2,:),'d-','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,punS_sum(3,:),'d:','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,unpS_sum(1,:),'o-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,unpS_sum(2,:),'o-','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,unpS_sum(3,:),'o:','Color',col_rep(1), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);

xlabel('Block');
xticks(1:n_phases);
ylims = ylim;
ylims(1) = 0;
ylim(ylims);
ylabel('N');
legend({'PunShips' 'PunShldAv' 'PunShlded' ...
  'UnpShips' 'UnpShldAv' 'UnpShlded'},'Location','best');
legend('boxoff')

%% Values
subplot(2,3,4); hold on
title('Values');

plot(1:n_phases,values(1,:),'k+-','LineWidth',1.5);
plot(1:n_phases,values(2,:),'-','Color',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,values(3,:),'-','Color',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,values(4,:),'d-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,values(5,:),'o-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,values(6,:),'x-','Color',col_rep(2),'LineWidth',1.5);

xlabel('Block');
xlim([0.5 n_phases+0.5]);
xticks(1:n_phases);
ylim([0 100]);
ylabel('Rating');
legend({'Reward' 'PunPlanet' 'UnpPlanet' ...
  'PunShip' 'UnpShip' 'Attack'},'Location','best');
legend('boxoff')

%% Inferences
subplot(2,3,5); hold on
title('Inferences');
%Planet-Rew,Planet-PunS,Planet-UnpS,Planet-Atk,Ship-Atk
plot(1:n_phases,pun_infs(1,:),'+-','Color',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,pun_infs(2,:),'d-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,pun_infs(3,:),'o-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,pun_infs(4,:),'x--','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.1,pun_infs(5,:),'x-','Color',col_rep(2), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);

plot(1:n_phases,unp_infs(1,:),'+-','Color',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,unp_infs(2,:),'d-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot(1:n_phases,unp_infs(3,:),'o-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(3),'LineWidth',1.5);
plot(1:n_phases,unp_infs(4,:),'x--','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);
plot([1:n_phases]+.1,unp_infs(5,:),'x-','Color',col_rep(3), ...
  'MarkerFaceColor',col_rep(2),'LineWidth',1.5);

xlabel('Block');
xlim([0.5 n_phases+0.5]);
xticks(1:n_phases);
ylim([0 100]);
ylabel('% likelihood');
legend({'  Planet-Rew' ' Planet-PunS' ' Planet-UnpS' '   Planet-Atk' '    Ship-Atk' ...
   ' ' ' ' ' ' ' ' ' '}, 'NumColumns',2,'Location','best');
legend('boxoff');

% %% Pref inferences 
% % R1:R2 prediction/revaluation
% subplot(2,3,6); hold on
% title('R1:R2 prediction/revaluation','interpreter','none');
% plot(1:n_phases,pref_infs(1,:),'k-','LineWidth',1.5);
% plot(1:n_phases,pref_infs(2,:),'Color',col_rep(1),'LineWidth',1.5);
% 
% xlabel('Block');
% xlim([0.5 n_phases+0.5]);
% xticks(1:n_phases);
% ylim([0 100]);
% plot(xlim,[50 50],'k:');
% ylabel('Pref %','interpreter','none');
% legend({'Pref prediction' 'Pref reval'},...
%   'Location','best','interpreter','none');
% legend('boxoff');