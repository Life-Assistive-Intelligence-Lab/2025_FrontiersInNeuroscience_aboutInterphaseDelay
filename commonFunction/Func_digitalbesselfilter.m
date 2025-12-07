% Bessel filtering
% This filter was used for the analysis of pulse waveforms.

function [num,den,varargout] = Func_digitalbesselfilter(n,fs,fc)
    Wc = fc * 2 * pi();
    Wc = 2*fs*tan(Wc/(2*fs));
    [num,den]=analogbesselfilter(n,Wc);
    if nargout == 3
        W = logspace(-1,log10(fs),10^6);
        tempFigure = figure;
        analog_grpdelay(num,den,W);
        delay = get(findobj('parent',gca,'type','line'),'ydata');
        radian = get(findobj('parent',gca,'type','line'),'xdata');
        [~,Index] = min(radian-Wc/2);
        groupDelay = delay(Index)*fs;
        delete(tempFigure)
        varargout{1} = groupDelay;
        
        [num,den] = my_bilinear(num,den,fs);
    elseif nargout == 2
        [num,den] = my_bilinear(num,den,fs);
    else
        error('The output does not match.')
    end
end

function [num,den]=analogbesselfilter(n,Wc)

    num = invbesselpoly(n)*[zeros(n,1);1];
    num = [zeros(1,n),num];
    
    den=besselpoly(n);
    for i=0:n
         den(i+1)=den(i+1)/Wc^i;
    end
    den=fliplr(den);
    num = num/den(1);
    den = den/den(1);
end

function InvPolyVec=invbesselpoly(n)
    InvPolyVec=fliplr(besselpoly(n));
end

function PolyVec=besselpoly(n)
    for k=0:n
	    PolyVec(k+1)=factorial(2*n-k)/(factorial(n-k)*factorial(k)*2^(n-k));
    end
end


function analog_grpdelay(num,den,W)
    H = my_freqs(num,den,W);
    P = unwrap(angle(H));
    G = diff(P)./diff(W);
    plot(W(2:end),-G)
    xlabel('Frequency (rad/sec)')
    ylabel('Group Delay (sec)')
    title('Analog Filter Group Delay')
    grid on
end