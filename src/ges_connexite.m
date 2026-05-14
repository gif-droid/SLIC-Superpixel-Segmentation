function label =ges_connexite(label, k_reel)
    % Pour chaque label, garder uniquement la plus grande composante
    % et reassigner les petites au voisin le plus proche
    
    label_n = label;
    
    for i = 1:k_reel
        % Masque binaire du superpixel i
        masque = (label == i);
        
        % Trouver les composantes connexes
        CC = bwconncomp(masque, 8);  %8 connexite
        
        if CC.NumObjects <= 1
            continue;  % Pas de fragmentation, on passe
        end
        
        % Garder la plus grande composante
        tailles = cellfun(@numel, CC.PixelIdxList);
        [~, idx_max] = max(tailles);
        
        % Reassigner les petites composantes
        for j = 1:CC.NumObjects
            if j == idx_max
                continue;
            end
            % Pour chaque pixel isole, trouver le label voisin
            for p = 1:numel(CC.PixelIdxList{j})
                px=CC.PixelIdxList{j}(p);
                [lig, col]=ind2sub(size(label), px);
                
                % Chercher un voisin valide (8-connexites)
                voisins = [];
                if lig > 1
                    voisins(end+1)=label(lig-1, col);
                end
                if lig < size(label,1)
                    voisins(end+1)=label(lig+1, col);
                end
                if col > 1
                    voisins(end+1)=label(lig, col-1);
                end
                if col < size(label,2)
                    voisins(end+1)=label(lig, col+1); 
                end
                if lig > 1 && col > 1
                    voisins(end+1)=label(lig-1, col-1);
                end
                if lig > 1 && col < size(label,2)
                    voisins(end+1)=label(lig-1, col+1);
                end
                if lig < size(label,1) && col > 1
                    voisins(end+1)=label(lig+1, col-1); 
                end
                if lig < size(label,1) && col < size(label,2)
                    voisins(end+1)=label(lig+1, col+1); 
                end

                
                voisins = voisins(voisins ~= i);  % Exclure le label courant
                if ~isempty(voisins)
                    label_n(lig, col) = mode(voisins);  % Label majoritaire
                end
            end
        end
    end
    
    label = label_n;
end