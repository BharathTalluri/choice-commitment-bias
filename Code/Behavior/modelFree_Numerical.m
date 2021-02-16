function roc_index = modelFree_Numerical(bootstrap)
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
    dat             =  behdata(find(behdata.subj == sj),:);
    % use only choice and no-choice trials in this paper
    trls2use = find((dat.condition == 1 | dat.condition == 0) & ~isnan(dat.estim));
    dat = dat(trls2use,:);
    % get the roc indices for consistent and inconsistent trials
    roc_index.choice.actual(find(sj==subjects)) = get_roc(dat, 1, bootstrap);
    roc_index.nochoice.actual(find(sj==subjects)) = get_roc(dat, 0, bootstrap);
    if bootstrap
        % bootstrap roc indices to obtain confidence intervals
        for k = 1:500
            roc_index.choice.bootstrap(find(sj==subjects), k) = get_roc(dat, 1, bootstrap);
            roc_index.nochoice.bootstrap(find(sj==subjects), k) = get_roc(dat, 0, bootstrap);
        end
    end
end
end

function roc = get_roc(dat, choice, bootstrap)
% get the roc indices for global gain mechanism
dat.idx = transpose(1:height(dat));

switch choice % split by choice
    case 1
        trls2use    = find(dat.condition == 1);
    case 0
        trls2use    = find(dat.condition == 0);
end
%binarise x1
dat.x1_bin = NaN(size(dat.x1_relative));
dat.x1_bin(find(dat.x1 < 50)) = -1;
dat.x1_bin(find(dat.x1 > 50)) = 1;
dat = dat(trls2use,:);
if bootstrap
    numtrls = size(dat,1);
    dat = datasample(dat,numtrls);
end
estimation = dat.estim;
% loop over different x1/x2 pairs
unique_x1 = unique(dat.x1_bin)';
tmpRoc_all = nan(1,length(unique_x1));
num_trls_all = nan(1,length(unique_x1));
for x1 = unique_x1
    % collect the estimation distributions for different values of x2
    trlsM = estimation(find(dat.x2_relative < 0 & dat.x1_bin == x1));
    trlsP = estimation(find(dat.x2_relative > 0 & dat.x1_bin == x1));
    % calculate the roc index for the two distributions
    tmpRoc     = rocAnalysis(trlsM, trlsP, 0, 1);
    num_trls_x1 = length(trlsP) + length(trlsM);
    tmpRoc_all(find(x1 == unique_x1)) = tmpRoc.i';
    num_trls_all(find(x1 == unique_x1)) = num_trls_x1;
end
% weighted average roc
roc = (tmpRoc_all*num_trls_all')/sum(num_trls_all);
end