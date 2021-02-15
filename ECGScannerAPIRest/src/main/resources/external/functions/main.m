function[HASIL_AKHIRAVF] = main(x)

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

    %fs = 500;
    %[qrs_pos,filt_dat,int_dat,thF1,thI1] = pantompkins_qrs(HASIL_AKHIRAVF,fs);

end
