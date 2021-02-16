# Choice-commitment Bias


This folder contains the code to reproduce the analyses and figures for the paper Talluri et al. 2021 JNeurophys.

Note:
1. Our model-based analyses use likelihood optimisation to find the appropriate parameters. Even though this method generally gives a unique solution which is ideally the global maximum, we recommend using multiple starting points (20-25 would be sufficient) to make sure the optimisation algorithm finds the global maximum.

2. We recommend parallelising the fitting procedure - by fitting each subject, and each iteration separately. This reduces the computational time. We fit the models on a supercomputing cluster by submitting multiple jobs, one per subject and starting point. Each job took around 4 hrs to compute the best fitting parameters.

3. Most of the tools required are included in the tools subfolder. For optimisation, we use the Subplex algorithm, a generalization of the Nelder-Mead simplex method, which is well suited to optimize high dimensional noisy objective functions. The code for this algorithm is available online (https://link.springer.com/article/10.3758%2FBF03206554). please cite the corresponding paper if you use this.
For further optimisation, we use fminsearchbnd, a matlab bound constrained optimisation algorithm available here (https://www.mathworks.com/matlabcentral/fileexchange/8277-fminsearchbnd-fminsearchcon).

4. The code was run on MATLAB R2019b. Analysing pupil data requires fieldtrip toolbox, and spm12 toolbox.

# LICENSE
 
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. If you use the Software for your own research, cite the paper.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
