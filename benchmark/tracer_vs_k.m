function tracer_vs_k(valeurs_k, BR_mat, ASA_mat, valeurs_m, titre)
% Trace les courbes BR et ASA en fonction de K pour chaque valeur de m
%
% INPUTS:
%   valeurs_k : vecteur de valeurs de K
%   BR_mat    : matrice BR (nb_k x nb_m) issue de varier_k_m_dataset
%   ASA_mat   : matrice ASA (nb_k x nb_m) issue de varier_k_m_dataset
%   valeurs_m : vecteur de valeurs de m (pour la legende)
%   titre     : titre du graphique (ex: 'Dataset train')

    couleurs = lines(length(valeurs_m));
    
    figure;
    
    % Courbes BR
    subplot(1, 2, 1);
    hold on;
    for im = 1:length(valeurs_m)
        plot(valeurs_k, BR_mat(:, im), ...
             '-o', 'Color', couleurs(im,:), ...
             'LineWidth', 1.5, 'MarkerSize', 6, ...
             'DisplayName', sprintf('m=%d', valeurs_m(im)));
    end
    xlabel('K (nombre de superpixels)');
    ylabel('BR');
    title(sprintf('BR vs K - %s', titre));
    legend('Location', 'southeast');
    grid on;
    hold off;
    
    % Courbes ASA
    subplot(1, 2, 2);
    hold on;
    for im = 1:length(valeurs_m)
        plot(valeurs_k, ASA_mat(:, im), ...
             '-o', 'Color', couleurs(im,:), ...
             'LineWidth', 1.5, 'MarkerSize', 6, ...
             'DisplayName', sprintf('m=%d', valeurs_m(im)));
    end
    xlabel('K (nombre de superpixels)');
    ylabel('ASA');
    title(sprintf('ASA vs K - %s', titre));
    legend('Location', 'southeast');
    grid on;
    hold off;
    
    sgtitle(titre);
end