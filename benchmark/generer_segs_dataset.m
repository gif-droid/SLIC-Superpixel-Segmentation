function generer_segs_dataset(chemain_vers_image, chemin_segs, valeurs_k, valeurs_m)
% Applique SLIC une seule fois sur tout le dossier pour toutes les
% combinaisons K et m et sauvegarde les resultats en .mat
%
% INPUTS:
%   chemain_vers_image : chemin vers le dossier d'images .jpg
%   chemin_segs   : chemin vers le dossier ou sauvegarder les segs
%   valeurs_k     : vecteur de valeurs de K (ex: [50, 100, 200, 500])
%   valeurs_m     : vecteur de valeurs de m (ex: [1, 5, 10, 20, 40])

    % Creer le dossier de sauvegarde si inexistant
    if ~exist(chemin_segs, 'dir')
        mkdir(chemin_segs);
    end
    
    liste_images = dir(fullfile(chemain_vers_image, '*.jpg'));
    nb_images    = length(liste_images);
    nb_k         = length(valeurs_k);
    nb_m         = length(valeurs_m);
    total        = nb_images * nb_k * nb_m;
    compteur     = 0;
    
    for i = 1:nb_images
        % Charger l'image
        img = imread(fullfile(chemain_vers_image, liste_images(i).name));
        
        % Convertir en RGB si niveaux de gris
        if size(img, 3) == 1
            img = cat(3, img, img, img);
        end
        
        % Initialiser la cell array segs pour cette image
        segs = cell(nb_k, nb_m);
        
        for ik = 1:nb_k
            for im = 1:nb_m
                k = valeurs_k(ik);
                m = valeurs_m(im);
                compteur = compteur + 1;
                
                % Segmentation SLIC
                segs{ik, im} = SLIC_SIA2(img, k, m);
                
                fprintf('Image %d/%d | K=%d | m=%d | %d/%d\n', ...
                         i, nb_images, k, m, compteur, total);
            end
        end
        
        % Sauvegarder les segs de cette image
        [~, nom, ~] = fileparts(liste_images(i).name);
        save(fullfile(chemin_segs, [nom '.mat']), 'segs');
    end
    
    fprintf('\nSEGS SAUVEGARDES DANS : %s\n', chemin_segs);
end