function myscatter(x, y, errorbars, markersize, markercolor, xeColor, yeColor, errlinewidth)

% Bharath Talluri
if numel(xeColor) == 3
    xeColor = repmat(xeColor, length(x),1);
end
if numel(yeColor) == 3
    yeColor = repmat(yeColor, length(x),1);
end

if numel(markercolor) == 3
    scatter(x, y, markersize, 'filled', 'MarkerEdgeColor',[1 1 1], 'MarkerFaceColor', markercolor, 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);hold on;
else
    scatter(x, y, markersize, markercolor, 'filled', 'MarkerEdgeColor',[1 1 1], 'MarkerFaceAlpha',.75,'MarkerEdgeAlpha',.75);hold on;
end

if ~isempty(errorbars)
    xe1 = errorbars(:,1);xe2 = errorbars(:,2);ye1 = errorbars(:,3);ye2 = errorbars(:,4);
    for i = 1:length(x)
        plot([xe1(i) xe2(i)], [y(i) y(i)], 'Color', xeColor(i,:),'LineWidth',errlinewidth);
        plot([x(i) x(i)], [ye1(i)  ye2(i)], 'Color', yeColor(i,:),'LineWidth',errlinewidth);
    end
end

