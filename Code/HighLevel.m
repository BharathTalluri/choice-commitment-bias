function HighLevel()
% Bharath Talluri & Anne Urai
% code accompanying the choice commitment bias paper. This code reproduces all
% the results and figures in the paper

%% # LICENSE
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

%% do some polishing and initialise variables
close all;clear;
clc; dbstop if error;
myfigureprops;
% specify the path to the data
toolpath = 'Tools/';
behav_codepath = 'Behavior/';
pupil_codepath = 'Pupil/';
addpath(toolpath);
addpath(behav_codepath);
addpath(pupil_codepath);


%% ANALYSIS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obtain the behavioural measures and generate Figure 1C, D.
psycho_fits_perceptual = behaviour_Perceptual();
psycho_fits_numerical = behaviour_Numerical();
bootstrap = 1; % this can be set to 1 if 66% confidence intervals for each subjects' parameter estimates are to be plotted.
% get model-free metrics for Figure 2 & Figure S2
roc_index_perceptual = modelFree_Perceptual(bootstrap);
roc_index_numerical = modelFree_Numerical(bootstrap);
% get model-based metrics for Figure 2 & Figure 3
globalgain_params_perceptual = modelBased_Perceptual_GlobalGain(psycho_fits_perceptual, bootstrap);
globalgain_params_numerical = modelBased_Numerical_GlobalGain(psycho_fits_numerical, bootstrap);
% get model-based metrics for selective gain model for Figure 4
selectivegain_params_perceptual = modelBased_Perceptual_ChoiceSelectiveGain(psycho_fits_perceptual, bootstrap);
selectivegain_params_numerical = modelBased_Numerical_ChoiceSelectiveGain(psycho_fits_numerical, bootstrap);
% get pupil metrics for Figure 5
[pupil_allTrials, pupil_choiceTrials] = subj_pupil_timecourses();

%% FIGURES %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myfigureprops;
% Figure 2
figure2(roc_index_perceptual, roc_index_numerical, globalgain_params_perceptual, globalgain_params_numerical);
% Figure 3
figure3(globalgain_params_perceptual, globalgain_params_numerical);
% Figure 4
figure4(globalgain_params_perceptual, globalgain_params_numerical, selectivegain_params_perceptual, selectivegain_params_numerical);
% Figure 5
figure5(pupil_allTrials, pupil_choiceTrials, globalgain_params_perceptual, selectivegain_params_perceptual);
% obtain the trial distribution and generate Figure S1
figureS1();