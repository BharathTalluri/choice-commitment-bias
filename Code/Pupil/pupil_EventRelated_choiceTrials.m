function grandavg = pupil_EventRelated_choiceTrials(subjects, channel, plot_ind, savefile)
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
ft_defaults; % for redefinetrial
warning off;
pupil_data_dir = '../../Data/Pupil';
pupil_timecourse_dir = '../../Data/Pupil_timecourse';
behav_data_dir = '../../Data/Behavior';
cnt = 1;
if plot_ind
    figure;
end
% data for all subjects
task_data = readtable(sprintf('%s/Task_Perceptual.csv', behav_data_dir));
all_sj = [0 1 2 3 4 5 7 8 9 11 12 13 14 15];
for sj = subjects
    load(sprintf('%s/P%02d_alleye.mat', pupil_data_dir, sj));
    % add a column to trialinfo with the timestamp for onset of next trial
    start_time_trials = data.trialinfo(:, 7);
    start_time_next_trials = circshift(start_time_trials,-1);
    start_time_next_trials(end) = data.trialinfo(end,18) +  5 * data.fsample;
    data.trialinfo(:, end + 1) = start_time_next_trials;
    % first epoch the trials! ignore warning message about blinksmp
    cfg         = [];
    cfg.spmversion = 'spm12';
    cfg.trl     = data.trialinfo;
    data        = ft_redefinetrial(cfg, data);
    
    % remove some weird trials, invalid, no-estimation trials, and trials that were not analysed in the behavioral data
    subject_taskdata = task_data(task_data.subj == find(sj == all_sj), :);
    sessions = unique(subject_taskdata.session)';
    trls2use = [];
    for sess = sessions
        sess_taskdata = subject_taskdata(subject_taskdata.session == sess, :);
        for block = unique(sess_taskdata.block)'
            block_taskdata = sess_taskdata(sess_taskdata.block == block, :);
            trls = unique(block_taskdata.trial);
            trlindices = find(ismember(data.trialinfo(:,16), trls) & data.trialinfo(:, 17) == block & data.trialinfo(:, 18) == sess & ~isnan(data.trialinfo(:, 13)) & data.trialinfo(:, 5) == 1);
            trls2use = [trls2use; trlindices];
            clear block_taskdata trlindices
        end
        clear sess_taskdata
    end
    cfg         = [];
    cfg.spmversion = 'spm12';
    cfg.trials  = trls2use;
    data        = ft_selectdata(cfg, data);
    
    cfg                 = [];
    cfg.spmversion = 'spm12';
    cfg.channel         = channel;
    % consistent = green, inconsistent = orange;
    cfg.trials(1).name  = 'consistent';
    cfg.trials(1).idx   = find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) == sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0) & ~isnan(data.trialinfo(:, 14)));
    cfg.trials(2).name  = 'inconsistent';
    cfg.trials(2).idx   = find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) ~= sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0) & ~isnan(data.trialinfo(:, 14)));
    cfg.plotalltrials   = false;
    cfg.overlaymean     = true;
    % lock to int1
    locking(1).offset       = data.trialinfo(:, 4) - data.trialinfo(:, 1);
    locking(1).prestim      = 0;
    locking(1).poststim     = 6;
    locking(1).name         = 'int1';
    % adjust timings of the onset of next trial
    data.trialinfo(:,end) = data.trialinfo(:, end) - data.trialinfo(:, 1);
    cfg.whichLock = locking;
    if plot_ind
        subplot(3,4,cnt); cnt = cnt + 1;
    end
    [grandavg.dat(find(sj==subjects),:, :), grandavg.time, ~, ~] = get_EventRelated_timecourse(cfg, data, plot_ind);
    grandavg.rt(find(sj==subjects), 1) = nanmedian(data.trialinfo(find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) == sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0)), 8));
    grandavg.rt(find(sj==subjects), 2) = nanmedian(data.trialinfo(find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) ~= sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0)), 8));
    grandavg.est_rt(find(sj==subjects), 1) = nanmedian(data.trialinfo(find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) == sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0)), 14));
    grandavg.est_rt(find(sj==subjects), 2) = nanmedian(data.trialinfo(find((data.trialinfo(:, 5) == 1) & (data.trialinfo(:, 6) ~= sign(data.trialinfo(:,10))) & (data.trialinfo(:, 10) ~= 0)), 14));
    
    if plot_ind
        cols = linspecer(9, 'qualitative');
        colors = cols(3:4, :);
        axis tight; axis square;
        title(sprintf('P%02d', sj));
        % plot median RTs on top
        plot([0 0], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
        plot([0.75 0.75], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
        plot([2.75 2.75], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
        plot([3.5 3.5], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
        for r = 1:2
            plot([grandavg.rt(find(sj==subjects), r) + 0.75 grandavg.rt(find(sj==subjects), r) + 0.75], get(gca, 'ylim'), ':', 'color', colors(r, :), 'linewidth', 0.5);
        end
        for r = 1:2
            plot([grandavg.est_rt(find(sj==subjects), r) + 3.5 grandavg.est_rt(find(sj==subjects), r) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
        end
        offsetAxes;
    end
end
% compute the average
[significanttimewin] = stats_choiceVnochoice(grandavg.time, grandavg.dat(:, 1, :), grandavg.dat(:, 2, :));
grandavg.significanttimewin = significanttimewin;
if plot_ind
    subplot(3,4,cnt); hold on;
    for r = 1:2
        boundedline(grandavg.time, squeeze(nanmean(grandavg.dat(:, r, :))), squeeze(nanstd(grandavg.dat(:, r, :))) ./ sqrt(numel(subjects)), 'cmap', colors(r, :), 'alpha');
        axis tight;
        plot([mean(grandavg.rt(:, r)) + 0.75 mean(grandavg.rt(:, r)) + 0.75], get(gca, 'ylim'), ':', 'color', colors(r, :), 'linewidth', 0.5);
        plot([mean(grandavg.est_rt(:, r)) + 3.5 mean(grandavg.est_rt(:, r)) + 3.5], get(gca, 'ylim'), '-', 'color', colors(r, :), 'linewidth', 0.5);
    end
    axis tight; axis square;
    title('Grand Average');
    % plot median RTs on top
    plot([0 0], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
    plot([0.75 0.75], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
    plot([2.75 2.75], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
    plot([3.5 3.5], get(gca, 'ylim'), 'k', 'linewidth', 0.1);
    yval = min(get(gca, 'ylim')) * 1.1;
    plot(grandavg.time(significanttimewin), ones(size(significanttimewin)) * yval, 'k.');
    offsetAxes;
    suplabel('Pupil response (z)', 'y');
    suplabel('Time from interval 1 Onset (s)', 'x');
    close;
end
% get the single subject level pupil values from the significant timewindow
grandavg.subject_pupil_consistent = nanmean(grandavg.dat(:, 1, grandavg.significanttimewin),3);
grandavg.subject_pupil_inconsistent = nanmean(grandavg.dat(:, 2, grandavg.significanttimewin),3);
if savefile
    save(sprintf('%s/pupil_int1Locked_choiceTrials.mat', pupil_timecourse_dir), 'grandavg');
end
end

function [newmean, newlocktime, pretrial_bl, newlockdata] = get_EventRelated_timecourse(allcfg, data, plot_ind)
% in case of timelocked data:
% channel: which channels, these will be averaged over
% trials: structure with the name and the idx of trials that will be
% separately plotted

% set some defaults
if ~isfield(allcfg, 'trials'); allcfg.trials(1).idx = 1:length(data.trial); allcfg.trials(1).name = 'all'; end

% select only the channels to plot
cfg             = [];
cfg.channel     = allcfg.channel;
data            = ft_selectdata(cfg, data);

% do baseline correction using Anne's code
pretrial_bl = nan(length(allcfg.trials), 1);
for t = 1:length(data.trialinfo)
    startofref = data.trialinfo(t,4) - data.trialinfo(t,1);
    % use the 500ms before this (50 samples, resampled at 100Hz)
    try
        pretrial_bl(t) = mean(data.trial{t}(1, startofref-0.5*data.fsample:startofref));
    catch
        % in case there are not enough samples before that
        pretrial_bl(t) = mean(data.trial{t}(1, 1:startofref));
    end
    data.trial{t}(1, :) = data.trial{t}(1, :) - pretrial_bl(t); % subtract from whole trial
end
locking = allcfg.whichLock;
for l = 1:length(locking)
    disp(locking(l).name);
    % redefine trials
    cfg                 = [];
    cfg.begsample       = round(locking(l).offset - locking(l).prestim * data.fsample); % take offset into account
    % stop the trial either at the end of pre-defined post-stim period or the beginning of next trial.
    cfg.endsample       = min(round(locking(l).offset + locking(l).poststim * data.fsample), data.trialinfo(:,end));
    cfg.offset          = -locking(l).offset;
    ldata               = redefinetrial(cfg, data);
    cfg                 = [];
    cfg.keeptrials      = 'yes';
    cfg.vartrllength    = 2;
    lockdata{l}         = ft_timelockanalysis(cfg, ldata);
end

% append all into one timecourse
newlockdata = squeeze(lockdata{1}.trial);
newlocktime = squeeze(lockdata{1}.time);
% make means and std per subset of trials
newtime = newlocktime;
newmean = []; newsem = []; newlegend = {};
for t = 1:length(allcfg.trials)
    newmean = [newmean ; nanmean(newlockdata(allcfg.trials(t).idx, :))];
    newsem = [newsem ; nanstd(newlockdata(allcfg.trials(t).idx, :)) ./ sqrt(length(allcfg.trials(t).idx))];
    newlegend = [newlegend allcfg.trials(t).name];
end

if plot_ind
    % plot with shaded errorbars
    cols = linspecer(9, 'qualitative');
    colors = cols(3:4, :);
    hold on;
    if allcfg.plotalltrials
        if length(allcfg.trials) == 1
            % each line gets a different color
            plot(newtime, newlockdata(allcfg.trials(t).idx, :), 'linewidth', 0.5);
        else
            for t = 1:length(allcfg.trials)
                tmpp = plot(newtime, newlockdata(allcfg.trials(t).idx, :), 'color', colors(t,:));
                for tidx = 1:length(tmpp), tmpp(tidx).Color(4)  = 0.1; end
                p(t) = tmpp(1);
                newlegend = [newlegend allcfg.trials(t).name];
                if allcfg.overlaymean
                    plot(newtime, mean(newlockdata(allcfg.trials(t).idx, :)), 'k', 'linewidth', 1);
                end
            end
        end
    else
        p = boundedline(newtime, newmean, permute(newsem, [2 1 3]), 'cmap', colors);
    end
    axis tight;
end
end