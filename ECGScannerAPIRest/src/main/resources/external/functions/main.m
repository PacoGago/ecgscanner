function[HASIL_AKHIRAVF,R] = main(x)

    Y = imread(x);
    [BW,rgb] = createMaskbr(Y);
    bw4 = bwareaopen(BW,1260);
    imbwaa = flip(bw4 ,1);
    [ k ] = thinning( imbwaa );

    %ld=0.00635; %factor de ajuste de amplitud en mm;
    ld=0.0483;

    target1R = 0;

    matches1 = k == target1R ;
    [x1, y1] = find(matches1);

    DATA =[y1, x1];
    sementara = unique(DATA,'rows');

    lsementara = length(sementara);
    jj = 1;
    for ii = 1 : lsementara
        if ii > 1
            if sementara(ii, 1) == sementara(ii - 1, 1)
                continue
            end
        end
        if ii < lsementara
            if sementara(ii, 1) == sementara(ii + 1, 1)
                sementara2(jj,1) = sementara(ii, 1);
                sementara2(jj,2) = max(sementara(ii, 2),sementara(ii + 1, 2));
            else
                sementara2(jj, 1) = sementara(ii, 1);
                sementara2(jj, 2) = sementara(ii, 2);
            end
        else
                sementara2(jj, 1) = sementara(ii, 1);
                sementara2(jj, 2) = sementara(ii, 2);
        end
        jj = jj + 1;
    end

    HASIL_AKHIRAVF = sementara2(:,2);
    HASIL_AKHIRAVF = (HASIL_AKHIRAVF)*ld;
    maksim = max(HASIL_AKHIRAVF);
    minim = min(HASIL_AKHIRAVF);
    media = median((HASIL_AKHIRAVF));
    HASIL_AKHIRAVF = HASIL_AKHIRAVF-media;
    TG=maksim-minim;
    R = ["","","",""]

    %fs = 500;
    %[qrs_pos,filt_dat,int_dat,thF1,thI1] = pantompkins_qrs(HASIL_AKHIRAVF,fs);
    fs=23; %fs=1%400;%figure(3)

    ejex= [0:length(HASIL_AKHIRAVF)-1]/fs;
    %subplot(2,1,1); imagesc(hasil_crop); hold on;
    %subplot(2,1,2); plot(ejex,HASIL_AKHIRAVF); xlim([0 max(ejex)]);grid on
    %xlabel('Periode (mm)');
    %ylabel('Amplitude (mm)');

    PJ=length(HASIL_AKHIRAVF)/fs;
    fs_papel=25;
    ffs=length(HASIL_AKHIRAVF)/TG;


    [qrs_pos,filt_dat,int_dat,thF1,thI1] = pantompkins_qrs(HASIL_AKHIRAVF,ffs);
    t_ultimo_latido=ejex(qrs_pos(end))/fs_papel
    tasa_cardiaca=60*length(qrs_pos)/t_ultimo_latido


    posicion_latidos=ejex(qrs_pos)/fs_papel
    RR=diff(posicion_latidos);
    dRR=diff(RR);
    dsRR=dRR.^2;
    N=length(dRR)-2;
    rMSSD=sqrt(sum(dsRR)/N);
    SDNN= std(RR);
    mRR=mean(RR);
    tiempo=0:1/ffs:TG-1/ffs;
    R(1,1) = tasa_cardiaca;
    R(1,2) = rMSSD;
    R(1,3) = SDNN;
    R(1,4) = mRR;

end
