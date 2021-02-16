function [pupil_allTrials, pupil_choiceTrials] = subj_pupil_timecourses()

% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper.

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%%
% compute pupil timecourses for different conditions and save them

curr_dir = pwd;
channel = 'EyePupil';
dbstop if error;
myfigureprops;
subjects = [0 1 2 3 4 5 7 8 9 11 12 13 14 15];
rejectsj = [2 6 12 13];
subjects(rejectsj) = [];
% save timecourse file or not?
savefile = false;
% plot pupil timecourses for individual subjects?
plot_ind = false;

% get pupil timecourses

% timecourses, and subject specific pupil responses in significant time window for Choice and No-Choice trials
pupil_allTrials = pupil_EventRelated_allTrials(subjects,  channel, plot_ind, savefile);
% timecourses, and subject specific pupil responses in significant time window for Consistent and Inconsistent trials
pupil_choiceTrials = pupil_EventRelated_choiceTrials(subjects, channel, plot_ind, savefile);
end