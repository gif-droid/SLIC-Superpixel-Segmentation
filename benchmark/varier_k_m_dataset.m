function [BR_mat, ASA_mat] = varier_k_m_dataset(chemin_segs, chemin_gt, valeurs_k, valeurs_m, tolerance)
% Calcule BR et ASA sur tout le dataset en faisant varier K et m
% en lisant les segs deja calcules (pas de SLIC relance)
%
% INPUTS:
%   chemin_segs : chemin vers le dossier des segs sauvegardes
%   chemin_gt   : chemin vers le dossier des fichiers GT .mat
%   valeurs_k   : vecteur de valeurs de K
%   valeurs_m   : vecteur de valeurs de m
%   tolerance   : distance en pixels pour BR
%
% OUTPUTS:
%   BR_mat  : matrice BR moyen (nb_k x nb_m)
%   ASA_mat : matrice ASA moyen (nb_k x nb_m)

    nb_k = length(valeurs_k);
    nb_m = length(valeurs_m);

    % Lister les fichiers segs
    liste_segs = dir(fullfile(chemin_segs, '*.mat'));
    nb_images  = length(liste_segs);

    % Matrices pour accumuler les resultats
    BR_total  = zeros(nb_k, nb_m);
    ASA_total = zeros(nb_k, nb_m);

    for i = 1:nb_images

        % Charger les segs de cette image
        [~, nom, ~] = fileparts(liste_segs(i).name);
        data_segs   = load(fullfile(chemin_segs, liste_segs(i).name));

        % Charger le GT correspondant
        gt_fichier = fullfile(chemin_gt, [nom '.mat']);
        gt_data    = load(gt_fichier);

        fprintf('Image %d/%d — %s\n', i, nb_images, nom);

        for ik = 1:nb_k
            for im = 1:nb_m

                % Recuperer le label deja calcule
                label = data_segs.segs{ik, im};

                % Test label vide
                if isempty(label)
                    fprintf('LABEL VIDE : image=%s, ik=%d, im=%d\n', nom, ik, im);
                    continue;
                end

                % Calculer BR
                BR_total(ik, im) = BR_total(ik, im) + ...
                                   boundary_recall(label, gt_data.groundTruth, tolerance);

                % Calculer ASA
                asa = calcule_ASA(label, gt_data.groundTruth);

                % Test ASA vide
                if isempty(asa)
                    fprintf('ASA VIDE : image=%s, ik=%d, im=%d\n', nom, ik, im);
                    continue;
                end

                ASA_total(ik, im) = ASA_total(ik, im) + asa;

            end
        end
    end

    % Moyenne sur toutes les images
    BR_mat  = BR_total  / nb_images;
    ASA_mat = ASA_total / nb_images;

    fprintf('\nTRAITEMENT TERMINE\n');
end