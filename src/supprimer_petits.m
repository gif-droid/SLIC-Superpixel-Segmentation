function [label] = supprimer_petits(label, taille_min)
    % taille_min : taille minimale en pixels
    
    props = regionprops(label, 'Area', 'PixelIdxList');
    
    for i = 1:numel(props)
        if props(i).Area < taille_min
            % Reassigner au voisin le plus frequent
            for p = 1:numel(props(i).PixelIdxList)
                px = props(i).PixelIdxList(p);
                [lig, col] = ind2sub(size(label), px);
                voisins=[];
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
                voisins=voisins(voisins ~= i);
                if ~isempty(voisins)
                    label(lig, col)=mode(voisins);
                end
            end
        end
    end
end