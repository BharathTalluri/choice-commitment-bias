function s1_PupilPreprocess(sj)
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
% first script to run, will create one datafile per subject on which to do
% all the other analyses later

toolpath = '../Tools';
addpath(toolpath);
curr_dir = pwd;
if ischar(sj), sj = str2double(sj); end
ft_defaults;
warning off;
raw_pupil_dir = 'path/to/raw/pupil/files';
% make a directory to put preprocessed pupil files
preproc_pupil_dir = 'path/to/preprocessed/pupil/files';
% directory to find final pupil files
pupil_data_dir = '../../Data/Pupil';
% go to the right folder
cd(sprintf('%s/P%02d', raw_pupil_dir, sj));

% get pupil files
files = dir(sprintf('P%d_s*.asc', sj));

for file = 1:length(files)
    scandat     = sscanf(files(file).name, 'P%*d_s%d_b%d_%*d.asc');
    session     = scandat(1); block = scandat(2);
    mkdir(sprintf('%s/P%02d', preproc_pupil_dir, sj));
    
    if block == 0 % dummy pupil file, dont use now
        warning('skipping');
        continue
    end
    
    asc = read_eyelink_ascNK_AU(files(file).name);
    
    % create events and data structure, parse asc
    [data, event, blinksmp, saccsmp] = asc2dat(asc);
    
    % fix some files where two events were sent at exactly the same sample
    if strfind('P7_s2_b1_2015-01-22_17-07-29.asc', files(file).name)
        event = event([1:253 255 254 256:end]);
    elseif strfind('P14_s6_b5_2015-02-04_13-50-03.asc', files(file).name)
        event = event([1:471 473 472 474:end]);
    end
    
    % ==================================================================
    % blink interpolation
    % ==================================================================
    
    newpupil = blink_interpolate(data, blinksmp, 1);
    data.trial{1}(find(strcmp(data.label, 'EyePupil')==1),:) = newpupil;
    
    suplabel(sprintf('P%02d-S%d-b%d', sj, session, block), 't');
    saveas(gcf, sprintf('%s/P%02d/P%02d_s%d_b%d_preproc.pdf', preproc_pupil_dir, sj, sj, session, block), 'pdf');
    
    % ==================================================================
    % regress out pupil response to blinks and saccades
    % ==================================================================
    
    % for this, use only EL-defined blinksamples
    % dont add back slow drift for now - baseline doesn't make a lot of
    % sense after this anymore...
    addBackSlowDrift = 0;
    
    pupildata = data.trial{1}(~cellfun(@isempty, strfind(lower(data.label), 'eyepupil')),:);
    newpupil = blink_regressout(pupildata, data.fsample, blinksmp, saccsmp, 1, addBackSlowDrift);
    % put back in fieldtrip format
    data.trial{1}(~cellfun(@isempty, strfind(lower(data.label), 'eyepupil')),:) = newpupil;
    drawnow;
    saveas(gcf, sprintf('%s/P%02d/P%02d_s%d_b%d_projectout.pdf', preproc_pupil_dir, sj, sj, session, block), 'pdf');
    
    % ==================================================================
    % zscore since we work with the bandpassed signal
    % ==================================================================
    
    data.trial{1}(find(strcmp(data.label, 'EyePupil')==1),:) = zscore(data.trial{1}(find(strcmp(data.label, 'EyePupil')==1),:));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % define trials
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    cd(curr_dir)
    
    % same idea as for MEG data
    cfg                         = [];
    cfg.trialfun                = 'trialfun_EL_Commitment_fordeconv';
    cfg.trialdef.pre            = 0;
    cfg.trialdef.post           = 5; % seconds after feedback/estimation
    cfg.event                   = event;
    cfg.fsample                 = asc.fsample;
    cfg.sj                      = sj;
    cfg.session                 = session;
    cfg.spmversion = 'spm12';
    cfg                       = ft_definetrial(cfg);
    trialinfo                   = cfg.trl;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % downsample before saving
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    cfg             = [];
    cfg.spmversion = 'spm12';
    cfg.resamplefs  = 50; % the larger the sampling rate, the slower deconvolution gets
    cfg.detrend     = 'no';
    cfg.demean      = 'yes'; % will zscore per block anyway
    
    % convert the samples into resampled frequency
    samplerows              = [1 2 4 7 12 14 18]; % these have samples in them
    trialinfo(:,samplerows) = round(trialinfo(:,samplerows) * (cfg.resamplefs/data.fsample));
    blinksmp                = round(blinksmp .* (cfg.resamplefs/data.fsample));
    
    disp('resampling data...');
    data           = ft_resampledata(cfg, data);
    data.trialinfo = trialinfo;
    data.blinksmp  = blinksmp;
    
    disp(['Saving... ' sprintf('P%02d-S%02d_b%02d_eye.mat', sj, session, block)]);
    % save these datafiles before appending
    savefast(sprintf('%s/P%02d/P%02d-S%02d_b%02d_eye.mat', preproc_pupil_dir, sj, sj, session, block), 'data');
    
end % file

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% APPEND ALL DATA FOR THIS SJ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(sprintf('%s/P%02d', preproc_pupil_dir, sj));

eyelinkfiles        = dir('*_eye.mat');
% make sure these are in the right order!
% otherwise, indexing of trials will go awry
for f = 1:length(eyelinkfiles)
    scandat         = sscanf(eyelinkfiles(f).name, 'P%*d-S%02d_b%02d_eye.mat');
    snum(f,:)       = scandat';
end
[sorted, sortidx]   = sort(snum(:,1)); % sort by session
sorted(:,2)         = snum(sortidx, 2); % sort by block
eyelinkfiles        = eyelinkfiles(sortidx);

% append all
cfg = [];
cfg.inputfile   = {eyelinkfiles.name};
cfg.spmversion = 'spm12';
alldata         = ft_appenddata(cfg);

% also get a concatenated trialinfo
alltrl = []; allblink = [];
toAdd  = 0;
samplerows = [1 2 4 7 12 14 18]; % these have samples in them
samplefreq = [];
for f = 1:length(eyelinkfiles)
    clear data;
    load(eyelinkfiles(f).name);
    trl         = data.trialinfo;
    blinksmp    = data.blinksmp;
    
    % add the length of the session before
    trl(:, samplerows)  = trl(:, samplerows) + toAdd;
    blinksmp = blinksmp + toAdd;
    toAdd               = toAdd + numel(data.time{1});
    alltrl              = [alltrl; trl];
    allblink            = [allblink; blinksmp];
    samplefreq = [samplefreq data.fsample];
end

% some sanity checks to make sure that the samplefreq is indeed 50 Hz
if length(unique(samplefreq)) > 1
    keyboard
end

if unique(samplefreq) ~= 50
    keyboard
end

% remove weird trials
toremove = find(isnan(alltrl(:, 1)));
alltrl(toremove, :) = [];

% reappend
alldata.trialinfo          = alltrl;
alldata.fsample = unique(samplefreq);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% append trialinfo that can be used to epoch later
% we want to deconvolve on the full timecourse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data            = alldata;
data.trialinfo  = alltrl;
data.blinksmp   = allblink;

trial   = cat(2, data.trial{:});
time    = cat(2, data.time{:});
data    = rmfield(data, {'trial', 'time'});
data.trial{1}   = trial;
data.time{1}    = time;
data.fsample    = alldata.fsample;

savefast(sprintf('%s/P%02d_alleye.mat', pupil_data_dir, sj), 'data');
fprintf('Saved P%02d_alleye.mat \n\n', sj);

end