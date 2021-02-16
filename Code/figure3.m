function figure3(globalgain_params_perceptual, globalgain_params_numerical)

% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces
% figure 3 of the paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%

mrksize = 40;
% specify the color map and figure properties
cols = linspecer(9, 'qualitative');
colormap(linspecer);
figure;
% assign weights to the relevant variables
dat11 = globalgain_params_perceptual.choice.actual(:, 2);
dat12 = globalgain_params_perceptual.choice.actual(:, 3);
dat13 = globalgain_params_perceptual.nochoice.actual(:, 2);
dat14 = globalgain_params_perceptual.nochoice.actual(:, 3);

% compute the interaction for Perceptual task using ANOVA
anova.x = [];
anova.sj = [];
anova.f1 = [];
anova.f2 = [];
for sj = 1:10
    anova.x     = [anova.x; [dat11(sj) dat12(sj)]'; [dat13(sj) dat14(sj)]'];
    anova.sj    = [anova.sj; sj * ones(4, 1)];
    anova.f1    = [anova.f1; [1 2 1 2]'];
    anova.f2    = [anova.f2; [1 1 2 2]'];
end
anov_perceptual = rm_anova(anova.x, anova.sj, {anova.f1; anova.f2});
subplot(3,3,1);hold on;
plot([1 2], nanmean([dat11 dat12], 1), 'O-', 'Color', cols(2,:), 'MarkerSize', 7.5, 'LineWidth', 1.5, 'MarkerFaceColor', cols(2,:), 'MarkerEdgeColor', [1,1,1]);
errbar([1 2], nanmean([dat11 dat12], 1), nanstd([dat11 dat12], 1) ./ sqrt(length(dat11)), '-','Color', cols(2,:), 'LineWidth',1);
plot([1 2], nanmean([dat13 dat14], 1), 'O-', 'Color', cols(1,:), 'MarkerSize', 7.5, 'LineWidth', 1.5, 'MarkerFaceColor', cols(1,:), 'MarkerEdgeColor', [1,1,1]);
errbar([1 2], nanmean([dat13 dat14], 1), nanstd([dat13 dat14], 1) ./ sqrt(length(dat13)), '-','Color', cols(1,:), 'LineWidth',1);
set(gca, 'XLim', [0.5 2.2], 'XTick', 1:2, 'XTickLabel', {'Interval 1', 'Interval 2'},  'ylim',[0.2 0.5], 'ytick', 0.2:0.1:0.5);
ylabel('Weights');
axis square;offsetAxes;
[pval] = permtest(dat11, dat13, 0, 100000);
mysigstar(0.8, mean([mean(dat11), mean(dat13)]), pval, 0);
[pval] = permtest(dat12, dat14, 0, 100000);
mysigstar(2.2, mean([mean(dat12), mean(dat14)]), pval, 0);
title({'Perceptual Task', sprintf('F_{(%d,%d)} = %.2f, p = %.3f', anov_perceptual.f1xf2.df, anov_perceptual.f1xf2.fstats, anov_perceptual.f1xf2.pvalue)});

% assign weights to the relevant variables
dat21 = globalgain_params_numerical.choice.actual(:, 2);
dat22 = globalgain_params_numerical.choice.actual(:, 3);
dat23 = globalgain_params_numerical.nochoice.actual(:, 2);
dat24 = globalgain_params_numerical.nochoice.actual(:, 3);
% compute the interaction for Perceptual task using ANOVA
anova.x = [];
anova.sj = [];
anova.f1 = [];
anova.f2 = [];
for sj = 1:length(subjidx_numerical)
    anova.x     = [anova.x; [dat21(sj) dat22(sj)]'; [dat23(sj) dat24(sj)]'];
    anova.sj    = [anova.sj; sj * ones(4, 1)];
    anova.f1    = [anova.f1; [1 2 1 2]'];
    anova.f2    = [anova.f2; [1 1 2 2]'];
end
anov_numerical = rm_anova(anova.x, anova.sj, {anova.f1; anova.f2});
subplot(3,3,2);hold on;
plot([1 2], nanmean([dat21 dat22], 1), 'O-', 'Color', cols(2,:), 'MarkerSize', 7.5, 'LineWidth', 1.5, 'MarkerFaceColor', cols(2,:), 'MarkerEdgeColor', [1,1,1]);
errbar([1 2], nanmean([dat21 dat22], 1), nanstd([dat21 dat22], 1) ./ sqrt(length(dat21)), '-','Color', cols(2,:), 'LineWidth',1);
plot([1 2], nanmean([dat23 dat24], 1), 'O-', 'Color', cols(1,:), 'MarkerSize', 7.5, 'LineWidth', 1.5, 'MarkerFaceColor', cols(1,:), 'MarkerEdgeColor', [1,1,1]);
errbar([1 2], nanmean([dat23 dat24], 1), nanstd([dat23 dat24], 1) ./ sqrt(length(dat23)), '-','Color', cols(1,:), 'LineWidth',1);
set(gca, 'XLim', [0.5 2.2], 'XTick', 1:2, 'XTickLabel', {'Interval 1', 'Interval 2'},  'ylim',[0.2 0.5], 'ytick', 0.2:0.1:0.5);
ylabel('Weights');
xlabel('Interval');
axis square;offsetAxes;
[pval] = permtest(dat21, dat23, 0, 100000);
mysigstar(0.8, mean([mean(dat21), mean(dat23)]), pval, 0);
[pval] = permtest(dat22, dat24, 0, 100000);
mysigstar(0.8, mean([mean(dat22), mean(dat24)]), pval, 0);
title({'Numerical Task', sprintf('F_{(%d,%d)} = %.2f, p = %.3f', anov_numerical.f1xf2.df, anov_numerical.f1xf2.fstats, anov_numerical.f1xf2.pvalue)});

subplot(3,3,3);hold on;
set(gca, 'XLim', [0.5 2.5], 'XTick', 1:2, 'XTickLabel', {'Perceptual', 'Numerical'},  'ylim', [-0.8 0.8], 'ytick', -0.8:0.4:0.8);
plot([0.5 2.5], [0 0], 'k', 'LineWidth', 0.25);
plot([0.6, 1.6], [mean(dat14)-mean(dat13), mean(dat24)-mean(dat23)], 'O', 'MarkerFaceColor', cols(1,:),'MarkerEdgeColor', [1 1 1]);
plot([1.4, 2.4], [mean(dat12)-mean(dat11), mean(dat22)-mean(dat21)], 'O', 'MarkerFaceColor', cols(2,:),'MarkerEdgeColor', [1 1 1]);
for i = 1:length(dat21)
    plot([1.75, 2.25], [dat24(i)-dat23(i) dat22(i)-dat21(i)], '-', 'LineWidth', 0.25, 'Color', [0.8 0.8 0.8]);
end
for i = 1:length(dat11)
    plot([0.75, 1.25], [dat14(i)-dat13(i) dat12(i)-dat11(i)], '-', 'LineWidth', 0.25, 'Color', [0.8 0.8 0.8]);
end
ylabel({'Difference of weights:', 'Interval 2 - Interval 1'});
axis square;offsetAxes;
[pval] = permtest(dat14-dat13, dat12-dat11, 0, 100000);
mysigstar([0.75, 1.25], 0.75, pval, 0);
[pval] = permtest(dat24-dat23, dat22-dat21, 0, 100000);
mysigstar([1.75, 2.25], 0.75, pval, 0);
title({'Direction of', 'Temporal Weighting'});

subplot(2,2,3);hold on;
dat1 = globalgain_params_perceptual.choice.actual(:, 3) + globalgain_params_perceptual.choice.actual(:, 2);
dat2 = globalgain_params_perceptual.nochoice.actual(:, 3) + globalgain_params_perceptual.nochoice.actual(:, 2);
dat3 = globalgain_params_numerical.choice.actual(:, 3) + globalgain_params_numerical.choice.actual(:, 2);
dat4 = globalgain_params_numerical.nochoice.actual(:, 3) + globalgain_params_numerical.nochoice.actual(:, 2);
% get the 66% confidence intervals
dat11 = squeeze(prctile(globalgain_params_perceptual.choice.bootstrap(:, 3, :) + globalgain_params_perceptual.choice.bootstrap(:, 2, :), [100/6, 500/6], 3));
dat12 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 3, :) + globalgain_params_perceptual.nochoice.bootstrap(:, 2, :), [100/6, 500/6], 3));
dat13 = squeeze(prctile(globalgain_params_numerical.choice.bootstrap(:, 3, :) + globalgain_params_numerical.choice.bootstrap(:, 2, :), [100/6, 500/6], 3));
dat14 = squeeze(prctile(globalgain_params_numerical.nochoice.bootstrap(:, 3, :) + globalgain_params_numerical.nochoice.bootstrap(:, 2, :), [100/6, 500/6], 3));
% polish the figure
set(gca, 'XLim', [0 1.6], 'XTick', 0:0.4:1.6,'ylim',[0 1.6], 'ytick', 0:0.4:1.6);
axis square;
EquateAxis;
myscatter(dat3, dat4, [dat13 dat14], mrksize, cols(4, :), cols(4, :), cols(4, :), 1);
myscatter(dat1, dat2, [dat11 dat12], mrksize, cols(2, :), cols(2, :), cols(2, :), 1);
b = deming([dat1;dat3],[dat2;dat4]);
b1 = b(1) + b(2)*[0 1.6];
plot([0 1.6], b1, 'Color', [0.25 0.25 0.25], 'LineWidth', 2);
b = deming(dat1,dat2);
b1 = b(1) + b(2)*[0 1.6];
plot([0 1.6], b1, 'Color', cols(2,:), 'LineWidth', 1);
b = deming(dat3,dat4);
b1 = b(1) + b(2)*[0 1.6];
plot([0 1.6], b1, 'Color', cols(4,:), 'LineWidth', 1);
[rho_perceptual, p_perceptual] = corr(dat1, dat2, 'type', 'Pearson');
[rho_numerical, p_numerical] = corr(dat3, dat4, 'type', 'Pearson');
[rho_combined, p_combined] = pooled_rho(rho_perceptual, rho_numerical, length(dat1), length(dat3));
xlabel('W_{1c} + W_{2c}');
ylabel('W_{1nc} + W_{2nc}');
offsetAxes;
title(sprintf('r = %.3f, p = %.4f', rho_combined, p_combined));
fprintf('\n Sum of weights, Interval 1 + Interval 2: Numerical task, r = %.3f, p = %.4f \n', rho_numerical, p_numerical);
fprintf('\n Sum of weights, Interval 1 + Interval 2: Perceptual task, r = %.3f, p = %.4f \n', rho_perceptual, p_perceptual);
fprintf('\n Sum of weights, Interval 1 + Interval 2: both task, r = %.3f, p = %.4f \n', rho_combined, p_combined);

subplot(2,2,4);hold on;
dat1 = globalgain_params_perceptual.nochoice.actual(:, 2) - globalgain_params_perceptual.choice.actual(:, 2);
dat2 = globalgain_params_perceptual.nochoice.actual(:, 3) - globalgain_params_perceptual.choice.actual(:, 3);
dat3 = globalgain_params_numerical.nochoice.actual(:, 2) - globalgain_params_numerical.choice.actual(:, 2);
dat4 = globalgain_params_numerical.nochoice.actual(:, 3) - globalgain_params_numerical.choice.actual(:, 3);
% get the 66% confidence intervals
dat11 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 2, :) - globalgain_params_perceptual.choice.bootstrap(:, 2, :), [100/6, 500/6], 3));
dat12 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 3, :) - globalgain_params_perceptual.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat13 = squeeze(prctile(globalgain_params_numerical.nochoice.bootstrap(:, 2, :) - globalgain_params_numerical.choice.bootstrap(:, 2, :), [100/6, 500/6], 3));
dat14 = squeeze(prctile(globalgain_params_numerical.nochoice.bootstrap(:, 3, :) - globalgain_params_numerical.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
% polish the figure
set(gca, 'XLim', [-0.9 0.45], 'XTick', -0.9:0.45:0.45,'ylim',[-0.3 0.6], 'ytick', -0.3:0.3:0.6);
axis square;
plot([0 0], [-0.3 0.6], 'k', 'LineWidth', 0.25);
plot([-0.9 0.45], [0 0], 'k', 'LineWidth', 0.25);
myscatter(dat3, dat4, [dat13 dat14], mrksize, cols(4, :), cols(4, :), cols(4, :), 1);
myscatter(dat1, dat2, [dat11 dat12], mrksize, cols(2, :), cols(2, :), cols(2, :), 1);
b = deming([dat1;dat3],[dat2;dat4]);
b1 = b(1) + b(2)*[-0.9 0.45];
plot([-0.9 0.45], b1, 'Color', [0.25 0.25 0.25], 'LineWidth', 2);
b = deming(dat1,dat2);
b1 = b(1) + b(2)*[-0.9 0.45];
plot([-0.9 0.45], b1, 'Color', cols(2,:), 'LineWidth', 1);
b = deming(dat3,dat4);
b1 = b(1) + b(2)*[-0.9 0.45];
plot([-0.9 0.45], b1, 'Color', cols(4,:), 'LineWidth', 1);
[rho_perceptual, p_perceptual] = corr(dat1, dat2, 'type', 'Pearson');
[rho_numerical, p_numerical] = corr(dat3, dat4, 'type', 'Pearson');
[rho_combined, p_combined] = pooled_rho(rho_perceptual, rho_numerical, length(dat1), length(dat3));
xlabel('W_{1nc} - W_{1c}');
ylabel('W_{2nc} - W_{2c}');
offsetAxes;
title(sprintf('r = %.3f, p = %.4f', rho_combined, p_combined));
fprintf('\n Difference of weights, No-Choice - Choice: Numerical task, r = %.3f, p = %.4f \n', rho_numerical, p_numerical);
fprintf('\n Difference of weights, No-Choice - Choice: Perceptual task, r = %.3f, p = %.4f \n', rho_perceptual, p_perceptual);
fprintf('\n Difference of weights, No-Choice - Choice: both task, r = %.3f, p = %.4f \n', rho_combined, p_combined);
end