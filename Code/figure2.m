function figure2(roc_index_perceptual, roc_index_numerical, globalgain_params_perceptual, globalgain_params_numerical)

% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces
% figure 2 of the paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%

mrksize = 40;
figure;
% Perceptual task
% specify the color map
cols = linspecer(10, 'qualitative');
colormap(linspecer);
subplot(2,2,1);hold on;
dat1 = globalgain_params_perceptual.choice.actual(:, 3);
dat2 = globalgain_params_perceptual.nochoice.actual(:, 3);
% get the 66% bootstrapped confidence intervals
dat11 = squeeze(prctile(globalgain_params_perceptual.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat22 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 3, :), [100/6, 500/6], 3));
% polish the figure
set(gca, 'XLim', [0 0.75], 'XTick', 0:0.25:0.75,'ylim',[0 0.75], 'ytick', 0:0.25:0.75);
axis square;
EquateAxis;
myscatter(dat1, dat2, [dat11 dat22], mrksize, cols, cols, cols, 1);
% plot the group mean +/- s.e.m
plot([nanmean(dat1)-nansem(dat1) nanmean(dat1)+nansem(dat1)], [nanmean(dat2) nanmean(dat2)], 'Color', [0,0,0],'LineWidth',1.5);
plot([nanmean(dat1) nanmean(dat1)], [nanmean(dat2)-nansem(dat2) nanmean(dat2)+nansem(dat2)], 'Color', [0,0,0],'LineWidth',1.5);
% along the difference axis
diff_sem = nansem(dat1 - dat2)/sqrt(2);
plot([nanmean(dat1)-diff_sem nanmean(dat1)+diff_sem], [nanmean(dat2)+diff_sem nanmean(dat2)-diff_sem], 'Color', [0,0,0],'LineWidth',2.5);
[pval] = permtest(dat1, dat2, 0, 100000); % permutation test
xlabel('Choice trials');
ylabel('No-Choice trials');
offsetAxes;
title({'Weights to second interval', sprintf('Choice vs. No-Choice: p = %.4f', pval)});

subplot(2,2,2);hold on;
dat1 = roc_index_perceptual.choice.actual;
dat2 = roc_index_perceptual.nochoice.actual;
% get the 66% bootstrapped confidence intervals
dat11 = prctile(roc_index_perceptual.choice.bootstrap, [100/6, 500/6], 2);
dat22 = prctile(roc_index_perceptual.nochoice.bootstrap, [100/6, 500/6], 2);
% polish the figure
set(gca, 'XLim', [0.5 0.7], 'XTick', 0.5:0.1:0.7,'ylim',[0.5 0.7], 'ytick', 0.5:0.1:0.7);
axis square;
EquateAxis;
myscatter(dat1, dat2, [dat11 dat22], mrksize, cols, cols, cols, 1);
% plot the group mean +/- s.e.m
plot([nanmean(dat1)-nansem(dat1) nanmean(dat1)+nansem(dat1)], [nanmean(dat2) nanmean(dat2)], 'Color', [0 0 0],'LineWidth',1.5);
plot([nanmean(dat1) nanmean(dat1)], [nanmean(dat2)-nansem(dat2) nanmean(dat2)+nansem(dat2)], 'Color', [0 0 0],'LineWidth',1.5);
% along the difference axis
diff_sem = nansem(dat1 - dat2)/sqrt(2);
plot([nanmean(dat1)-diff_sem nanmean(dat1)+diff_sem], [nanmean(dat2)+diff_sem nanmean(dat2)-diff_sem], 'Color', [0,0,0],'LineWidth',2.5);
[pval] = permtest(dat1, dat2, 0, 100000); % permutation test
xlabel('Choice trials');
ylabel('No-Choice trials');
offsetAxes;
title({'Sensitivity (model-free) to second interval', sprintf('Choice vs. No-Choice: p = %.4f', pval)});

% Numerical task
% specify the color map
cols = distinguishable_colors(25,'w');
cols = cols(6:end,:);
subplot(2,2,3);hold on;
dat1 = globalgain_params_numerical.choice.actual(:, 3);
dat2 = globalgain_params_numerical.nochoice.actual(:, 3);
% get the 66% bootstrapped confidence intervals
dat11 = squeeze(prctile(globalgain_params_numerical.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat22 = squeeze(prctile(globalgain_params_numerical.nochoice.bootstrap(:, 3, :), [100/6, 500/6], 3));
% polish the figure
set(gca, 'XLim', [0 0.9], 'XTick', 0:0.3:0.9,'ylim',[0 0.9], 'ytick', 0:0.3:0.9);
axis square;
EquateAxis;
myscatter(dat1, dat2, [dat11 dat22], mrksize, cols, cols, cols, 0.75);
% plot the group mean +/- s.e.m
plot([nanmean(dat1)-nansem(dat1) nanmean(dat1)+nansem(dat1)], [nanmean(dat2) nanmean(dat2)], 'Color', [0,0,0],'LineWidth',1.5);
plot([nanmean(dat1) nanmean(dat1)], [nanmean(dat2)-nansem(dat2) nanmean(dat2)+nansem(dat2)], 'Color', [0,0,0],'LineWidth',1.5);
% along the difference axis
diff_sem = nansem(dat1 - dat2)/sqrt(2);
plot([nanmean(dat1)-diff_sem nanmean(dat1)+diff_sem], [nanmean(dat2)+diff_sem nanmean(dat2)-diff_sem], 'Color', [0,0,0],'LineWidth',2.5);
[pval] = permtest(dat1, dat2, 0, 100000); % permutation test
xlabel('Choice trials');
ylabel('No-Choice trials');
offsetAxes;
title({'Weights to second interval', sprintf('Choice vs. No-Choice: p = %.4f', pval)});

subplot(2,2,4);hold on;
dat1 = roc_index_numerical.choice.actual;
dat2 = roc_index_numerical.nochoice.actual;
% get the 66% bootstrapped confidence intervals
dat11 = prctile(roc_index_numerical.choice.bootstrap, [100/6, 500/6], 2);
dat22 = prctile(roc_index_numerical.nochoice.bootstrap, [100/6, 500/6], 2);
% polish the figure
set(gca, 'XLim', [0.55 0.95], 'XTick', 0.55:0.2:0.95,'ylim',[0.55 0.95], 'ytick', 0.55:0.2:0.95);
axis square;
EquateAxis;
myscatter(dat1, dat2, [dat11 dat22], mrksize, cols, cols, cols, 0.75);
% plot the group mean +/- s.e.m
plot([nanmean(dat1)-nansem(dat1) nanmean(dat1)+nansem(dat1)], [nanmean(dat2) nanmean(dat2)], 'Color', [0 0 0],'LineWidth',1.5);
plot([nanmean(dat1) nanmean(dat1)], [nanmean(dat2)-nansem(dat2) nanmean(dat2)+nansem(dat2)], 'Color', [0 0 0],'LineWidth',1.5);
% along the difference axis
diff_sem = nansem(dat1 - dat2)/sqrt(2);
plot([nanmean(dat1)-diff_sem nanmean(dat1)+diff_sem], [nanmean(dat2)+diff_sem nanmean(dat2)-diff_sem], 'Color', [0,0,0],'LineWidth',2.5);
[pval] = permtest(dat1, dat2, 0, 100000); % permutation test
xlabel('Choice trials');
ylabel('No-Choice trials');
offsetAxes;
title({'Sensitivity (model-free) to second interval', sprintf('Choice vs. No-Choice: p = %.4f', pval)});
end