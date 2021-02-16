function params = modelBased_Numerical_ChoiceSelectiveGain(psycho_fits, bootstrap)

% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
behdatapath = '../Data/Behavior';
behdata = readtable(sprintf('%s/Task_Numerical.csv', behdatapath));
subjects = unique(behdata.subj)';
outliers = [21];
subjects(outliers) = [];

for sj = subjects
    subj_dat             =  behdata(find(behdata.subj == sj),:);
    % use only choice trials
    % since consistency cannot be defined for trials where x2 = 0, remove those
    % trials
    trls2use = find(subj_dat.condition == 1 & abs(subj_dat.binchoice) == 1 & subj_dat.x2_relative ~= 0);
    subj_dat = subj_dat(trls2use,:);
    psycho_noise = psycho_fits.logisticFit(sj, 2);
    psycho_bias = -psycho_fits.logisticFit(sj, 1);
    
    % consistent trials
    TrlsConsistent = find(sign(subj_dat.binchoice) == sign(subj_dat.x2_relative));
    dat_consistent = subj_dat(TrlsConsistent,:);
    starting_pt = [datasample(1:5:25, 1) datasample(0.05:0.05:1, 1) datasample(0.05:0.05:1, 1) datasample(0:0.25:5,1)];
    params.consistent.actual(find(sj==subjects),:) = fit_model(dat_consistent, psycho_noise, psycho_bias, starting_pt);
    if bootstrap
        for k = 1:500
            % sample trials with replacement
            numtrls = size(dat_consistent,1);
            dat_consistent = datasample(dat_consistent,numtrls);
            params.consistent.bootstrap(find(sj==subjects), :, k) = fit_model(dat_consistent, psycho_noise, psycho_bias, params.consistent.actual(find(sj==subjects),:));
        end
    end
    
    % inconsistent trials
    TrlsInconsistent = find(sign(subj_dat.binchoice) ~= sign(subj_dat.x2_relative));
    dat_inconsistent = subj_dat(TrlsInconsistent,:);
    starting_pt = [datasample(1:5:25, 1) datasample(0.05:0.05:1, 1) datasample(0.05:0.05:1, 1) datasample(0:0.25:5,1)];
    params.inconsistent.actual(find(sj==subjects),:) = fit_model(dat_inconsistent, psycho_noise, psycho_bias, starting_pt);
    if bootstrap
        for k = 1:500
            % sample trials with replacement
            numtrls = size(dat_inconsistent,1);
            dat_inconsistent = datasample(dat_inconsistent,numtrls);
            params.inconsistent.bootstrap(find(sj==subjects), :, k) = fit_model(dat_inconsistent, psycho_noise, psycho_bias, params.inconsistent.actual(find(sj==subjects),:));
        end
    end
end
end

function subj_params = fit_model(subj_dat, psycho_noise, psycho_bias, starting_pt)
% function evaluation params
global dat; global psychofit_params;
options = optimset('Display', 'notify') ;
options.MaxFunEvals = 1e10; % limit the nr of func evals
options.MaxIter = 500000;
options.TolX = 0.00001; % dont make this too small, will take forever to converge
options.TolFun = 0.00001;
options.Robust = 'on';

% define a random starting point for the fitting algorithm
dat = subj_dat;
psychofit_params = [psycho_noise, psycho_bias];
[individualparams, ~]=subplex('model_Numerical_ChoiceSelectiveGain', starting_pt);
% optimise again, just to make sure we are at the minimum
[subj_params, ~] = fminsearchbnd(@(individualparams) model_Numerical_ChoiceSelectiveGain(individualparams),individualparams,[0,-1000,-1000,-1000],[80,1000,1000,1000],options);
end
