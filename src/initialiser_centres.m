function [centre, k_reel] = initialiser_centres(lab, k)
   
 [ligne,colonne,~] = size(lab);
  N=ligne*colonne;
  L=lab(:,:,1);
  A=lab(:,:,2);
  B=lab(:,:,3);

  S=floor(sqrt(N/k));

% initialisationn des centres
    pos=1;
    centre=zeros(k,5);
    for x=floor(S/2) :S:colonne
       for y=floor(S/2):S:ligne
          l=L(y,x);
          a=A(y,x);
          b=B(y,x);
            centre(pos,:)=[l,a,b,x,y];
            pos=pos+1;
        end
    end
    k_reel=pos-1;

    centre=centre(1:k_reel, :);
end