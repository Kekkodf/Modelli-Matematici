clear all;
global a r Rzero N b Morte;

k = 15; % ...periodo di supposta contagiosità(media)
r = 1/k; % ...frequenza uscita dalla popolazione infetta (fattore di scala dopo il quale un infetto non lo è più 
          % ...e quindi esce dal conteggio degli infetti)

Rzero = 12; % ...un malato infetterà 12-18 persone (Wikipedia)
N = 100000; % ...popolazione 
a = Rzero/(k*N); % ...tasso di infezione

Morte = 0.15; % ...tasso mortalità Morbillo

%RK4 - Condizioni Iniziali e Procedura algoritmica                                

%	0	  |
%		  |
%	1/2 |1/2
%		  |
%	1/2 |0	    1/2
%		  |
%	1	  |0	     0	    1	     0
%		  |
%  ------------------------------------
%		  |1/6	1/3    1/3 	 	1/6
%		  |

h = 0.01; %...passo h
limite = 10; %...i primi 10 giorni dell'epitemia
n = 1;
t(1) = 0;
S(1) = N-50;
I(1) = 50;
R(1) = 0;
M(1) = 0;
N(1) = S(1) + I(1) + R(1);

figure
while (true) %di default faccio fare un primo calcolo per vedere l'esplosione dell'epidemia
    close all;
    while t(n)<=limite-h
      
      %...metodo RK
      
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


            S(n+1) = S(n) + h/6*(k1S + 2*k2S + 2*k3S + k4S); %...valore S
            I(n+1) = I(n) + h/6*(k1I + 2*k2I + 2*k3I + k4I); %...valore I
            R(n+1) = R(n) + h/6*(k1R + 2*k2R + 2*k3R + k4R); %...valore R
            M(n+1) = M(n) + h/6*(k1M + 2*k2M + 2*k3M + k4M); %...valore M
            N(n+1) = S(n) + I(n) + R(n);          %...Popolazione non morta
            t(n+1) = t(n) + h; %...incremento contatore per uscire dal while
            n = n + 1; %...incremento componente

  end
  
    %...ouput, mi interessa controllare i valori delle mie sottopopolazioni alla fine del periodo osservato
    disp(['[S(',num2str(limite,5),'), I(',num2str(limite,5),'), R(',num2str(limite,5),'), M(',num2str(limite,5),')] = ','[',num2str(S(n),10),', ',num2str(I(n),10),', ',num2str(R(n),10),', ',num2str(M(n),10),']']);
    disp(['[N(',num2str(limite,5),')]=','[',num2str(N(n),5),']']);
    disp(['[Calcolo indice R_t] = ','[', num2str((S(n)*Rzero)/N(n),5),']']); %...controllo l'indice R_t per vedere come
                                                                              ...si sviluppa l'epidemia.
    
    %...grafico della situazione una volta completato un certo periodo di osservazione
    plot(t,S);
    hold on;
    plot(t,I);
    plot(t,R);
    plot(t,M);
    plot(t,N);
    hold off;
    xlabel('Giorni trascorsi')
    ylabel('Popolazione')
    title('Diffusione del Morbillo su un campione di popolazione')
    legend('Suscettibili','Infetti','Guariti','Morti', 'Popolazione');
    legend('Orientation', 'vertical', 'Location', 'bestoutside');
    
    grid minor;
    
    if input("Continuare con il prossimo periodo? (1=sì - 0=no)")== 0 %...Iterazione nuova?
        break;
    else
        limite=limite+10; %...aumenta il periodo di altri 10 giorni
    end
end