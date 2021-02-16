function ga = behaviour_Numerical()
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
close all;
clc; dbstop if error;
behdatapath = '../Data/Behavior';
behdata = readtable(sprintf('%s/Task_Numerical.csv', behdatapath));
subjects = unique(behdata.subj)';
outliers = [21];
subjects(outliers) = [];
% specify the color map and figure properties
cols = linspecer(2, 'qualitative');
% initialise some variables
meanevidence = [];
xavg = [1 2 3 4 5 6 7 8];
estimations_choice = NaN(length(subjects), length(xavg));
estimations_nochoice = NaN(length(subjects), length(xavg));
estimations_all = NaN(length(subjects), length(xavg));
for sj = subjects
    datAll             =  behdata(find(behdata.subj == sj),:);
    datAll.xavg_quantiles = NaN(length(datAll.xavg),1);
    datAll.xavg_quantiles(find(datAll.xavg <= 43)) = 1;
    datAll.xavg_quantiles(find(datAll.xavg > 43 & datAll.xavg <= 45)) = 2;
    datAll.xavg_quantiles(find(datAll.xavg > 45 & datAll.xavg <= 47)) = 3;
    datAll.xavg_quantiles(find(datAll.xavg > 47 & datAll.xavg <= 50)) = 4;
    datAll.xavg_quantiles(find(datAll.xavg > 50 & datAll.xavg <= 53)) = 5;
    datAll.xavg_quantiles(find(datAll.xavg > 53 & datAll.xavg <= 55)) = 6;
    datAll.xavg_quantiles(find(datAll.xavg > 55 & datAll.xavg <= 57)) = 7;
    datAll.xavg_quantiles(find(datAll.xavg > 57 & datAll.xavg <= 60)) = 8;
    % use choice trials and no-choice trials in this paper
    choice_trls = find(datAll.condition == 1 & ~isnan(datAll.estim));
    nochoice_trls = find(datAll.condition == 0 & ~isnan(datAll.estim));
    dat_choice = datAll(choice_trls,:);
    dat_nochoice = datAll(nochoice_trls,:);
    dat = datAll([choice_trls; nochoice_trls],:);
    % Estimations
    meanevidence = [meanevidence; dat.xavg_quantiles];
    estimations_all(find(sj==subjects), :) = splitapply(@nanmedian, dat.estim, findgroups(dat.xavg_quantiles));
    estimations_choice(find(sj==subjects), :) = splitapply(@nanmedian, dat_choice.estim, findgroups(dat_choice.xavg_quantiles));
    estimations_nochoice(find(sj==subjects), :) = splitapply(@nanmedian, dat_nochoice.estim, findgroups(dat_nochoice.xavg_quantiles));
    % Psychometric function, we define the psychometric function below
    % use all choice trials for this
    trls2use      = find(abs(dat.condition) == 1);
    dat_allChoice = datAll(trls2use,:);
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < 0 & dat_allChoice.x1_relative >= -2) = -1;
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < -2 & dat_allChoice.x1_relative >= -4) = -2;
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < -4 & dat_allChoice.x1_relative >= -6) = -3;
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < 2 & dat_allChoice.x1_relative >= 0) = 1;
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < 4 & dat_allChoice.x1_relative >= 2) = 2;
    dat_allChoice.x1_relative(dat_allChoice.x1_relative < 6 & dat_allChoice.x1_relative >= 3) = 3;
    % PSYCHOMETRIC FUNCTIONS
    [bias, slope] = fitcumnormal((dat_allChoice.x1_relative), dat_allChoice.binchoice>0);
    ga.logisticFit(find(sj==subjects),:) = [bias, slope];
end
%% SHOW THE DATA
figure;
subjectidx = 1:length(subjects);
% Estimations as a function of mean evidence
subplot(4,4,1); hold on;
plot(xavg,mean(estimations_all(subjectidx,:),1),'-','Color',[0 0 0],'LineWidth',2);
plot(xavg,mean(estimations_all(subjectidx,:),1),'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[1 1 1],'MarkerSize',5);
errbar(xavg,mean(estimations_all(subjectidx,:),1),std(estimations_all(subjectidx,:),1)/sqrt(length(subjects)),std(estimations_all(subjectidx,:),1)/sqrt(length(subjects)),'-','Color',[0 0 0],'LineWidth',1);
plot(xavg,mean(estimations_choice(subjectidx,:),1),'-','Color',cols(1,:),'LineWidth',2);
plot(xavg,mean(estimations_choice(subjectidx,:),1),'o','MarkerFaceColor',cols(1,:),'MarkerEdgeColor',[1 1 1],'MarkerSize',5);
errbar(xavg,mean(estimations_choice(subjectidx,:),1),std(estimations_choice(subjectidx,:),1)/sqrt(length(subjects)),std(estimations_choice(subjectidx,:),1)/sqrt(length(subjects)),'-','Color',cols(1,:),'LineWidth',1);
plot(xavg,mean(estimations_nochoice(subjectidx,:),1),'-','Color',cols(2,:),'LineWidth',2);
plot(xavg,mean(estimations_nochoice(subjectidx,:),1),'o','MarkerFaceColor',cols(2,:),'MarkerEdgeColor',[1 1 1],'MarkerSize',5);
errbar(xavg,mean(estimations_nochoice(subjectidx,:),1),std(estimations_nochoice(subjectidx,:),1)/sqrt(length(subjects)),std(estimations_nochoice(subjectidx,:),1)/sqrt(length(subjects)),'-','Color',cols(2,:),'LineWidth',1);
set(gca, 'XLim', [1 8], 'XTick', 1:8, 'XTickLabel', {'<= 43', '43-45', '45-47', '47-50', '50-53', '53-55', '55-57', '> 57'}, 'xticklabelrotation', -45, 'ylim',[40 60], 'ytick', 40:10:60);
ylabel('Estimation');
xlabel('Mean evidence across interval 1&2');
axis square;
offsetAxes;

% Histogram of mean evidence
subplot(4,4,5);hold on;
for i = xavg
    plot([i i], [0 length(find(meanevidence == i))],'k-','LineWidth',5);
end
ylabel ('Trials')
xlabel('Mean evidence');
axis square;
set(gca, 'XLim', [1 8], 'XTick', 1:8, 'XTickLabel', {'<= 43', '43-45', '45-47', '47-50', '50-53', '53-55', '55-57', '> 57'}, 'xticklabelrotation', -45, 'YLim',[0 750],'YTick',0:250:750);
offsetAxes;
end

%% Functions used above
function [bias, slope] = fitcumnormal(x,y)
% find the best fitting parameters for the psychometric function by
% maximising the loglikelihood across 10 random starting points for bias
% and slope parameters
niter = 10;
bias_start = datasample(-20:2:20,niter);
slope_start = datasample(0:5:50,niter);
iter_params = NaN(niter,2);
NegLLiter = NaN(niter,1);
for i = 1:niter
    iter_params(i,:) = fminsearchbnd(@(p) cumnormal_LL(p, ...
        x, y), [bias_start(i) slope_start(i)], [-100 0], [100 100],optimset('MaxFunEvals',1000000,'MaxIter',100000));
    NegLLiter(i) = cumnormal_LL(iter_params(i,:),x,y);
end
[~,idx] = min(NegLLiter);
bias        = iter_params(idx,1);
slope       = iter_params(idx,2);
end

function NegLL = cumnormal_LL(p, inputs, responses)
% see http://courses.washington.edu/matlab1/Lesson_5.html#1
% compute the vector of responses for each level of intensity
w   = cumnormal(p, inputs);
% negative loglikelihood, to be minimised
NegLL = -sum(responses.*log(w) + (1-responses).*log(1-w));
end


function y = cumnormal(p, x)
% Parameters: p(1) bias
%             p(2) slope
%             x   inputs.
y = normcdf(x,p(1),p(2));
end