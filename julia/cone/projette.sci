// fonction b_ronde  
function m=b_ronde(z)
m=toeplitz(z)+z(1)*eye(length(z),length(z))
endfunction    

// fonction de substitution arriere pour un cholesky O(n^2)
function x=back_sub(R,w) 
x=zeros(w);
n=size(w,1);
x(n)=w(n)/R(n,n);
for i=(n-1):-1:1
    x(i)=(w(i)-R(i,i+1:n)*x(i+1:n)) / R(i,i)
end
endfunction
// fonction de substitution avant pour un cholesky O(n^2)
function w=for_sub(R,g)
w=zeros(g);
n=size(g,1);
w(1)=g(1)/R(1,1);
for i=2:n
  w(i)=(g(i)-R(1:i-1,i)'*w(1:i-1)) / R(i,i)
end
endfunction

// fonction de calcul de l'inverse d'un cholesky 
function R=inv_chol(L) 
n=size(L,1);
R=zeros(n,n);
for j=n:-1:1
    R(j,j)=1. / L(j,j);
    for i=j-1:-1:1
        R(i,j)=-L(i,i+1:j)*R(i+1:j,j) / L(i,i)
    end
end
endfunction 
   
// fonction de calcul de la hessienne par fourier
function [H,g] = calc_diffs(x,prec)
tmp=inv_chol(chol(b_ronde(-x)));
n=size(tmp,1);
N=round(2^(1+ceil(log(n)/log(2))));
r=zeros(N,n);
r(1:n,:)=tmp;
R=zeros(N,1);
accu1=zeros(N,N);
accu2=zeros(N,N);
accu3=zeros(N,1);
for j=1:n
  R=fft(r(:,j),-1)
  accu1=accu1+R*R';
  accu2=accu2+R*conj(R');
  accu3=accu3+R.*conj(R);
end
accu1=accu1.*conj(accu1)+accu2.*conj(accu2);
// defourierisons une premiere fois suivant les colonnes...
H=zeros(n,n);
for j=1:N
  r(:,j)=fft(accu1(:,j),1);
end
// puis une seconde sur les lignes...
for j=1:n
  tmp=fft(r(j,:),1);
  H(j,:)=2*real(tmp(1:n));
  H=(abs(H)>=prec).*H; 
end
g=2*fft(accu3,1);
g=real(g(1:n,1));
//g=(abs(g)>=prec).*g;
endfunction


// algorithme de résolution d'un problème de projection 
// calcul min_x   ||x-r||^2  
//            x  \in \Cau^o 
// mu <- facteur d'augmentation du paramètre de la barrière
// ep <-precision souhaite pour le test d'arret
function sol=projette_polaire(x0,mu,ep)
n=length(x0);
x=[-0.5; zeros(n-1,1)];
y=n;

// boucle generale exterieure, on trace le chemin central en
// fonction de t
//valeur initiale de t;
t=1;
flag=%F;
out_loop=0;
printf(" Out.|     t         | In. |    <x0-x,x>   | \n");
printf("--------------------------------------------\n");
while(~flag)
    //Boucle de Newton
    flag_new=%F;
    in_loop=0;
    while(~flag_new)
       [H2,g2]=calc_diffs(x,ep);
       // Hessien de L_n+2
       den = 1. ./(y.^2 - sum((x-x0).^2));
       g1x   = 2*(x-x0) *den;
       g1y   = -2*y*den; 
       dyg1x = -4*y*(x-x0) *den*den;
       H1xx =4*den*den*(x-x0)*(x-x0)'+2*eye(n,n)*den;
       d2g1y =4*den*den*y*y-2*den; 
       // on calcul le decrement de Newton 
       // a l'aide d'un facteur cholesky 
       g=[g1x+g2;t+g1y] 
       R=chol([H1xx+H2 dyg1x; dyg1x' d2g1y]);
       w=for_sub(R,-g); 
       flag_new=(w'*w<=ep);    
       d_xy=back_sub(R,w);
       //On fait le pas de Newton
       pas =1. /(1+sqrt(w'*w)); 
       x = x + pas*d_xy(1:n);
       y = y + pas*d_xy(n+1); 
       in_loop=in_loop + 1;
    end    
   out_loop= out_loop +1;
   printf(" %3d | %e  | %3d | %e  |\n",out_loop,t,in_loop,(x0-x)'*x);
   // (\theta_1 + \theta_2)/t <ep
   flag=(( n + 2)/ t < ep);
   // on met à jour t
   t=mu*t; 
end
sol=x;
endfunction


projette_polaire(rand(100,1),2.,1e-3)
