function ASA = calcule_ASA(label, verite_terrain)
% calcule l'achievable segmentation accuracy sur tous les GT
%
% entree:
%   label: matrice 2D de labels (sortie de SLIC_SIA2)
%   verite_terrain:cell array complete du fichier .mat GT
% 
% sortie:
%   ASA : valeur entre 0 et 1
    label = double(label);
    N = numel(label);
    % gt : groundtruth, verite terrain
    score_total = 0;
    nb_gt = numel(verite_terrain);
    % boucle sur tous les annotateurs
    for i = 1:nb_gt 
        gt = double(verite_terrain{i}.Segmentation);
        score_ann = 0;
        % boucle sur chaque superpixel
        for sp = 1:max(label(:))
            masque_superPixel= (label == sp);
            gt_dans_sp = gt(masque_superPixel);
            
            % label GT majoritaire dans ce superpixel
            [~,~,idx]=unique(gt_dans_sp);
            comptes= accumarray(idx, 1);
            score_ann= score_ann+ max(comptes);
        end
        
        score_total = score_total +(score_ann/N);
    end
    % moyenne sur tous les annotateurs
    ASA= score_total /nb_gt;
end