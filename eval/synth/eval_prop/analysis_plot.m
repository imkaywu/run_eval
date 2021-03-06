% analyze the dependency between any two properties
clear, clc, close all;
addpath(genpath('../include'));

obj_name = 'sphere';
algs = {'ps', 'mvs', 'sl'};
props = {'tex', 'alb', 'spec', 'rough'};
pdir = 'C:/Users/Admin/Documents/3D_Recon/Data/synthetic_data'; % parent directory of the 3DRecon_Algo_Eval toolbox
rdir = sprintf('%s/%s', pdir, obj_name); % root directory of the dataset
ind = 2 : 3 : 8;

nplots = 3;
acc_mat = zeros(3, 3);
cmplt_mat = zeros(3, 3);
angle_mat = [];
legends = cell(2 * nplots, 1);

for aa = 1

adir = sprintf('%s/%s/pairwise/%s', pdir, obj_name, algs{aa});

for ii = 1 : numel(props) - 1
    
for jj = ii + 1 : numel(props)

prop_pair = sprintf('%s_%s', props{ii}, props{jj});

switch algs{aa}

case {'mvs', 'sl', 'vh'}
    
    for i = 1 : numel(ind)
        for j = 1 : numel(ind)
            idir = sprintf('%s/%s/%02d%02d', adir, prop_pair, ind(i), ind(j));
            fid = fopen(sprintf('%s/result.txt', idir));
            fscanf(fid, '%s', 1); acc_mat(i, j) = fscanf(fid, '%f', 1);
            fscanf(fid, '%s', 1); cmplt_mat(i, j) = fscanf(fid, '%f', 1);
        end
    end
case 'ps'
    angle_mat = [];
    for i = 1 : numel(ind)
        for j = 1 : numel(ind)
            idir = sprintf('%s/%s/%02d%02d', adir, prop_pair, ind(i), ind(j));
            data.rdir = rdir;
            data.idir = idir;
            eval_angle;
            angle_mat = [angle_mat, angle_prtl];
            clear norm_map
        end
    end
end

color = [241, 90, 90;
         240, 196, 25;
         78, 186, 111];
fig = figure;

switch algs{aa}

case {'mvs', 'sl', 'vh'}
    %{
    % for animation
    for i = 1 : numel(ind)
        subplot(2,1,1);
        eval(['p' num2str(i)]) = semilogy(ind(1)/10, acc_mat(1, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        xlim([0, 1]); ylim([0.01, 1]);
        xlabel(props{ii});
        ylabel('accuracy');
        legend(sprintf('%s: %.02f', props{jj}, ind(1)/10),...
               sprintf('%s: %.02f', props{jj}, ind(2)/10),...
               sprintf('%s: %.02f', props{jj}, ind(3)/10));
        subplot(2,1,2);
        eval(['p' num2str(i)]) = semilogy(ind(1)/10, cmplt_mat(1, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        xlim([0, 1]); ylim([0.01, 1]);
        xlabel(props{ii});
        ylabel('completeness');
        legend(sprintf('%s: %.02f', props{jj}, ind(1)/10),...
               sprintf('%s: %.02f', props{jj}, ind(2)/10),...
               sprintf('%s: %.02f', props{jj}, ind(3)/10));
    end
    for i = 1 : numel(ind)
        subplot(2,1,1);
        eval(['p' num2str(i)]) = semilogy(ind(2)/10, acc_mat(2, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        subplot(2,1,2);
        eval(['p' num2str(i)]) = semilogy(ind(2)/10, cmplt_mat(2, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
    end
    for i = 1 : numel(ind)
        subplot(2,1,1);
        eval(['p' num2str(i)]) = semilogy([ind(1), ind(2)]/10, acc_mat(1:2, i), '-'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        subplot(2,1,2);
        eval(['p' num2str(i)]) = semilogy([ind(1), ind(2)]/10, cmplt_mat(1:2, i), '-'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
    end
    for i = 1 : numel(ind)
        subplot(2,1,1);
        eval(['p' num2str(i)]) = semilogy(ind(3)/10, acc_mat(3, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        subplot(2,1,2);
        eval(['p' num2str(i)]) = semilogy(ind(3)/10, cmplt_mat(3, i), 'o'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
    end
    for i = 1 : numel(ind)
        subplot(2,1,1);
        eval(['p' num2str(i)]) = semilogy([ind(2), ind(3)]/10, acc_mat(2:3, i), '-'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
        subplot(2,1,2);
        eval(['p' num2str(i)]) = semilogy([ind(2), ind(3)]/10, cmplt_mat(2:3, i), '-'); hold on;
        set(eval(['p' num2str(i)]), 'LineWidth', 2, 'Color', color(i, :)/255);
    end
    %}
    % accuracy
    for i = 1 : numel(ind)
        p(i) = semilogy(ind ./ 10, acc_mat(:, i), 'ro-'); hold on;
        set(p(i), 'LineWidth', 1, 'Color', color(i, :)/255);
        legends{i} = sprintf('%0.2f', ind(i)/10);
    end
    % completeness
    for i = 1 : numel(ind)
        p(i + nplots) = semilogy(ind ./ 10, cmplt_mat(:, i), 'ro--'); hold on;
        set(p(i + nplots), 'LineWidth', 1, 'Color', color(i, :)/255);
        legends{i + nplots} = sprintf('%0.2f', ind(i)/10);
    end
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
            'title', sprintf('%s', props{jj}));
    xlabel(props{ii}, 'FontSize', 24);
    ylabel('accuracy/completeness', 'FontSize', 24);
    xlim([0, 1]);
    title(sprintf('%s: %s and %s', algs{aa}, props{ii}, props{jj}), 'FontSize', 24, 'FontWeight', 'bold');
    if(~exist(sprintf('%s/result/png', rdir), 'dir'))
        mkdir(sprintf('%s/result/png', rdir));
    end
%     saveas(fig, sprintf('%s/result/%s_%s.eps', rdir, algs{aa}, prop_pair), 'epsc2');
    saveas(fig, sprintf('%s/result/png/%s_%s.png', rdir, algs{aa}, prop_pair));
case 'ps'
    % angle difference
    if(~exist(sprintf('%s/result', rdir), 'dir'))
        mkdir(sprintf('%s/result', rdir));
    end
    x = angle_mat(:, [1, 4, 7]);
    y = angle_mat(:, [2, 5, 8]);
    z = angle_mat(:, [3, 6, 9]);
    legends = {'0.2', '0.5', '0.8'};
    angle_plot = cat(1, reshape(x,[1 size(x)]), reshape(y,[1 size(y)]), reshape(z,[1 size(z)]));
    p = aboxplot(angle_plot, 'labels', [0.2 0.5, 0.8]);
    [hl(1).leg, hl(1).obj, hl(1).hout, hl(1).mout] = ...
        legendflex(p, legends, ...
            'anchor', {'ne','ne'}, ...
            'buffer', [0 0], ...
            'fontsize',8, ...
            'xscale',0.5, ...
            'title', sprintf('%s', props{jj}));
    xlabel(props{ii}, 'FontSize', 24);
    ylabel('angle difference', 'FontSize', 24);
    title(sprintf('%s: %s and %s', algs{aa}, props{ii}, props{jj}), 'FontSize', 24, 'FontWeight', 'bold');
    if(~exist(sprintf('%s/result/0805', rdir), 'dir'))
        mkdir(sprintf('%s/result/0805', rdir));
    end
%     saveas(fig, sprintf('%s/%s/result/%s_%s.eps', rdir, obj_name, algs{aa}, prop_pair), 'epsc2');
    saveas(fig, sprintf('%s/result/0805/%s_%s.png', rdir, algs{aa}, prop_pair));
end

end % end of jj

end % enf of ii

end % enf of algs
