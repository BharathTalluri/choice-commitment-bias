function [r_pooled, p_pooled] = pooled_rho(r1, r2, n1, n2)

% z_pooled = (atanh(r1)*sqrt((n1-3)) + atanh(r2)*sqrt((n2-3)))/2;
% p_pooled = 2*normcdf(-abs(z_pooled));
% r_pooled = tanh(z_pooled/sqrt(n1+n2-3));

% more principled approach
% inspired by: https://link.springer.com/content/pdf/10.3758/BF03334037.pdf

z1 = atanh(r1); % fisher transformation
var1 = n1-3;
z2 = atanh(r2);
var2 = n2-3;

z_pooled = (var1*z1 +var2*z2)/(var1 + var2);
r_pooled = tanh(z_pooled);
% convert fisher transformation to z_score and then estimate the p-value
p_pooled = 2*normcdf(-abs(z_pooled*sqrt(var1+var2)));
end