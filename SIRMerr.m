clear all;
global a r Rzero N b Morte;

k = 15; 
r = 1/k;

Rzero = 12;
N = 100000; 
a = Rzero/(k*N); 

Morte = 0.15; 

%calcolo dell'errore
h=10;
limite=10;
accS=0;
accI=0;
accR=0;
accM=0;


while (true)
    clear S I R M t n;
    S(1)=N-50; %suscettibili iniziali
    I(1)=50; %infetti iniziali
    R(1)=0; %rimossi iniziali
    M(1)=0; %morti iniziali
    n=1;
    t(1)=0;
    while t(n)<=limite-h 
            k1S = dS(t(n), S(n), I(n), R(n), M(n));
            k1I = dI(t(n), S(n), I(n), R(n), M(n));
            k1R = dR(t(n), S(n), I(n), R(n), M(n));
            k1M = dM(t(n), S(n), I(n), R(n), M(n));

            k2S = dS(t(n)+h/2, S(n)+h/2*k1S, I(n)+h/2*k1I, R(n)+h/2*k1R, M(n)+h/2*k1M);
            k2I = dI(t(n)+h/2, S(n)+h/2*k1S, I(n)+h/2*k1I, R(n)+h/2*k1R, M(n)+h/2*k1M);
            k2R = dR(t(n)+h/2, S(n)+h/2*k1S, I(n)+h/2*k1I, R(n)+h/2*k1R, M(n)+h/2*k1M);
            k2M = dM(t(n)+h/2, S(n)+h/2*k1S, I(n)+h/2*k1I, R(n)+h/2*k1R, M(n)+h/2*k1M);

            k3S = dS(t(n)+h/2, S(n)+h/2*k2S, I(n)+h/2*k2I, R(n)+h/2*k2R, M(n)+h/2*k2M);
            k3I = dI(t(n)+h/2, S(n)+h/2*k2S, I(n)+h/2*k2I, R(n)+h/2*k2R, M(n)+h/2*k2M);
            k3R = dR(t(n)+h/2, S(n)+h/2*k2S, I(n)+h/2*k2I, R(n)+h/2*k2R, M(n)+h/2*k2M);
            k3M = dM(t(n)+h/2, S(n)+h/2*k2S, I(n)+h/2*k2I, R(n)+h/2*k2R, M(n)+h/2*k2M);

            k4S = dS(t(n)+h, S(n)+h*k3S, I(n)+h*k3I, R(n)+h*k3R, M(n)+h*k3M);
            k4I = dI(t(n)+h, S(n)+h*k3S, I(n)+h*k3I, R(n)+h*k3R, M(n)+h*k3M);
            k4R = dR(t(n)+h, S(n)+h*k3S, I(n)+h*k3I, R(n)+h*k3R, M(n)+h*k3M);
            k4M = dM(t(n)+h, S(n)+h*k3S, I(n)+h*k3I, R(n)+h*k3R, M(n)+h*k3M);


            t(n+1) = t(n) + h;
            S(n+1) = S(n) + h/6*(k1S + 2*k2S + 2*k3S + k4S);
            I(n+1) = I(n) + h/6*(k1I + 2*k2I + 2*k3I + k4I);
            R(n+1) = R(n) + h/6*(k1R + 2*k2R + 2*k3R + k4R);
            M(n+1) = M(n) + h/6*(k1M + 2*k2M + 2*k3M + k4M);
       
            n = n+1;
    end
    
     if h~=10
        disp(['Confronto tra passo ',num2str(h*10,5),' e ',num2str(h,5)]);
        disp(['Distanza tra due passi successivi per S :',num2str(abs(S(n)-accS),5)]);
        disp(['Distanza tra due passi successivi per I :',num2str(abs(I(n)-accI),5)]);
        disp(['Distanza tra due passi successivi per R :',num2str(abs(R(n)-accR),5)]);
        disp(['Distanza tra due passi successivi per M :',num2str(abs(M(n)-accM),5)]);
        if input("Continuare con il nuovo passo? (1=si, 0=no)")==0
            break;
        else
            h = h/10;
            accS = S(n);
            accI = I(n);
            accR = R(n);
            accM = M(n);
        end
    else
        h = h/10;
        accS = S(n);
        accI = I(n);
        accR = R(n);
        accM = M(n);
    end
end