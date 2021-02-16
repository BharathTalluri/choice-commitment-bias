function figure5(pupil_allTrials, pupil_choiceTrials, globalgain_params_perceptual, selectivegain_params_perceptual)
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces
% figure 5 of the paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%

% draw pupil timecourses
colors = linspecer(2, 'qualitative');
ylim1 = [-3 1;-1.5 0;-1.2 0];ytick1 = {[-3:1:1];[-1.5:0.5:0];[-1.2:0.4:0]};
subplot(4, 5, 1);
hold on;
for r = 1:2
    boundedline(pupil_allTrials.time, squeeze(nanmean(pupil_allTrials.dat(:, r, :))), squeeze(nanstd(pupil_allTrials.dat(:, r, :))) ./ sqrt(size(pupil_allTrials.dat, 1)), 'cmap', colors(r, :), 'alpha');
    axis tight;
end
set(gca,'ylim',ylim1(1,:),'ytick', ytick1{1}, 'xlim',[0 6],'xtick', 0:1.5:6);
for r = 1:2
    plot([mean(pupil_allTrials.rt(:, r)) + 0.75 mean(pupil_allTrials.rt(:, r)) + 0.75], get(gca, 'ylim'), ':', 'color', colors(r, :), 'linewidth', 0.5);
end
for r = 1:2
    plot([mean(pupil_allTrials.est_rt(:, r)) + 3.5 mean(pupil_allTrials.est_rt(:, r)) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
end
% show events
plot([0 0], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([0.75 0.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([2.75 2.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([3.5 3.5], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
xlabel('Interval 1 onset');
ylabel('Pupil timecourse (z)');
yval = min(get(gca, 'ylim'));
significanttimewin = pupil_allTrials.significanttimewin;
plot(pupil_allTrials.time(significanttimewin), ones(size(significanttimewin)) * yval, 'k.');
offsetAxes;

% zoom in to interval 2
subplot(4, 5, 2);
hold on;
for r = 1:2
    boundedline(pupil_allTrials.time, squeeze(nanmean(pupil_allTrials.dat(:, r, :))), squeeze(nanstd(pupil_allTrials.dat(:, r, :))) ./ sqrt(size(pupil_allTrials.dat, 1)), 'cmap', colors(r, :), 'alpha');
    axis tight;
end
set(gca,'ylim',ylim1(2,:),'ytick', ytick1{2}, 'xlim',[1.75 5.75],'xtick', 1.75:1:5.75, 'xticklabel', -1:1:3);
for r = 1:2
    plot([mean(pupil_allTrials.est_rt(:, r)) + 3.5 mean(pupil_allTrials.est_rt(:, r)) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
end
% show events
plot([2.75 2.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([3.5 3.5], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
xlabel('Interval 2 onset');
yval = min(get(gca, 'ylim'));
plot(pupil_allTrials.time(significanttimewin), ones(size(significanttimewin)) * yval, 'k.');
offsetAxes;


cols = linspecer(9, 'qualitative');
ylim1 = [-3 1;-1.2 0;-1.2 0];ytick1 = {[-3:1:1];[-1.2:0.4:0];[-1.2:0.4:0]};
colors = cols(3:4, :);
subplot(4, 5, 11);
hold on;
for r = 1:2
    boundedline(pupil_choiceTrials.time, squeeze(nanmean(pupil_choiceTrials.dat(:, r, :))), squeeze(nanstd(pupil_choiceTrials.dat(:, r, :))) ./ sqrt(size(pupil_choiceTrials.dat, 1)), 'cmap', colors(r, :), 'alpha');
    axis tight;
end
set(gca,'ylim',ylim1(1,:),'ytick', ytick1{1}, 'xlim',[0 6],'xtick', 0:1.5:6);
for r = 1:2
    plot([mean(pupil_choiceTrials.rt(:, r)) + 0.75 mean(pupil_choiceTrials.rt(:, r)) + 0.75], get(gca, 'ylim'), ':', 'color', colors(r, :), 'linewidth', 0.5);
end
for r = 1:2
    plot([mean(pupil_choiceTrials.est_rt(:, r)) + 3.5 mean(pupil_choiceTrials.est_rt(:, r)) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
end
% show events
plot([0 0], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([0.75 0.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([2.75 2.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([3.5 3.5], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
xlabel('Interval 1 onset');
ylabel('Pupil timecourse (z)');
yval = min(get(gca, 'ylim'));
significanttimewin = pupil_choiceTrials.significanttimewin;
plot(pupil_choiceTrials.time(significanttimewin), ones(size(significanttimewin)) * yval, 'k.');
offsetAxes;

% Zoom in to interval 2
subplot(4, 5, 12);
hold on;
for r = 1:2
    boundedline(pupil_choiceTrials.time, squeeze(nanmean(pupil_choiceTrials.dat(:, r, :))), squeeze(nanstd(pupil_choiceTrials.dat(:, r, :))) ./ sqrt(size(pupil_choiceTrials, 1)), 'cmap', colors(r, :), 'alpha');
    axis tight;
end
set(gca,'ylim',ylim1(2,:),'ytick', ytick1{2}, 'xlim',[1.75 5.75],'xtick', 1.75:1:5.75, 'xticklabel', -1:1:3);
for r = 1:2
    plot([mean(pupil_choiceTrials.est_rt(:, r)) + 3.5 mean(pupil_choiceTrials.est_rt(:, r)) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
end
% show events
plot([2.75 2.75], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
plot([3.5 3.5], get(gca, 'ylim'), 'k--', 'linewidth', 0.25);
xlabel('Interval 2 onset');
yval = min(get(gca, 'ylim'));
plot(pupil_choiceTrials.time(significanttimewin), ones(size(significanttimewin)) * yval, 'k.');
offsetAxes;

% pupil-behavior correlations
cols = linspecer(10, 'qualitative');
colormap(linspecer);
subplot(4,5,4);hold on;
dat1 = pupil_allTrials.subject_pupil_nochoice;
dat2 = globalgain_params_perceptual.choice.actual(:, 3);
% polish the figure
set(gca, 'XLim', [-1.5 0], 'XTick', -1.5:0.5:0,'ylim',[0 0.6], 'ytick', 0:0.2:0.6);
scatter(dat1, dat2, 35, cols, 'filled', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);
axis square;
b = deming(dat1,dat2);
b1 = b(1) + b(2)*[-1.5 0];
plot([-1.5 0], b1, 'Color', [0.25 0.25 0.25], 'LineWidth', 1);
[rho_val(1), p_val] = corr(dat1, dat2, 'type', 'Pearson');
xlabel('Pupil response (z)');
ylabel('Weights to second interval');
offsetAxes;
title({'Choice trials', sprintf('r = %.3f, p = %.4f', rho_val(1), p_val)});

subplot(4,5,5);hold on;
dat1 = pupil_allTrials.subject_pupil_nochoice;
dat2 = globalgain_params_perceptual.nochoice.actual(:, 3);
% polish the figure
set(gca, 'XLim', [-1.5 0], 'XTick', -1.5:0.5:0,'ylim',[0 0.75], 'ytick', 0:0.25:0.75);
scatter(dat1, dat2, 35, cols, 'filled', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);
axis square;
[rho_val(2), p_val] = corr(dat1, dat2, 'type', 'Pearson');
xlabel('Pupil response (z)');
ylabel('Weights to second interval');
offsetAxes;
title({'No-choice trials', sprintf('r = %.3f, p = %.4f', rho_val(2), p_val)});

[ridiff,~,p] = ridiffci(rho_val(1),rho_val(2),length(pupil_allTrials.subject_pupil_nochoice),length(pupil_allTrials.subject_pupil_nochoice),0.05);
fprintf('\n Difference between Choice and No-Choice correlations: diff = %1.3f, p = %1.3f \n', ridiff, p);

subplot(4,4,14);hold on;
dat1 = pupil_choiceTrials.subject_pupil_consistent;
dat2 = selectivegain_params_perceptual.consistent.actual(:, 3);
% polish the figure
set(gca, 'XLim', [-1.2 0], 'XTick', -1.2:0.4:0,'ylim',[0 0.75], 'ytick', 0:0.25:0.75);
scatter(dat1, dat2, 35, cols, 'filled', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);
axis square;
[rho_val(1), p_val] = corr(dat1, dat2, 'type', 'Pearson');
xlabel('Pupil response (z)');
ylabel('Weights to second interval');
title({'Consistent trials', sprintf('r = %.3f, p = %.4f', rho_val(1), p_val(1))});
offsetAxes;

subplot(4,4,15);hold on;
dat1 = pupil_choiceTrials.subject_pupil_inconsistent;
dat2 = selectivegain_params_perceptual.inconsistent.actual(:, 3);
% polish the figure
set(gca, 'XLim', [-1.2 0], 'XTick', -1.2:0.4:0,'ylim',[-0.15 0.45], 'ytick', -0.15:0.15:0.45);
scatter(dat1, dat2, 35, cols, 'filled', 'MarkerEdgeColor', [1 1 1], 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);
[rho_val(2), p_val] = corr(dat1, dat2, 'type', 'Pearson');
axis square;
xlabel('Pupil response (z)');
ylabel('Weights to second interval');
title({'Inconsistent trials', sprintf('r = %.3f, p = %.4f', rho_val(2), p_val(2))});
offsetAxes;


[ridiff,~,p] = ridiffci(rho_val(1),rho_val(2),length(pupil_choiceTrials.subject_pupil_inconsistent),length(pupil_choiceTrials.subject_pupil_inconsistent),0.05);
fprintf('\n Difference between Consistent and Inconsistent correlations: diff = %1.3f, p = %1.3f \n', ridiff, p);

% we report some correlations without showing the plot
dat1 = pupil_allTrials.subject_pupil_choice;
dat2 = selectivegain_params_perceptual.consistent.actual(:, 3) - selectivegain_params_perceptual.inconsistent.actual(:, 3);
[rho_val, p_val] = corr(dat1, dat2, 'type', 'Pearson');
fprintf('\n Correlation between pupil size in Choice trials and Confirmation bias: r = %1.3f, p = %1.3f \n', rho_val, p_val);


end