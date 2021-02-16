function ga = behaviour_Perceptual()
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
behdata = readtable(sprintf('%s/Task_Perceptual.csv', behdatapath));
subjects = unique(behdata.subj)';
outliers = [2,6,12,13];
subjects(outliers) = [];
% specify the color map and figure properties
cols = linspecer(2, 'qualitative');
% initialise some variables
meanevidence = [];
xavg = [-20 -15 -10 -5 0 5 10 15 20];
estimations_choice = NaN(length(subjects), length(xavg));
estimations_nochoice = NaN(length(subjects), length(xavg));
estimations_all = NaN(length(subjects), length(xavg));
for sj = subjects
    datAll             =  behdata(find(behdata.subj == sj),:);
    % we get all behavioural measures for the perceptual task
    % use choice trials and no-choice trials in this paper
    choice_trls = find((datAll.condition == 1 & abs(datAll.binchoice) == 1));
    nochoice_trls = find((datAll.condition == 0 & datAll.binchoice == 0));
    dat_choice = datAll(choice_trls,:);
    dat_nochoice = datAll(nochoice_trls,:);
    dat = datAll([choice_trls; nochoice_trls],:);
    % Estimations
    meanevidence = [meanevidence; dat.xavg];
    estimations_all(find(sj==subjects), :) = splitapply(@nanmedian, dat.estim, findgroups(dat.xavg));
    estimations_choice(find(sj==subjects), :) = splitapply(@nanmedian, dat_choice.estim, findgroups(dat_choice.xavg));
    estimations_nochoice(find(sj==subjects), :) = splitapply(@nanmedian, dat_nochoice.estim, findgroups(dat_nochoice.xavg));
    % Psychometric function, we define the psychometric function below
    % use all choice trials for this
    trls2use = find(abs(datAll.condition) == 1 & abs(datAll.binchoice) == 1);
    dat_allChoice = datAll(trls2use,:);
    [bias, slope] = fitcumnormal((dat_allChoice.x1), dat_allChoice.binchoice>0);
    ga.logisticFit(find(sj==subjects), :)   = [bias, slope];
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
set(gca, 'XLim', [-20 20], 'XTick', -20:20:20, 'ylim',[-20 20], 'ytick', -20:20:20);
ylabel('Estimation (degrees)');
xlabel('Mean Direction across interval 1&2  (degrees)');
axis square;EquateAxis;
offsetAxes;

% Histogram of mean evidence
subplot(4,4,5);hold on;
for i = xavg
    plot([i i], [0 length(find(meanevidence == i))],'k-','LineWidth',5);
end
ylabel ('Trials')
xlabel('Mean Evidence (degrees)');
axis square;
set(gca, 'XLim', [-25 25], 'XTick', -20:20:20,'YLim',[0 4000],'YTick',0:2000:4000);
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