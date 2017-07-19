% performance of each technique under all properties and the combinations
% graphs are separated in different plots
clear, clc, close all;
addpath(genpath('../include/'));

obj_name = 'sphere';
% algs = {'ps'};
props = {'tex', 'alb', 'spec', 'rough', 'concav'};
ind_eff_props = logical([1, 1, 1, 0, 0; 0, 1, 1, 1, 0; 0, 1, 1, 1, 0]);
rdir = sprintf('C:/Users/Admin/Documents/3D_Recon/Data/synthetic_data/%s', obj_name);
ref_dir = '../../ref_obj';
gt_dir = '../../groundtruth';
ind = 2 : 3 : 8;

mvs_acc_mat = zeros(3, 3, 3);
mvs_cmplt_mat = zeros(3, 3, 3);
sl_acc_mat = zeros(3, 3, 3);
sl_cmplt_mat = zeros(3, 3, 3);
angle_cell = cell(3, 3, 3);

for ii = 1 : numel(ind)

for jj = 1 : numel(ind)

for kk = 1 : numel(ind)
    
    % mvs
    dir = sprintf('%s/train/mvs/%02d%02d%02d00', rdir, ind(ii), ind(jj), ind(kk));
    fid = fopen(sprintf('%s/result.txt', dir));
    fscanf(fid, '%s', 1); mvs_acc_mat(ii, jj, kk) = fscanf(fid, '%f', 1);
    fscanf(fid, '%s', 1); mvs_cmplt_mat(ii, jj, kk) = fscanf(fid, '%f', 1);
    
    % sl
    dir = sprintf('%s/train/sl/00%02d%02d%02d', rdir, ind(ii), ind(jj), ind(kk));
    fid = fopen(sprintf('%s/result.txt', dir));
    fscanf(fid, '%s', 1); sl_acc_mat(ii, jj, kk) = fscanf(fid, '%f', 1);
    fscanf(fid, '%s', 1); sl_cmplt_mat(ii, jj, kk) = fscanf(fid, '%f', 1);
    
    % ps
    dir = sprintf('%s/train/ps/00%02d%02d%02d', rdir, ind(ii), ind(jj), ind(kk));
    data.rdir = rdir;
    data.dir = dir;
    eval_angle;
    angle_cell{ii, jj, kk} = angle;
    clear norm_map

end % end of ii

end % end of jj

end % end of kk

nplots = 3;
color = distinguishable_colors(nplots);
legends = cell(2 * nplots, 1);

%% plot mvs
% x-axis: text, line: alb, plot: spec
labels = {props{1}, props{2}, props{3}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, mvs_acc_mat(:, j, i), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, mvs_cmplt_mat(:, j, i), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{2 * j} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/mvs_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: alb, line: spec, plot: texture
labels = {props{2}, props{3}, props{1}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, mvs_acc_mat(i, :, j), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, mvs_cmplt_mat(i, :, j), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j + nplots} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/mvs_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: spec, line: texture, plot: alb
labels = {props{3}, props{1}, props{2}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, reshape(mvs_acc_mat(j, i, :), 3, 1), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, reshape(mvs_cmplt_mat(j, i, :), 3, 1), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j + nplots} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/mvs_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

%% plot sl
% x-axis: alb, line: spec, plot: rough
labels = {props{2}, props{3}, props{4}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, sl_acc_mat(:, j, i), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, sl_cmplt_mat(:, j, i), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{2 * j} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/sl_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: spec, line: rough, plot: alb
labels = {props{3}, props{4}, props{2}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, sl_acc_mat(i, :, j), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, sl_cmplt_mat(i, :, j), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j + nplots} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/sl_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: rough, line: alb, plot: spec
labels = {props{4}, props{2}, props{3}};
for i = 1 : 3 % plot
    fig = figure;
    for j = 1 : 3 % line
        p(j) = semilogy(ind ./ 10, reshape(sl_acc_mat(j, i, :), 3, 1), 'ro-'); hold on;
        set(p(j), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j} = sprintf('%0.2f', ind(j)/10);
        p(j + nplots) = semilogy(ind ./ 10, reshape(sl_cmplt_mat(j, i, :), 3, 1), 'ro--'); hold on;
        set(p(j + nplots), 'LineWidth', 1.5, 'Color', color(j, :));
        legends{j + nplots} = sprintf('%0.2f', ind(j)/10);
    end
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24, 'FontWeight', 'bold');
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p([1, 1 + nplots]), {'accuracy', 'completeness'}, ...
            'anchor', {'ne','se'}, ...
            'buffer', [0 0], ...
            'fontsize', 8', ...
            'title', 'Line');
    [hl(2).leg, hl(2).obj, hl(2).hout, hl(2).mout] = ...
        legendflex(p(1 : nplots), legends(1 : nplots), ...
            'ref', hl(1).leg, ...
            'anchor', {'se','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/sl_train_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

%% plot ps
% group means boxes with the same colour
legends = cell(nplots, 1);
% x-axis: alb, box (group): spec, plot: rough
labels = {props{2}, props{3}, props{4}};
for i = 1 : 3 % plot
    fig = figure;
    x = []; y = []; z = [];
    for j = 1 : 3 % x-axis
        x = [x, angle_cell{j, 1, i}]; % group 1
        y = [y, angle_cell{j, 2, i}]; % group 2
        z = [z, angle_cell{j, 3, i}]; % group 3
        legends{j} = sprintf('%.02f', ind(j)/10);
    end
    angle_plot = cat(1, reshape(x,[1 size(x)]), reshape(y,[1 size(y)]), reshape(z,[1 size(z)]));
    p = aboxplot(angle_plot, 'labels', [0.2 0.5, 0.8]);
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('angle difference', 'FontSize', 24);
    ylim([0, 45]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24);
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p, legends, ...
            'anchor', {'ne','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/ps_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: spec, box (group): rough, plot: alb
labels = {props{3}, props{4}, props{2}};
for i = 1 : 3 % plot
    fig = figure;
    x = []; y = []; z = [];
    for j = 1 : 3 % x-axis
        x = [x, angle_cell{i, j, 1}];
        y = [y, angle_cell{i, j, 2}];
        z = [z, angle_cell{i, j, 3}];
        legends{j} = sprintf('%.02f', ind(j)/10);
    end
    angle_plot = cat(1, reshape(x,[1 size(x)]), reshape(y,[1 size(y)]), reshape(z,[1 size(z)]));
    p = aboxplot(angle_plot, 'labels', [0.2 0.5, 0.8]);
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('angle difference', 'FontSize', 24);
    ylim([0, 45]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24);
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p, legends, ...
            'anchor', {'ne','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/ps_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end

% x-axis: rough, box (group): alb, plot: spec
labels = {props{4}, props{2}, props{3}};
for i = 1 : 3 % plot
    fig = figure;
    x = []; y = []; z = [];
    for j = 1 : 3 % x-axis
        x = [x, angle_cell{1, i, j}];
        y = [y, angle_cell{2, i, j}];
        z = [z, angle_cell{3, i, j}];
        legends{j} = sprintf('%.02f', ind(j)/10);
    end
    angle_plot = cat(1, reshape(x,[1 size(x)]), reshape(y,[1 size(y)]), reshape(z,[1 size(z)]));
    p = aboxplot(angle_plot, 'labels', [0.2 0.5, 0.8]);
    xlabel(labels{1}, 'FontSize', 24);
    ylabel('angle difference', 'FontSize', 24);
    ylim([0, 45]);
    title(sprintf('%s: %0.2f', labels{3}, ind(i)/10), 'FontSize', 24);
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p, legends, ...
            'anchor', {'ne','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', labels{2}));
    saveas(fig, sprintf('%s/result/ps_%s_%02d.eps', rdir, labels{3}, ind(i)), 'epsc2');
    close(fig);
end
