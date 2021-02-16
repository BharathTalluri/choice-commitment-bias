function [significanttimewin] = stats_choiceVnochoice(time, dat1, dat2)
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% do statistics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subjects = 1:size(dat1, 1);

% put into fieldtrip-style
grandavg_choice1.time       = time;
grandavg_choice1.label      = {'EyePupil'}; % channel name
grandavg_choice1.dimord     = 'subj_chan_time';
grandavg_choice1.individual = dat1;

grandavg_choice0.time       = time;
grandavg_choice0.label      = {'EyePupil'};
grandavg_choice0.dimord     = 'subj_chan_time';
grandavg_choice0.individual = dat2;

% do cluster stats across the group
cfgstats                  = [];
cfgstats.method           = 'montecarlo'; % permutation test
cfgstats.statistic        = 'ft_statfun_depsamplesT';
cfgstats.spmversion = 'spm12';
% do cluster correction
cfgstats.correctm         = 'cluster';
cfgstats.clusteralpha     = 0.05;
cfgstats.clusterstatistic = 'maxsize'; % weighted cluster mass needs cfg.wcm_weight...
%cfgstats.minnbchan        = 1; % average over chans
cfgstats.tail             = 0;
cfgstats.clustertail      = 0;
cfgstats.alpha            = 0.025;
cfgstats.numrandomization = 1000;

% use only our preselected sensors for the time being
cfgstats.channel          = 'EyePupil';

% specifies with which sensors other sensors can form clusters
cfgstats.neighbours       = []; % only cluster over data and time

subj = length(subjects);
design = zeros(2,2*subj);
for i = 1:subj,  design(1,i) = i;       end
for i = 1:subj,  design(1,subj+i) = i;  end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfgstats.design   = design;
cfgstats.uvar     = 1;
cfgstats.ivar     = 2;

stat      = ft_timelockstatistics(cfgstats, grandavg_choice1, grandavg_choice0);

significanttimewin = find(stat.mask==1);
disp(significanttimewin);

end
