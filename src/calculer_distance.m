function D = calculer_distance(l,a,b,x,y,c,m,S)
% Distance combinant couleur LAB et position spatiale
% Dc est distance couleur,  Ds est distance spatiale
% D qui est la distance entre un pixel et un centre

    Dc= sqrt((l - c(1))^2 + (a - c(2))^2 + (b - c(3))^2);
    Ds= sqrt((x - c(4))^2 + (y - c(5))^2);
    D = sqrt(Dc^2 + (m/S)^2 * Ds^2);
end

