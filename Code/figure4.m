function figure4(globalgain_params_perceptual, globalgain_params_numerical, selectivegain_params_perceptual, selectivegain_params_numerical)
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces
% figure 4 of the paper.

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
subplot(3,3,1);hold on;
dat1 = globalgain_params_perceptual.nochoice.actual(:, 3) - globalgain_params_perceptual.choice.actual(:, 3);
dat2 = globalgain_params_numerical.nochoice.actual(:, 3) - globalgain_params_numerical.choice.actual(:, 3);
dat3 = selectivegain_params_perceptual.consistent.actual(:, 3) - selectivegain_params_perceptual.inconsistent.actual(:, 3);
dat4 = selectivegain_params_numerical.consistent.actual(:, 3) - selectivegain_params_numerical.inconsistent.actual(:, 3);
% get the 66% confidence intervals
dat11 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 3, :) - globalgain_params_perceptual.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat12 = squeeze(prctile(globalgain_params_perceptual.nochoice.bootstrap(:, 3, :) - globalgain_params_perceptual.choice.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat13 = squeeze(prctile(selectivegain_params_perceptual.consistent.bootstrap(:, 3, :) - selectivegain_params_perceptual.inconsistent.bootstrap(:, 3, :), [100/6, 500/6], 3));
dat14 = squeeze(prctile(selectivegain_params_numerical.consistent.bootstrap(:, 3, :) - selectivegain_params_numerical.inconsistent.bootstrap(:, 3, :), [100/6, 500/6], 3));
% polish the figure
set(gca, 'XLim', [-0.3 0.6], 'XTick', -0.3:0.3:0.6,'ylim',[-0.5 1.0], 'ytick', -0.5:0.5:1.0);
axis square;
myscatter(dat3, dat4, [dat13 dat14], mrksize, cols(4, :), cols(4, :), cols(4, :), 1);
myscatter(dat1, dat2, [dat11 dat12], mrksize, cols(2, :), cols(2, :), cols(2, :), 1);
b = deming([dat1;dat3],[dat2;dat4]);
b1 = b(1) + b(2)*[-0.3 0.6];
plot([-0.3 0.6], b1, 'Color', [0.25 0.25 0.25], 'LineWidth', 2);
b = deming(dat1,dat2);
b1 = b(1) + b(2)*[-0.3 0.6];
plot([-0.3 0.6], b1, 'Color', cols(2,:), 'LineWidth', 1);
b = deming(dat3,dat4);
b1 = b(1) + b(2)*[-0.3 0.6];
plot([-0.3 0.6], b1, 'Color', cols(4,:), 'LineWidth', 1);
[rho_perceptual, p_perceptual] = corr(dat1, dat2, 'type', 'Pearson');
[rho_numerical, p_numerical] = corr(dat3, dat4, 'type', 'Pearson');
[rho_combined, p_combined] = pooled_rho(rho_perceptual, rho_numerical, length(subjidx_perceptual), length(subjidx_numerical));
xlabel('W_{2nc} - W_{2c}');
ylabel('W_{2cc} - W_{2ic}');
offsetAxes;
title({'Empirical data', sprintf('Pearsons r = %.3f, p = %.4f', rho_combined, p_combined)});
fprintf('\n Global Vs Selective: Numerical task, r = %.3f, p = %.4f \n', rho_numerical, p_numerical);
fprintf('\n Global Vs Selective: Perceptual task, r = %.3f, p = %.4f \n', rho_perceptual, p_perceptual);
fprintf('\n Global Vs Selective: both task, r = %.3f, p = %.4f \n', rho_combined, p_combined);
end
