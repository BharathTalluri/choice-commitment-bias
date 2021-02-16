function figureS1()
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces
% figure S1 of the paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
figure;
behdatapath = '../Data/Behavior';
behdata = readtable(sprintf('%s/Task_Perceptual.csv', behdatapath));
subjects = unique(behdata.subj)';
outliers = [2,6,12,13];
subjects(outliers) = [];
ga_permutation_histogram = nan(numel(unique(subjects)), 5, 5);
for types = 1:2
    for sj = subjects
        dat = behdata(find(behdata.subj == sj),:);
        % define the type of trials
        switch types
            case 1
                trls2use = find(dat.condition ~= -1);
            case 2
                trls2use = find(dat.condition == 0 & abs(dat.binchoice) == 0 & ~isnan(dat.estim));
            case 3
                trls2use = find(dat.condition == 1 & abs(dat.binchoice) == 1 & ~isnan(dat.estim));
        end
        dat = dat(trls2use,:);
        permutationHistogram = nan(5,5);
        dirs = -20:10:20;
        for d = 1:length(dirs)
            x1trls = find(dat.x1 == dirs(d));
            for d2 = 1:length(dirs)
                permutationHistogram(d, d2) = length(find(dat.x2(x1trls) == dirs(d2)));
            end
        end
        ga_permutation_histogram(find(sj == subjects), :, :) = permutationHistogram;
    end
    
    %% PLOT THE HISTOGRAM SHOWING THE AVERAGE TRIAL COUNTS
    subplot(4,4,types);
    
    avg_permutation_histogram = squeeze(round(nanmean(ga_permutation_histogram)));
    colormap viridis;
    switch types
        case 1
            imagesc(dirs, dirs, avg_permutation_histogram, [75 85]);
        case 2
            imagesc(dirs, dirs, avg_permutation_histogram, [35 45]);
        case 3
            imagesc(dirs, dirs, avg_permutation_histogram, [35 45]);
    end
    
    axis square;
    set(gca, 'ydir', 'normal');
    switch types
        case 1
            title('Mean trial count');
        case 2
            title('Choice trials');
        case 3
            title('No-Choice trials');
    end
    set(gca, 'xtick', -20:10:20, 'ytick', -20:10:20);
    hold on;
    
    plotGrid = -25:10:25;
    % show grid lines
    for k = plotGrid
        % horizontal lines
        x = [plotGrid(1) plotGrid(end)];
        y = [k k];
        plot(x,y,'Color','w','LineStyle','-');
        % vertical lines
        x = [k k];
        y = [plotGrid(1) plotGrid(end)];
        plot(x,y,'Color','w','LineStyle','-');
    end
    % coordinates
    [xlbl, ylbl] = meshgrid(dirs, dirs);
    lbl = strtrim(cellstr(num2str((avg_permutation_histogram(:)')')));
    text(xlbl(:), ylbl(:), lbl(:),'color', 'w',...
        'HorizontalAlignment','center','VerticalAlignment','middle', 'fontsize', 7);
    
    % labels
    xlabel(sprintf('Interval 2 direction (%c)', char(176)));
    ylabel(sprintf('Interval 1 direction (%c)', char(176)));
end