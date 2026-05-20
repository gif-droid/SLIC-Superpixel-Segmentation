function tracer_vs_m(valeurs_m, BR_mat, ASA_mat, valeurs_k, titre)
% Trace les courbes BR et ASA en fonction de m pour chaque valeur de K
%
% INPUTS:
%   valeurs_m : vecteur de valeurs de m
%   BR_mat    : matrice BR (nb_k x nb_m) issue de varier_k_m_dataset
%   ASA_mat   : matrice ASA (nb_k x nb_m) issue de varier_k_m_dataset
%   valeurs_k : vecteur de valeurs de K (pour la legende)
%   titre     : titre du graphique (ex: 'Dataset train')

    couleurs = lines(length(valeurs_k));
    
    figure;
    
    % Courbes BR
    subplot(1, 2, 1);
    hold on;
    for ik = 1:length(valeurs_k)
        plot(valeurs_m, BR_mat(ik, :), ...
             '-o', 'Color', couleurs(ik,:), ...
             'LineWidth', 1.5, 'MarkerSize', 6, ...
             'DisplayName', sprintf('K=%d', valeurs_k(ik)));
    end
    xlabel('m (compacite)');
    ylabel('BR');
    title(sprintf('BR vs m - %s', titre));
    legend('Location', 'best');
    grid on;
    hold off;
    
    % Courbes ASA
    subplot(1, 2, 2);
    hold on;
    for ik = 1:length(valeurs_k)
        plot(valeurs_m, ASA_mat(ik, :), ...
             '-o', 'Color', couleurs(ik,:), ...
             'LineWidth', 1.5, 'MarkerSize', 6, ...
             'DisplayName', sprintf('K=%d', valeurs_k(ik)));
    end
    xlabel('m (compacite)');
    ylabel('ASA');
    title(sprintf('ASA vs m - %s', titre));
    legend('Location', 'best');
    grid on;
    hold off;
    
    sgtitle(titre);
end