function s_box=gen_s_box
    global m;
    global polyaes;
    Ta = gf([   [1 0 0 0 1 1 1 1];
            [1 1 0 0 0 1 1 1];
            [1 1 1 0 0 0 1 1];
            [1 1 1 1 0 0 0 1];
            [1 1 1 1 1 0 0 0];
            [0 1 1 1 1 1 0 0];
            [0 0 1 1 1 1 1 0];
            [0 0 0 1 1 1 1 1]   ],1);
    % Calcul de l'inverse
    %s_box = gf((1:2^m-1),m,polyaes).^(-1);
    s_box = gf(ones(1,2^m-1),m,polyaes)./gf((1:2^m-1),m,polyaes);
    s_box = [gf(0,m,polyaes) s_box];
    % Calcul de la fonction affine
    s_box = Ta*gf(de2bi(s_box.x','right-msb')',1)+gf([1;1;0;0;0;1;1;0],1)*ones(1,2^m);
    s_box = bi2de(s_box.x','right-msb');
end