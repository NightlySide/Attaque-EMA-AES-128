function new_key = key_schu(key,round)


Rcon=[1,2,4,8,16,32,64,128,27,54;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,0,0,0,0];
M=key;
new_key=key;
save=Subbytes(key(1,4));
for i= 2:4
    M(i-1,4)=Subbytes(M(i,4));
    
end
M(4,4)=save;


for j=1:4
    if j==1
        for k=1:4

        
        new_key(k,j)= bitxor(bitxor(key(k,j),M(k,4)),Rcon(k,round));
        end
    else
        for l=1:4
        new_key(l,j)=bitxor(key(l,j),new_key(l,j-1));
    
        end
    end
end

end
